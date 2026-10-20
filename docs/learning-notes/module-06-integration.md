# Module 6 — FastAPI + PostgreSQL Integration Notes

## What changed

Module 5 stored assets in a Python list.

Module 6 moves persistence into PostgreSQL:

```text
HTTP client
→ FastAPI
→ parameterised SQL
→ PostgreSQL
→ persistent data
```

## Driver

The application uses:

```text
psycopg
```

with dictionary rows so FastAPI can return query results directly as JSON-compatible objects.

## Parameterised queries

Values are passed separately from SQL:

```python
cursor.execute(
    "SELECT * FROM assets WHERE id = %s",
    (asset_id,)
)
```

This is safer than building SQL values into strings.

## RETURNING

PostgreSQL `RETURNING` is used to return rows immediately after:

```text
INSERT
UPDATE
DELETE
```

This keeps API responses aligned with the actual database result.

## Transactions

Writes explicitly:

```text
commit
```

on success and:

```text
rollback
```

on failure.

## Persistence test

The key milestone is:

```text
create/update/delete asset
→ restart Uvicorn
→ database state remains changed
```
