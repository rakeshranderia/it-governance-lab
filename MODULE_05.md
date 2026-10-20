# Module 5 — FastAPI

## Objective

Build a small CRUD HTTP API from the Python fundamentals covered in Module 4.

## Completed

```text
GET
POST
PATCH
DELETE
path parameters
query parameters
Pydantic validation
HTTP status codes
404 handling
Swagger/OpenAPI
HTML/CSS presentation
```

## Request flow

```text
client
→ Uvicorn
→ FastAPI route
→ Python function
→ JSON/HTML response
```

## Routes

- `GET /assets` — read all assets.
- `GET /assets?status_filter=Active` — filter using a query parameter.
- `GET /assets/{asset_id}` — read one asset using a path parameter.
- `POST /assets` — create an asset and return `201 Created`.
- `PATCH /assets/{asset_id}` — partially update an asset.
- `DELETE /assets/{asset_id}` — remove an asset and return `204 No Content`.
- `GET /assets-page` — human-friendly HTML/CSS table.
- `GET /docs` — Swagger UI.

## Common status codes

```text
200 OK
201 Created
204 No Content
404 Not Found
422 Unprocessable Entity
```

## Development server

Windows:

```powershell
python\.venv\Scripts\python.exe -m uvicorn api.main:app --reload
```

The Uvicorn terminal must remain running.

## Current limitation

Assets live only in a Python list, so changes are lost when the process restarts.

Module 6 replaces this with PostgreSQL persistence.

## Module 5 complete

**Commit checkpoint:** `Complete Module 5 FastAPI CRUD`
