# Module 2 — LAMP Stack and IT Asset Register

## Objective

Build a simple end-to-end web application using:

- Linux
- Apache
- MariaDB
- PHP

The application is deliberately small: an IT Asset Register.

The learning goal is not front-end design. The goal is to understand the request path, database interaction, application permissions and the relationship between each layer.

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

Use PowerShell variables for repeated values:

```powershell
$VMIP = "<PUBLIC-IP>"
$SSH = "C:\Program Files\Git\usr\bin\ssh.exe"
```

This avoids repeatedly pasting public IP addresses and reduces errors with trailing PowerShell backticks.

See:

`docs/appendices/appendix-03-working-in-a-messy-lab.md`

---

## Step 1 — Install Apache

```powershell
& $SSH `
  -i "$HOME\.ssh\it-governance-lab" `
  "azureuser@$VMIP" `
  "sudo apt update && sudo apt install -y apache2"
```

Confirm Apache:

```powershell
& $SSH `
  -i "$HOME\.ssh\it-governance-lab" `
  "azureuser@$VMIP" `
  "systemctl status apache2 --no-pager; echo '---'; ss -tulpn | grep ':80'"
```

Test locally from the VM:

```powershell
& $SSH `
  -i "$HOME\.ssh\it-governance-lab" `
  "azureuser@$VMIP" `
  "curl -I http://localhost"
```

Expected:

```text
HTTP/1.1 200 OK
Server: Apache/2.4...
```

## Step 2 — Allow HTTP through Azure

```powershell
az vm open-port `
  --resource-group rg-it-governance-lab-dev `
  --name vm-itlab-dev-01 `
  --port 80 `
  --priority 1010
```

Browse to:

```text
http://<PUBLIC-IP>
```

Expected: Apache2 Ubuntu Default Page.

> `Not secure` is expected because this module uses HTTP. HTTPS is added in Module 3.

---

## Step 3 — Install PHP

```powershell
& $SSH `
  -i "$HOME\.ssh\it-governance-lab" `
  "azureuser@$VMIP" `
  "sudo apt install -y php libapache2-mod-php"
```

Confirm:

```powershell
& $SSH `
  -i "$HOME\.ssh\it-governance-lab" `
  "azureuser@$VMIP" `
  "php -v"
```

Create a simple PHP test:

```powershell
& $SSH `
  -i "$HOME\.ssh\it-governance-lab" `
  "azureuser@$VMIP" `
  "echo '<?php echo '\''PHP is working'\''; ?>' | sudo tee /var/www/html/test.php"
```

Browse to:

```text
http://<PUBLIC-IP>/test.php
```

Expected:

```text
PHP is working
```

### What changed?

Before PHP:

```text
Browser → Apache → static file
```

After PHP:

```text
Browser → Apache → PHP interpreter → generated response
```

---

## Step 4 — Install MariaDB and the PHP database driver

```powershell
& $SSH `
  -i "$HOME\.ssh\it-governance-lab" `
  "azureuser@$VMIP" `
  "sudo apt install -y mariadb-server php-mysql && sudo systemctl enable --now mariadb"
```

Confirm:

```powershell
& $SSH `
  -i "$HOME\.ssh\it-governance-lab" `
  "azureuser@$VMIP" `
  "mariadb --version; echo '---'; systemctl is-active mariadb"
```

---

## Step 5 — Create the application database

For multi-line SQL over SSH, send SQL through standard input rather than nesting several layers of quotes.

```powershell
$sql = @"
CREATE DATABASE assetlab;

USE assetlab;

CREATE TABLE assets (
    id INT AUTO_INCREMENT PRIMARY KEY,
    asset_name VARCHAR(100) NOT NULL,
    asset_type VARCHAR(50),
    status VARCHAR(30)
);
"@

$sql | & $SSH `
  -i "$HOME\.ssh\it-governance-lab" `
  "azureuser@$VMIP" `
  "sudo mariadb"
```

Verify:

```powershell
"SHOW DATABASES; USE assetlab; SHOW TABLES; DESCRIBE assets;" |
  & $SSH `
    -i "$HOME\.ssh\it-governance-lab" `
    "azureuser@$VMIP" `
    "sudo mariadb"
```

---

## Step 6 — Insert sample data

```powershell
$sql = @"
INSERT INTO assets (asset_name, asset_type, status)
VALUES
('Laptop-001','Laptop','Active'),
('Monitor-001','Monitor','Active'),
('Phone-001','Mobile','In Stock');
"@

$sql | & $SSH `
  -i "$HOME\.ssh\it-governance-lab" `
  "azureuser@$VMIP" `
  "sudo mariadb assetlab"
