def is_high_value(asset):
    return asset["purchase_price"] > 1500


def asset_summary(asset):
    return f'{asset["name"]} | {asset["type"]} | {asset["status"]}'


def get_asset_price(asset):
    try:
        return asset["purchase_price"]
    except KeyError:
        return "Price unavailable"