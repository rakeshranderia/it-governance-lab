# PostgreSQL — Module 6

This directory contains the PostgreSQL bootstrap and verification scripts.

## Files

- `01_bootstrap.sql` — creates the `assetapp` login, `assetlab` database, `assets` table, indexes and seed data.
- `02_verify.sql` — verifies the database, login and sample data.

## Windows quick start

From the repository root:

```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
.\scripts\module6-postgres-bootstrap.ps1
```

The script prompts for the PostgreSQL `postgres` administrator password and a password for the dedicated `assetapp` login.

Passwords are not written to the repository.

## Python connectivity test

Install the driver:

```powershell
python\.venv\Scripts\python.exe -m pip install "psycopg[binary]"
```

Set connection variables for the current PowerShell session:

```powershell
.\scripts\module6-postgres-session.ps1
```

Then run:

```powershell
python\.venv\Scripts\python.exe api\db_check.py
```
