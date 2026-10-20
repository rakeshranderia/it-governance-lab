# ELI5 — PostgreSQL Persistence

In Module 5, FastAPI kept assets in its own memory.

That meant:

```text
FastAPI stops
→ memory disappears
→ new assets disappear
```

PostgreSQL gives the application a separate place to store state:

```text
client
→ FastAPI
→ PostgreSQL
```

Now:

```text
FastAPI stops
→ PostgreSQL keeps running
→ data remains
```

## Database vs application

FastAPI decides what the API should do.

PostgreSQL stores and retrieves the data.

## Application account

The application uses `assetapp` instead of the PostgreSQL administrator account.

This is similar to giving an application its own service account instead of letting it run as an administrator.

## Parameterised query

Instead of building SQL by joining text and user input, values are passed separately.

This is safer and easier for the database driver to handle correctly.

## Transaction

A transaction groups database changes.

```text
commit
→ keep the changes

rollback
→ undo the changes
```

## Index

An index is an extra structure that helps PostgreSQL find matching rows faster, at the cost of some storage and write overhead.
