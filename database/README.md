# PostgreSQL — Module 6

Module 6 replaces the in-memory FastAPI asset list with PostgreSQL persistence.

## Database objects

```text
database: assetlab
application login: assetapp
table: assets
```

The application login is deliberately separate from the PostgreSQL administrator account.

## Files

- `01_bootstrap.sql` — database/login/schema/index/seed bootstrap.
- `02_verify.sql` — verifies connectivity and sample data.
- `03_postgres_features.sql` — PostgreSQL-specific examples such as `ILIKE`, `RETURNING`, upsert and transactions.

## Schema

The `assets` table uses:

```text
BIGINT GENERATED ALWAYS AS IDENTITY
VARCHAR
NUMERIC(10,2)
TIMESTAMPTZ
NOT NULL
UNIQUE
CHECK
PRIMARY KEY
```

Indexes are created on `status` and `type`.

## SQL coverage

For publication completeness, Module 6 covers:

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

Hands-on execution can move quickly through concepts already familiar to the learner.
