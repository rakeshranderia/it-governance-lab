$ErrorActionPreference = "Stop"

Write-Host "`n=== Module 6 FastAPI/PostgreSQL smoke test ==="

$baseUrl = "http://127.0.0.1:8000"

Write-Host "`n1. Health"
Invoke-RestMethod "$baseUrl/health" | ConvertTo-Json

Write-Host "`n2. Existing assets"
Invoke-RestMethod "$baseUrl/assets" | ConvertTo-Json -Depth 4

Write-Host "`n3. Create persistence test asset"
$body = @{
    name = "Persistence-Test-001"
    type = "Test"
    status = "Active"
    purchase_price = 123.45
} | ConvertTo-Json

$created = Invoke-RestMethod `
    -Uri "$baseUrl/assets" `
    -Method Post `
    -ContentType "application/json" `
    -Body $body

$created | ConvertTo-Json

Write-Host "`nCreated asset ID: $($created.id)"

Write-Host "`n4. Patch asset"
$patchBody = @{
    status = "Repair"
} | ConvertTo-Json

Invoke-RestMethod `
    -Uri "$baseUrl/assets/$($created.id)" `
    -Method Patch `
    -ContentType "application/json" `
    -Body $patchBody |
    ConvertTo-Json

Write-Host "`n5. Read asset"
Invoke-RestMethod "$baseUrl/assets/$($created.id)" |
    ConvertTo-Json

Write-Host "`nSmoke test complete."
Write-Host "Do NOT delete the test row yet."
Write-Host "Restart Uvicorn, then GET /assets/$($created.id)."
Write-Host "If it still exists, persistence is proven."
Write-Host "After that, DELETE it through Swagger or Invoke-RestMethod."
