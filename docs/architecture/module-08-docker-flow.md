# Module 8 — Docker Architecture

```text
Windows host
    |
    | HTTP 127.0.0.1:8000
    v
+--------------------------+
| Docker Desktop           |
|                          |
|  api container           |
|  FastAPI / Uvicorn       |
|        |                 |
|        | db:5432         |
|        v                 |
|  db container            |
|  PostgreSQL 17           |
|        |                 |
|        v                 |
|  postgres_data volume    |
+--------------------------+
```

Failure path:

```text
db stopped
→ Docker service unavailable
→ FastAPI process remains up
→ database health check fails
```

Recovery path:

```text
docker compose start db
→ PostgreSQL starts
→ health recovers
→ FastAPI queries work again
```
