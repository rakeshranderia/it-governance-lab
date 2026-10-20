# Module 5 — Learning Notes

Module 4 consumed an API. Module 5 built one.

```text
GET    → read
POST   → create
PATCH  → partial update
DELETE → delete
```

FastAPI maps HTTP methods and routes to Python functions.

Pydantic validates incoming request bodies and drives the generated Swagger documentation.

`/assets/{asset_id}` demonstrated path parameters, while `/assets?status_filter=Active` demonstrated query parameters.

The HTML page reinforced the distinction between machine-friendly JSON and human-friendly presentation.

The deliberate limitation is that data is still in memory. Module 6 introduces persistence.
