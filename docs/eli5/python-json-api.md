# ELI5 — Python, JSON and APIs

A Python dictionary describes one object:

```python
asset = {
    "name": "Laptop-001",
    "status": "Active"
}
```

A Python list holds several objects.

JSON uses almost the same shapes:

```text
JSON object → Python dictionary
JSON array  → Python list
```

An API lets one system ask another system for data or an action.

```text
Python
→ HTTP GET
→ API server
→ HTTP 200
→ JSON
→ Python data
```

Common status codes:

```text
200 → success
404 → not found
500 → server/application error
```

Module 4 consumed an API.

Module 5 will build one with FastAPI.
