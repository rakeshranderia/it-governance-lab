from pathlib import Path

from fastapi import FastAPI, HTTPException, Response, status
from fastapi.responses import HTMLResponse
from pydantic import BaseModel

from api.db import get_connection


app = FastAPI(
    title="IT Governance Lab API",
    version="0.2.0"
)


class AssetCreate(BaseModel):
    name: str
    type: str
    status: str
    purchase_price: float


class AssetUpdate(BaseModel):
    name: str | None = None
    type: str | None = None
    status: str | None = None
    purchase_price: float | None = None


@app.get("/")
def root():
    return {
        "message": "IT Governance Lab API",
        "status": "running",
        "storage": "PostgreSQL"
    }


@app.get("/health")
def health():
    try:
        with get_connection() as connection:
            with connection.cursor() as cursor:
                cursor.execute("SELECT 1")
                cursor.fetchone()

        return {
            "status": "healthy",
            "database": "reachable"
        }

    except Exception as exc:
        raise HTTPException(
            status_code=status.HTTP_503_SERVICE_UNAVAILABLE,
            detail=f"Database unavailable: {exc}"
        ) from exc


@app.get("/assets")
def get_assets(status_filter: str | None = None):
    with get_connection() as connection:
        with connection.cursor() as cursor:
            if status_filter is None:
                cursor.execute(
                    """
                    SELECT
                        id,
                        name,
                        type,
                        status,
                        purchase_price
                    FROM assets
                    ORDER BY id
                    """
                )
            else:
                cursor.execute(
                    """
                    SELECT
                        id,
                        name,
                        type,
                        status,
                        purchase_price
                    FROM assets
                    WHERE LOWER(status) = LOWER(%s)
                    ORDER BY id
                    """,
                    (status_filter,)
                )

            return cursor.fetchall()


@app.get("/assets/{asset_id}")
def get_asset(asset_id: int):
    with get_connection() as connection:
        with connection.cursor() as cursor:
            cursor.execute(
                """
                SELECT
                    id,
                    name,
                    type,
                    status,
                    purchase_price
                FROM assets
                WHERE id = %s
                """,
                (asset_id,)
            )

            asset = cursor.fetchone()

    if asset is None:
        raise HTTPException(
            status_code=404,
            detail="Asset not found"
        )

    return asset


@app.post("/assets", status_code=status.HTTP_201_CREATED)
def create_asset(new_asset: AssetCreate):
    with get_connection() as connection:
        with connection.cursor() as cursor:
            try:
                cursor.execute(
                    """
                    INSERT INTO assets (
                        name,
                        type,
                        status,
                        purchase_price
                    )
                    VALUES (%s, %s, %s, %s)
                    RETURNING
                        id,
                        name,
                        type,
                        status,
                        purchase_price
                    """,
                    (
                        new_asset.name,
                        new_asset.type,
                        new_asset.status,
                        new_asset.purchase_price
                    )
                )

                asset = cursor.fetchone()
                connection.commit()
                return asset

            except Exception:
                connection.rollback()
                raise


@app.patch("/assets/{asset_id}")
def update_asset(asset_id: int, changes: AssetUpdate):
    updates = changes.model_dump(exclude_unset=True)

    if not updates:
        raise HTTPException(
            status_code=400,
            detail="No fields supplied for update"
        )

    allowed_fields = {
        "name",
        "type",
        "status",
        "purchase_price"
    }

    if not set(updates).issubset(allowed_fields):
        raise HTTPException(
            status_code=400,
            detail="Unsupported field supplied"
        )

    assignments = []
    values = []

    for field, value in updates.items():
        assignments.append(f"{field} = %s")
        values.append(value)

    assignments.append("updated_at = CURRENT_TIMESTAMP")
    values.append(asset_id)

    sql = f"""
        UPDATE assets
        SET {", ".join(assignments)}
        WHERE id = %s
        RETURNING
            id,
            name,
            type,
            status,
            purchase_price
    """

    with get_connection() as connection:
        with connection.cursor() as cursor:
            cursor.execute(sql, tuple(values))
            asset = cursor.fetchone()

            if asset is None:
                connection.rollback()
                raise HTTPException(
                    status_code=404,
                    detail="Asset not found"
                )

            connection.commit()
            return asset


@app.delete("/assets/{asset_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_asset(asset_id: int):
    with get_connection() as connection:
        with connection.cursor() as cursor:
            cursor.execute(
                """
                DELETE FROM assets
                WHERE id = %s
                RETURNING id
                """,
                (asset_id,)
            )

            deleted = cursor.fetchone()

            if deleted is None:
                connection.rollback()
                raise HTTPException(
                    status_code=404,
                    detail="Asset not found"
                )

            connection.commit()

    return Response(status_code=status.HTTP_204_NO_CONTENT)


@app.get("/assets-page", response_class=HTMLResponse)
def assets_page():
    template_path = Path(__file__).parent / "assets_page.html"
    html = template_path.read_text(encoding="utf-8")

    with get_connection() as connection:
        with connection.cursor() as cursor:
            cursor.execute(
                """
                SELECT
                    id,
                    name,
                    type,
                    status,
                    purchase_price
                FROM assets
                ORDER BY id
                """
            )
            assets = cursor.fetchall()

    rows = []

    for asset in assets:
        rows.append(
            "<tr>"
            f"<td>{asset['id']}</td>"
            f"<td>{asset['name']}</td>"
            f"<td>{asset['type']}</td>"
            f"<td>{asset['status']}</td>"
            f"<td>${asset['purchase_price']:.2f}</td>"
            "</tr>"
        )

    return html.replace("__ASSET_ROWS__", "".join(rows))
