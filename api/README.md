# API

The FastAPI application now uses PostgreSQL for persistence.

## Structure

```text
api/main.py
→ FastAPI routes and HTTP behaviour

api/db.py
→ PostgreSQL connection helper

api/assets_page.html
→ human-friendly HTML/CSS presentation

api/db_check.py
→ direct Python-to-PostgreSQL connectivity test
```

## Environment variables

```text
PGHOST
PGPORT
PGDATABASE
PGUSER
PGPASSWORD
```

Set them for the current PowerShell session with:

```powershell
.\scripts\module6-postgres-session.ps1
```

## Run

```powershell
python\.venv\Scripts\python.exe -m uvicorn api.main:app --reload
```

The key Module 6 milestone is persistence: data survives a Uvicorn restart because PostgreSQL, not Python memory, owns the state.
