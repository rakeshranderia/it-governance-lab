from decimal import Decimal

import requests
from psycopg.types.json import Jsonb

from api.db import get_connection


SOURCE_SYSTEM = "dummyjson"
SOURCE_URL = "https://dummyjson.com/products/category/laptops"


def normalise_status(stock: int) -> str:
    if stock <= 0:
        return "Out of Stock"

    if stock < 5:
        return "Low Stock"

    return "Available"


def transform_product(product: dict) -> dict:
    return {
        "source_system": SOURCE_SYSTEM,
        "source_record_id": str(product["id"]),
        "name": product["title"],
        "type": "Laptop",
        "status": normalise_status(int(product.get("stock", 0))),
        "purchase_price": Decimal(str(product["price"])),
        "source_payload": product,
    }


def fetch_external_products() -> list[dict]:
    response = requests.get(
        SOURCE_URL,
        timeout=15,
    )
    response.raise_for_status()

    payload = response.json()
    return payload.get("products", [])


def upsert_external_assets(records: list[dict]) -> int:
    if not records:
        return 0

    sql = """
        INSERT INTO external_assets (
            source_system,
            source_record_id,
            name,
            type,
            status,
            purchase_price,
            source_payload
        )
        VALUES (%s, %s, %s, %s, %s, %s, %s)
        ON CONFLICT (source_system, source_record_id)
        DO UPDATE SET
            name = EXCLUDED.name,
            type = EXCLUDED.type,
            status = EXCLUDED.status,
            purchase_price = EXCLUDED.purchase_price,
            source_payload = EXCLUDED.source_payload,
            updated_at = CURRENT_TIMESTAMP
    """

    with get_connection() as connection:
        with connection.cursor() as cursor:
            for record in records:
                cursor.execute(
                    sql,
                    (
                        record["source_system"],
                        record["source_record_id"],
                        record["name"],
                        record["type"],
                        record["status"],
                        record["purchase_price"],
                        Jsonb(record["source_payload"]),
                    ),
                )

        connection.commit()

    return len(records)


def run_import() -> dict:
    raw_products = fetch_external_products()

    transformed = [
        transform_product(product)
        for product in raw_products
    ]

    processed = upsert_external_assets(transformed)

    return {
        "source": SOURCE_SYSTEM,
        "fetched": len(raw_products),
        "processed": processed,
    }