```

Verify:

```powershell
"SELECT * FROM assets;" |
  & $SSH `
    -i "$HOME\.ssh\it-governance-lab" `
    "azureuser@$VMIP" `
    "sudo mariadb assetlab"
```

---

## Step 7 — Create a least-privilege application account

Do not let the web application use the database root account.

Create a local password:

```powershell
$DBPASS = -join (
    (48..57) + (65..90) + (97..122) |
    Get-Random -Count 24 |
    ForEach-Object {[char]$_}
)
```

Create the MariaDB user:

```powershell
$sql = @"
CREATE USER IF NOT EXISTS 'assetapp'@'localhost' IDENTIFIED BY '$DBPASS';
ALTER USER 'assetapp'@'localhost' IDENTIFIED BY '$DBPASS';
GRANT SELECT, INSERT, UPDATE, DELETE ON assetlab.* TO 'assetapp'@'localhost';
FLUSH PRIVILEGES;
"@

$sql | & $SSH `
  -i "$HOME\.ssh\it-governance-lab" `
  "azureuser@$VMIP" `
  "sudo mariadb"
```

Verify:

```powershell
"SHOW GRANTS FOR 'assetapp'@'localhost';" |
  & $SSH `
    -i "$HOME\.ssh\it-governance-lab" `
    "azureuser@$VMIP" `
    "sudo mariadb"
```

The application account should have access to `assetlab.*`, not global administrative rights.

---

## Step 8 — Store database configuration outside the web root

Create:

```text
/etc/assetlab-db.php
```

The real password must not be committed to Git.

Example local deployment:

```powershell
$config = @"
<?php
return [
    'dsn' => 'mysql:host=localhost;dbname=assetlab;charset=utf8mb4',
    'user' => 'assetapp',
    'password' => '$DBPASS'
];
"@

$config | & $SSH `
  -i "$HOME\.ssh\it-governance-lab" `
  "azureuser@$VMIP" `
  "sudo tee /etc/assetlab-db.php > /dev/null && sudo chown root:www-data /etc/assetlab-db.php && sudo chmod 640 /etc/assetlab-db.php"
```

The repository contains:

```text
lamp/assetlab-db.example.php
```

Use it as a template only.

---

## Step 9 — Deploy the application

The version-controlled application is:

```text
lamp/assets.php
```

Deploy it to:

```text
/var/www/html/assets.php
```

For this module, the file can be sent over SSH stdin:

```powershell
Get-Content .\lamp\assets.php -Raw |
  & $SSH `
    -i "$HOME\.ssh\it-governance-lab" `
    "azureuser@$VMIP" `
    "sudo tee /var/www/html/assets.php > /dev/null"
```

Browse to:

```text
http://<PUBLIC-IP>/assets.php
```

---

## Step 10 — Test CRUD

### Create

Add a temporary asset through the web form.

### Read

Confirm all rows appear in the table.

### Update

Change the status of an existing asset.

### Delete

Delete the temporary asset.

Successful result:

```text
Create ✓
Read   ✓
Update ✓
Delete ✓
```

---

## Concepts introduced

### GET

Usually retrieves a page or data.

### POST

Sends data to the application.

### PDO

PHP Data Objects: PHP's database interface used in this lab.

### Prepared statement

SQL structure and user-supplied values are handled separately.

This is safer than building SQL by directly concatenating form input.

### `htmlspecialchars()`

Encodes special HTML characters before displaying database values in a page.

### POST → Redirect → GET

After a successful write:

```text
POST
  ↓
database change
  ↓
redirect
  ↓
GET
```

This avoids accidental duplicate form submissions when the browser refreshes.

### Least privilege

The PHP application gets only the database permissions it needs:

```text
SELECT
INSERT
UPDATE
DELETE
```

It does not run as MariaDB root.

---

## Troubleshooting lessons

Module 2 exposed several command-layer problems:

```text
PowerShell
  ↓
SSH
  ↓
Bash
  ↓
PHP / SQL
```

A command can fail before it reaches the final application.

Two important examples:

1. PHP text failed because PowerShell parsed nested quotes.
2. SQL failed because quoting disappeared before Bash/MariaDB received it.

The preferred reusable pattern for larger structured content is:

```text
PowerShell here-string
  ↓
stdin
  ↓
SSH
  ↓
remote command reads stdin
```

See:

`docs/troubleshooting/powershell-ssh-quoting.md`

---

## Module 2 complete

The lab now has a working CRUD LAMP application.

**Commit checkpoint:** `Complete Module 2 LAMP asset register`
