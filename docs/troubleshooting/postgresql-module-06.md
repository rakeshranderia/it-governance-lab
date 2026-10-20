# PostgreSQL — Module 6 Troubleshooting

## `psql` not recognised

PostgreSQL may be installed but its `bin` directory may not be on `PATH`.

Check:

```powershell
where.exe psql
Get-Service *postgres*
```

The bootstrap script also searches common PostgreSQL installation directories.

## PowerShell execution policy

A `Process`-scope bypass applies only to one PowerShell terminal.

For a persistent user-level lab setting:

```powershell
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned
```

Check:

```powershell
Get-ExecutionPolicy -List
```

## Environment variables are per terminal

Database environment variables set in one PowerShell terminal do not automatically exist in another.

The Uvicorn terminal needs:

```text
PGHOST
PGPORT
PGDATABASE
PGUSER
PGPASSWORD
```

The HTTP smoke-test terminal does not need them because it talks to FastAPI rather than PostgreSQL directly.

## Uvicorn terminal appears unusable

That terminal is occupied by the running server process.

Use one terminal for Uvicorn and another for commands.

## Decimal values

A PostgreSQL `NUMERIC` value may appear in Python as:

```text
Decimal('1850.50')
```

This is expected.

## Persistence verification

If an asset survives a Uvicorn restart, PostgreSQL persistence is working.

If it disappears, check whether the API is still using an in-memory list instead of database queries.
