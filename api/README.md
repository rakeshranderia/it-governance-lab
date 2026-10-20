# API

The FastAPI application now uses PostgreSQL for persistence.

## Current structure

```text
api/main.py
→ routes and HTTP behaviour

api/db.py
→ PostgreSQL connection helper

api/assets_page.html
→ human-friendly presentation
```

## Environment variables

The application expects:

```text
PGHOST
PGPORT
PGDATABASE
PGUSER
PGPASSWORD
```

Use:

```powershell
.\scripts\module6-postgres-session.ps1
```

to set them for the current PowerShell session.

## Run

```powershell
python\.venv\Scripts\python.exe -m uvicorn api.main:app --reload
```

## Persistence milestone

Unlike Module 5, data is now stored in PostgreSQL.

A Uvicorn restart should not remove created, updated or deleted asset records.
