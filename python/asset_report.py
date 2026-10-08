import json
from pathlib import Path

from asset_utils import is_high_value, asset_summary, get_asset_price


def load_assets():
    file_path = Path(__file__).parent / "assets.json"

    try:
        with open(file_path, "r", encoding="utf-8") as file:
            return json.load(file)

    except FileNotFoundError:
        print("Asset file not found.")
        return []

    except json.JSONDecodeError:
        print("Asset file contains invalid JSON.")
        return []


def main():
    assets = load_assets()

    print("Asset Report")
    print("============")

    for asset in assets:
        print(asset_summary(asset))
        print("Price:", get_asset_price(asset))

        if is_high_value(asset):
            print("High-value asset")

        print()


if __name__ == "__main__":
    main()