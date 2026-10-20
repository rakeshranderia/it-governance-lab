$ErrorActionPreference = "Stop"

$baseUrl = "http://127.0.0.1:8000"

Write-Host "`n=== Module 8 Docker smoke test ==="

Write-Host "`n1. API health"
Invoke-RestMethod "$baseUrl/health" | ConvertTo-Json

Write-Host "`n2. Seed assets"
$assets = Invoke-RestMethod "$baseUrl/assets"
$assets | ConvertTo-Json -Depth 5

if ($assets.Count -lt 3) {
    throw "Expected at least 3 seed assets."
}

Write-Host "`n3. Trigger external import"
Invoke-RestMethod `
    -Uri "$baseUrl/external-assets/import" `
    -Method Post |
    ConvertTo-Json

Write-Host "`n4. External assets"
$external = Invoke-RestMethod "$baseUrl/external-assets"
Write-Host "External asset rows: $($external.Count)"

if ($external.Count -lt 1) {
    throw "Expected imported external assets."
}

Write-Host "`nModule 8 container checkpoint passed."
