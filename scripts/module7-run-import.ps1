$ErrorActionPreference = "Stop"

Write-Host "`n=== Module 7 external integration ==="

if (-not $env:PGHOST -or -not $env:PGPORT -or -not $env:PGDATABASE -or -not $env:PGUSER -or -not $env:PGPASSWORD) {
    throw "PostgreSQL environment variables are not set. Run .\scripts\module6-postgres-session.ps1 in this terminal first."
}

python\.venv\Scripts\python.exe -m integration.ingest_external_assets

if ($LASTEXITCODE -ne 0) {
    throw "Module 7 import failed with exit code $LASTEXITCODE."
}
