# ELI5 — What a LAMP Stack Actually Is

```text
L = Linux
A = Apache
M = MySQL/MariaDB
P = PHP
```

## Simple mental model

- **Linux** = the building.
- **Apache** = the receptionist.
- **PHP** = the worker.
- **MariaDB** = the filing cabinet.
- **PDO** = the controlled doorway PHP uses to talk to the database.

## CRUD

```text
Create → INSERT
Read   → SELECT
Update → UPDATE
Delete → DELETE
```

## Request flow

```text
Browser
→ Apache
→ PHP
→ PDO
→ MariaDB
→ PHP builds HTML
→ browser
```

## HTTPS

```text
HTTP
→ not encrypted

HTTPS + self-signed certificate
→ encrypted
→ browser does not trust issuer

HTTPS + trusted certificate
→ encrypted
→ trusted identity
```
