param(
    [string]$HostName = "localhost",
    [int]$Port = 5432,
    [string]$Database = "assetlab",
    [string]$User = "assetapp"
)

$ErrorActionPreference = "Stop"

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

$securePassword = Read-Host "Password for PostgreSQL user '$User'" -AsSecureString
$plainPassword = Convert-ToPlainText $securePassword

$env:PGHOST = $HostName
$env:PGPORT = "$Port"
$env:PGDATABASE = $Database
$env:PGUSER = $User
$env:PGPASSWORD = $plainPassword

Write-Host ""
Write-Host "PostgreSQL environment variables are now set for THIS PowerShell session."
Write-Host "PGHOST=$env:PGHOST"
Write-Host "PGPORT=$env:PGPORT"
Write-Host "PGDATABASE=$env:PGDATABASE"
Write-Host "PGUSER=$env:PGUSER"
Write-Host "PGPASSWORD=<set in process memory>"
Write-Host ""
Write-Host "Next:"
Write-Host "python\.venv\Scripts\python.exe api\db_check.py"
