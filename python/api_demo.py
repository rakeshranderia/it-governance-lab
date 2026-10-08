import requests


url = "https://jsonplaceholder.typicode.com/todos/1"

try:
    response = requests.get(url, timeout=10)

    print("HTTP status:", response.status_code)

    response.raise_for_status()

    data = response.json()

    print("\nJSON response:")
    print(data)

    print("\nSelected fields:")
    print("ID:", data["id"])
    print("Title:", data["title"])
    print("Completed:", data["completed"])

except requests.RequestException as error:
    print("API request failed:")
    print(error)


print("\nList response example:")

list_url = "https://jsonplaceholder.typicode.com/todos?userId=1"

try:
    response = requests.get(list_url, timeout=10)

    print("HTTP status:", response.status_code)

    response.raise_for_status()

    todos = response.json()

    print("Number of records:", len(todos))

    for todo in todos[:5]:
        print(
            todo["id"],
            "-",
            todo["title"],
            "- completed:",
            todo["completed"]
        )

except requests.RequestException as error:
    print("API list request failed:")
    print(error)