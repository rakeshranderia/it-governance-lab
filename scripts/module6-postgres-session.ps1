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

Write-Host "PostgreSQL environment variables set for this PowerShell session."
