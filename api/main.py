from pathlib import Path

from fastapi import FastAPI, HTTPException, status
from fastapi.responses import HTMLResponse
from pydantic import BaseModel


app = FastAPI(
    title="IT Governance Lab API",
    version="0.1.0"
)


class AssetCreate(BaseModel):
    name: str
    type: str
    status: str
    purchase_price: float


assets = [
    {
        "id": 1,
        "name": "Laptop-001",
        "type": "Laptop",
        "status": "Active",
        "purchase_price": 1850.50
    },
    {
        "id": 2,
        "name": "Monitor-001",
        "type": "Monitor",
        "status": "Repair",
        "purchase_price": 650.00
    },
    {
        "id": 3,
        "name": "Phone-001",
        "type": "Mobile",
        "status": "In Stock",
        "purchase_price": 1200.00
    }
]


@app.get("/")
def root():
    return {
        "message": "IT Governance Lab API",
        "status": "running"
    }


@app.get("/health")
def health():
    return {
        "status": "healthy"
    }


@app.get("/assets")
def get_assets(status_filter: str | None = None):
    if status_filter is None:
        return assets

    return [
        asset
        for asset in assets
        if asset["status"].lower() == status_filter.lower()
    ]


@app.post("/assets", status_code=status.HTTP_201_CREATED)
def create_asset(new_asset: AssetCreate):
    next_id = max(asset["id"] for asset in assets) + 1 if assets else 1

    asset = {
        "id": next_id,
        "name": new_asset.name,
        "type": new_asset.type,
        "status": new_asset.status,
        "purchase_price": new_asset.purchase_price
    }

    assets.append(asset)
    return asset


@app.get("/assets-page", response_class=HTMLResponse)
def assets_page():
    template_path = Path(__file__).parent / "assets_page.html"
    html = template_path.read_text(encoding="utf-8")

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


@app.get("/assets/{asset_id}")
def get_asset(asset_id: int):
    for asset in assets:
        if asset["id"] == asset_id:
            return asset

    raise HTTPException(
        status_code=404,
        detail="Asset not found"
    )
