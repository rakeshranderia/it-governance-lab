# Module 6 — Learning Notes

## Main change

Module 5:

```text
FastAPI
→ Python list
→ process memory
```

Module 6:

```text
FastAPI
→ psycopg
→ PostgreSQL
→ durable state
```

## Application login

A dedicated `assetapp` login is used instead of the PostgreSQL administrator account.

This separates database administration from application access.

## Parameterised SQL

Values are supplied separately from SQL text.

This improves correctness and reduces SQL injection risk.

## PostgreSQL features

The module introduces PostgreSQL-specific patterns such as:

```text
RETURNING
ILIKE
ON CONFLICT
GENERATED ALWAYS AS IDENTITY
TIMESTAMPTZ
```

## Money-like values

`NUMERIC(10,2)` is returned to Python as `Decimal`.

That is expected and avoids binary floating-point precision issues for fixed-precision values.

## Persistence milestone

The strongest proof was not a SELECT query.

It was:

```text
create data
→ restart the application
→ data still exists
```

The storage boundary is now clearly outside the FastAPI process.
