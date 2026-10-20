# Module 6 — PostgreSQL Request Flow

```text
Browser / Swagger / script
        |
        v
   HTTP request
        |
        v
      Uvicorn
        |
        v
      FastAPI
        |
        v
      api/db.py
        |
        v
      psycopg
        |
        v
   PostgreSQL :5432
        |
        v
     assetlab
        |
        v
      assets
```

For write operations:

```text
POST / PATCH / DELETE
→ parameterised SQL
→ transaction
→ COMMIT
→ persistent state
```

For failed writes:

```text
error
→ ROLLBACK
→ database remains consistent
```
