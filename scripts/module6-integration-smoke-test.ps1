$ErrorActionPreference = "Stop"

$baseUrl = "http://127.0.0.1:8000"

Write-Host "=== Module 6 FastAPI/PostgreSQL smoke test ==="

Invoke-RestMethod "$baseUrl/health" | ConvertTo-Json

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

$patchBody = @{
    status = "Repair"
} | ConvertTo-Json

Invoke-RestMethod `
    -Uri "$baseUrl/assets/$($created.id)" `
    -Method Patch `
    -ContentType "application/json" `
    -Body $patchBody |
    ConvertTo-Json

Invoke-RestMethod "$baseUrl/assets/$($created.id)" |
    ConvertTo-Json

Write-Host "Restart Uvicorn and GET /assets/$($created.id)."
Write-Host "If the asset still exists, persistence is proven."
