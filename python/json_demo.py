import json


assets = [
    {
        "id": 1,
        "name": "Laptop-001",
        "type": "Laptop",
        "status": "Active"
    },
    {
        "id": 2,
        "name": "Monitor-001",
        "type": "Monitor",
        "status": "Repair"
    }
]


# Convert Python data into JSON text
json_text = json.dumps(assets, indent=4)

print("Python data converted to JSON:")
print(json_text)


# Convert JSON text back into Python data
python_data = json.loads(json_text)

print("\nJSON converted back into Python:")
print(python_data)


print("\nFirst asset name:")
print(python_data[0]["name"])