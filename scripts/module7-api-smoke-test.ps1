$ErrorActionPreference = "Stop"

$baseUrl = "http://127.0.0.1:8000"

Write-Host "`n=== Module 7 API smoke test ==="

Write-Host "`n1. Read imported records"
$before = Invoke-RestMethod "$baseUrl/external-assets"
Write-Host "Rows before import: $($before.Count)"

if ($before.Count -lt 1) {
    throw "No external assets were returned."
}

Write-Host "`n2. Read one imported record"
Invoke-RestMethod "$baseUrl/external-assets/$($before[0].id)" |
    ConvertTo-Json -Depth 8

Write-Host "`n3. Trigger import through FastAPI"
$result = Invoke-RestMethod `
    -Uri "$baseUrl/external-assets/import" `
    -Method Post

$result | ConvertTo-Json

Write-Host "`n4. Read records again"
$after = Invoke-RestMethod "$baseUrl/external-assets"
Write-Host "Rows after import: $($after.Count)"

if ($after.Count -ne $before.Count) {
    throw "Row count changed after repeat import. Investigate duplicate handling."
}

Write-Host "`nModule 7 API checkpoint passed."
Write-Host "Repeat import was idempotent for the current source keys."
