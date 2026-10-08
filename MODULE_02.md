# Module 2 — LAMP Stack and IT Asset Register

## Objective

Build a simple end-to-end web application using Linux, Apache, MariaDB and PHP.

The application is deliberately small: an IT Asset Register.

## End state

```text
Browser
  ↓
Azure public IP / NSG
  ↓
Apache
  ↓
PHP
  ↓
PDO
  ↓
MariaDB
  ↓
assetlab.assets
  ↓
HTML response
```

The application supports:

- Create
- Read
- Update
- Delete

## Before starting

```powershell
$VMIP = "<PUBLIC-IP>"
$SSH = "C:\Program Files\Git\usr\bin\ssh.exe"
```

## Install Apache

```powershell
& $SSH `
  -i "$HOME\.ssh\it-governance-lab" `
  "azureuser@$VMIP" `
  "sudo apt update && sudo apt install -y apache2"
```

## Allow HTTP

```powershell
az vm open-port `
  --resource-group rg-it-governance-lab-dev `
  --name vm-itlab-dev-01 `
  --port 80 `
  --priority 1010
```

## Install PHP

```powershell
& $SSH `
  -i "$HOME\.ssh\it-governance-lab" `
  "azureuser@$VMIP" `
  "sudo apt install -y php libapache2-mod-php"
```

## Install MariaDB and PHP database driver

```powershell
& $SSH `
  -i "$HOME\.ssh\it-governance-lab" `
  "azureuser@$VMIP" `
  "sudo apt install -y mariadb-server php-mysql && sudo systemctl enable --now mariadb"
```

## Database

```text
Database: assetlab
Table: assets
```

Use stdin for multiline SQL over SSH rather than deeply nested quoting.

## Application account

The web application uses:

```text
assetapp@localhost
```

with:

```text
SELECT
INSERT
UPDATE
DELETE
```

on `assetlab.*`.

The live password is stored outside the web root:

```text
/etc/assetlab-db.php
```

and is not committed.

## Application source

Version-controlled application:

```text
lamp/assets.php
```

Deployed to:

```text
/var/www/html/assets.php
```

## CRUD result

```text
Create ✓
Read   ✓
Update ✓
Delete ✓
```

## Concepts introduced

- GET
- POST
- PDO
- prepared statements
- `htmlspecialchars()`
- POST → Redirect → GET
- least privilege
- stdin vs nested quoting

**Commit checkpoint:** `Complete Module 2 LAMP asset register`
