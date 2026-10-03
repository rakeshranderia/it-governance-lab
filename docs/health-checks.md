# LAMP Health Checks

## Why health checks exist

A page loading once does not prove the whole system is still healthy.

The Asset Register has several layers:

```text
Apache
  ↓
PHP
  ↓
PDO MySQL driver
  ↓
MariaDB
  ↓
assetlab.assets
```

A simple health check asks each layer a small question.

## Included script

```text
scripts/lamp-health-check.sh
```

It checks:

1. Apache is active.
2. MariaDB is active.
3. TCP port 80 is listening.
4. PHP has the PDO MySQL driver.
5. `/assets.php` returns HTTP 200 locally.
6. MariaDB can query the `assets` table.
7. Port 443 is reported as informational until HTTPS is added in Module 3.

## Run it from PowerShell without copying the script onto the VM

Assuming:

```powershell
$VMIP = "<PUBLIC-IP>"
$SSH = "C:\Program Files\Git\usr\bin\ssh.exe"
```

run:

```powershell
Get-Content .\scripts\lamp-health-check.sh -Raw |
  & $SSH `
    -i "$HOME\.ssh\it-governance-lab" `
    "azureuser@$VMIP" `
    "sudo bash -s"
```

This reuses the same stdin pattern learned during Module 2.

## Example output

```text
[PASS] Apache service is active
[PASS] MariaDB service is active
[PASS] TCP port 80 is listening
[PASS] PHP PDO MySQL driver is loaded
[PASS] Asset application returns HTTP 200 locally
[PASS] Database query succeeded (3 asset rows)
[INFO] TCP port 443 is not listening yet (expected before Module 3 HTTPS)

Summary: 6 passed, 0 failed
```

## ELI5 interpretation

### Apache active

The receptionist is at the desk.

### Port 80 listening

The front door is open.

### PHP PDO MySQL driver loaded

PHP has the correct translator for talking to MariaDB.

### HTTP 200

The application can answer a normal request.

### Database query works

The filing cabinet is reachable and the expected drawer/table exists.

## What a failure means

A failed health check does not automatically tell you the root cause.

It tells you where to start looking.

For example:

```text
Apache active            PASS
Port 80 listening        PASS
/assets.php HTTP status  FAIL
```

means the network listener is probably fine, so investigate PHP/application/database layers next.

That is the same layered troubleshooting approach used throughout the lab.
