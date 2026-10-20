# Module 6 — PostgreSQL

## Objective

Move the FastAPI Asset Register from in-memory data to a relational PostgreSQL database and establish practical database application patterns.

## Outcome

Module 6 demonstrates:

```text
PostgreSQL installation
database and application role creation
relational table design
constraints
indexes
seed data
Python database connectivity
parameterised SQL
transactions
FastAPI persistence
PostgreSQL-specific features
```

## Architecture

```text
HTTP client
→ Uvicorn
→ FastAPI
→ psycopg
→ PostgreSQL
→ persistent data
```

## Database

```text
database: assetlab
application login: assetapp
table: assets
```

The application does not use the PostgreSQL administrator account.

## Schema concepts

The table demonstrates:

- generated identity primary key;
- `NOT NULL`;
- unique asset names;
- non-negative price `CHECK`;
- `NUMERIC(10,2)` for price;
- timezone-aware timestamps;
- indexes on frequently filtered fields.

## SQL curriculum

The published module includes:

```text
CREATE TABLE
INSERT
SELECT
WHERE
ORDER BY
UPDATE
DELETE
JOIN
UNION
constraints
indexes
transactions
```

The hands-on flow may skip detailed repetition where the learner already has SQL experience.

## PostgreSQL-specific features

Examples include:

```text
GENERATED ... AS IDENTITY
RETURNING
ILIKE
ON CONFLICT
EXCLUDED
TIMESTAMPTZ
```

## Parameterised queries

Application values are never concatenated directly into SQL.

Example:

```python
cursor.execute(
    "SELECT * FROM assets WHERE id = %s",
    (asset_id,)
)
```

## Transactions

Write operations commit on success and roll back on failure.

This was demonstrated conceptually and is visible in the FastAPI write paths.

## Persistence proof

The practical test was:

```text
POST asset
→ PATCH asset
→ restart Uvicorn
→ GET asset successfully
→ DELETE asset
→ GET returns 404
```

This proves PostgreSQL owns the application state.

## Health behaviour

`GET /health` now checks database reachability rather than only returning a static response.

A database connectivity failure returns `503 Service Unavailable`.

## Module 6 complete

The Asset Register now has durable relational persistence.

**Commit checkpoint:** `Complete Module 6 PostgreSQL persistence`
