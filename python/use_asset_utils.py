from asset_utils import is_high_value, asset_summary, get_asset_price


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
    }
]


def main():
    for asset in assets:
        print(asset_summary(asset))

        if is_high_value(asset):
            print("High-value asset")

        print("Price:", get_asset_price(asset))
        print()


if __name__ == "__main__":
    main()