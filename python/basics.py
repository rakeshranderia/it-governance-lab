asset_name = "Laptop-001"
asset_type = "Laptop"
status = "Active"
purchase_price = 1850.50
assigned = True

print(asset_name)
print(asset_type)
print(status)
print(purchase_price)
print(assigned)


asset_id = 1

print(type(asset_id))
print(type(asset_name))
print(type(purchase_price))
print(type(assigned))

if status == "Active":
    print("Asset is currently in use")
else:
    print("Asset is not currently active")

if assigned:
    print("Asset has been assigned")
else:
    print("Asset is available")

if purchase_price > 1500:
    print("High-value asset")
else:
    print("Standard-value asset")


# A list holds multiple values
asset_types = ["Laptop", "Monitor", "Mobile"]

print(asset_types)
print(asset_types[0])
print(asset_types[1])


# A dictionary stores named values
asset = {
    "id": 1,
    "name": "Laptop-001",
    "type": "Laptop",
    "status": "Active",
    "purchase_price": 1850.50,
    "assigned": True
}

print(asset)
print(asset["name"])
print(asset["status"])


# A function packages a reusable rule
def is_high_value(asset):
    return asset["purchase_price"] > 1500
def asset_summary(asset):
    return f'{asset["name"]} | {asset["type"]} | {asset["status"]}'

def get_asset_price(asset):
    try:
        return asset["purchase_price"]
    except KeyError:
        return "Price unavailable"

# A list of dictionaries represents multiple assets
assets = [
    {
        "id": 1,
        "name": "Laptop-001",
        "type": "Laptop",
        "status": "Active",
        "purchase_price": 1850.50,
        "assigned": True
    },
    {
        "id": 2,
        "name": "Monitor-001",
        "type": "Monitor",
        "status": "Repair",
        "purchase_price": 650.00,
        "assigned": False
    },
    {
        "id": 3,
        "name": "Phone-001",
        "type": "Mobile",
        "status": "In Stock",
        "purchase_price": 1200.00,
        "assigned": False
    }
]

print("\nAll assets:")

for asset in assets:
    print(asset_summary(asset))


print("\nHigh-value assets:")

for asset in assets:
    if is_high_value(asset):
        print(asset["name"], "-", asset["purchase_price"])


test_asset = {
    "id": 4,
    "name": "Keyboard-001",
    "type": "Peripheral",
    "status": "In Stock"
}

print("\nException test:")
print(test_asset["name"], "-", get_asset_price(test_asset))