# Module 2 — Learning Notes

## What I built

A small IT Asset Register using:

- Ubuntu Linux
- Apache
- PHP
- MariaDB
- PDO

The application supports:

```text
Create
Read
Update
Delete
```

## What the stack looks like

```text
Browser
  ↓
Azure networking
  ↓
Apache
  ↓
PHP
  ↓
PDO
  ↓
MariaDB
  ↓
assets table
```

## What I proved

### Apache

`curl -I http://localhost` returned:

```text
HTTP/1.1 200 OK
```

The default Apache page also loaded from an external browser after port 80 was allowed through Azure.

### PHP

A simple test page returned:

```text
PHP is working
```

This proved Apache was executing PHP instead of only serving static files.

### MariaDB

Created:

```text
Database: assetlab
Table: assets
```

Columns:

```text
id
asset_name
asset_type
status
```

### End-to-end data

Sample data was stored in MariaDB and displayed through PHP in the browser.

### CRUD

The web application successfully:

- created an asset;
- displayed assets;
- updated an asset status;
- deleted a temporary asset.

## Security choices

### Application database user

The PHP application does not use database root.

It uses:

```text
assetapp@localhost
```

with only:

```text
SELECT
INSERT
UPDATE
DELETE
```

on:

```text
assetlab.*
```

### Database password

The real password is stored outside the web root:

```text
/etc/assetlab-db.php
```

The real credential is not committed to Git.

### Prepared statements

Writes use PDO prepared statements rather than directly concatenating browser input into SQL.

### Output encoding

Database values are displayed using:

```php
htmlspecialchars()
```

## Command-line lessons

### Repeated public IP values

Repeatedly pasting a public IP into multiline PowerShell commands caused accidental stray backticks.

A better pattern is:

```powershell
$VMIP = "<PUBLIC-IP>"
$SSH = "C:\Program Files\Git\usr\bin\ssh.exe"
```

Then:

```powershell
& $SSH `
  -i "$HOME\.ssh\it-governance-lab" `
  "azureuser@$VMIP" `
  "remote-command"
```

### Nested quoting

Several commands passed through multiple parsers:

```text
PowerShell
→ SSH
→ Bash
→ SQL or PHP
```

A quote can disappear or change meaning at any layer.

### Multi-line SQL over SSH

Trying to put a full SQL statement inside an SSH command caused Bash syntax errors.

The cleaner pattern was:

```powershell
$sql = @"
SELECT * FROM assets;
"@

$sql | & $SSH `
  -i "$HOME\.ssh\it-governance-lab" `
  "azureuser@$VMIP" `
  "sudo mariadb assetlab"
```

This sends SQL through standard input instead of embedding it inside shell quoting.

## ELI5 mental model

### Apache

The receptionist.

It accepts the web request and decides what should handle it.

### PHP

The worker behind the desk.

It reads the request, performs application logic and builds a response.

### MariaDB

The filing cabinet.

It stores data so it survives after a request finishes.

### PDO

The controlled connection between PHP and the database.

### Browser form

The way a user sends data back to PHP.

## Request flow — reading assets

```text
Browser asks for /assets.php
        ↓
Apache receives request
        ↓
Apache runs PHP
        ↓
PHP connects through PDO
        ↓
MariaDB runs SELECT
        ↓
Rows return to PHP
        ↓
PHP builds HTML
        ↓
Apache returns page
        ↓
Browser displays assets
```

## Request flow — adding an asset

```text
User submits form
        ↓
Browser sends POST
        ↓
PHP reads form values
        ↓
PDO prepared INSERT
        ↓
MariaDB stores row
        ↓
PHP redirects
        ↓
Browser sends new GET
        ↓
Updated table appears
```

## What I understand now

1. Apache and PHP are different layers.
2. Opening port 80 is separate from Apache actually working.
3. PHP needs a database driver to communicate with MariaDB.
4. The web app should not use the database root account.
5. Structured content over SSH is often easier through stdin than nested quoting.
6. CRUD maps directly to common SQL operations.
7. A browser form is simply another way of creating an HTTP request.
8. A successful page load does not prove every layer is healthy; each layer can be tested separately.

## Status

Module 2 complete.

Next:

```text
Module 3 — Web request flow, deliberate break/fix and HTTPS
```

## Commit checkpoint

```text
Complete Module 2 LAMP asset register
```
