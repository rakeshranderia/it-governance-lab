param(
    [string]$HostName = "localhost",
    [int]$Port = 5432,
    [string]$AdminUser = "postgres"
)

$ErrorActionPreference = "Stop"

$psqlCommand = Get-Command psql -ErrorAction SilentlyContinue

if ($psqlCommand) {
    $psql = $psqlCommand.Source
}
else {
    $candidates = Get-ChildItem "C:\Program Files\PostgreSQL" -Directory -ErrorAction SilentlyContinue |
        Sort-Object Name -Descending |
        ForEach-Object { Join-Path $_.FullName "bin\psql.exe" } |
        Where-Object { Test-Path $_ }

    $psql = $candidates | Select-Object -First 1
}

if (-not $psql) {
    throw "psql.exe was not found."
}

$repoRoot = Split-Path -Parent $PSScriptRoot
$bootstrapSql = Join-Path $repoRoot "database\01_bootstrap.sql"
$verifySql = Join-Path $repoRoot "database\02_verify.sql"

function Convert-ToPlainText {
    param([Security.SecureString]$SecureValue)

    $ptr = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($SecureValue)
    try {
        return [Runtime.InteropServices.Marshal]::PtrToStringBSTR($ptr)
    }
    finally {
        [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($ptr)
    }
}

$adminSecure = Read-Host "Password for PostgreSQL admin user '$AdminUser'" -AsSecureString
$appSecure = Read-Host "Choose a password for application user 'assetapp'" -AsSecureString

$adminPassword = Convert-ToPlainText $adminSecure
$appPassword = Convert-ToPlainText $appSecure

try {
    $env:PGPASSWORD = $adminPassword

    & $psql -h $HostName -p $Port -U $AdminUser -d postgres `
        -v ON_ERROR_STOP=1 `
        -v "app_password=$appPassword" `
        -f $bootstrapSql

    if ($LASTEXITCODE -ne 0) {
        throw "PostgreSQL bootstrap failed with exit code $LASTEXITCODE."
    }

    $env:PGPASSWORD = $appPassword

    & $psql -h $HostName -p $Port -U assetapp -d assetlab `
        -v ON_ERROR_STOP=1 `
        -f $verifySql

    if ($LASTEXITCODE -ne 0) {
        throw "PostgreSQL verification failed with exit code $LASTEXITCODE."
    }
}
finally {
    Remove-Item Env:PGPASSWORD -ErrorAction SilentlyContinue
    $adminPassword = $null
    $appPassword = $null
}
