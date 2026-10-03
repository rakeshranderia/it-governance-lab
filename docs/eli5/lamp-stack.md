# ELI5 — What a LAMP Stack Actually Is

## What is it?

LAMP is a common way to build a web application from four pieces:

```text
L = Linux
A = Apache
M = MySQL/MariaDB
P = PHP
```

In this lab:

```text
Linux   = Ubuntu
Apache  = web server
MariaDB = database
PHP     = application code
```

## The simplest mental model

Imagine a small office.

### Apache = receptionist

The browser arrives with a request.

Apache receives it.

For a static file, Apache can simply hand the file back.

For a PHP file, Apache asks PHP to process it.

### PHP = worker

PHP contains the application logic.

It can:

- read form input;
- make decisions;
- talk to a database;
- build HTML.

### MariaDB = filing cabinet

MariaDB stores information permanently.

In this lab it stores assets.

### Linux = building

Linux is the operating system all the other components run on.

---

## What did we build?

A tiny IT Asset Register.

The database contains:

```text
id
asset_name
asset_type
status
```

The browser can:

- add assets;
- view assets;
- change status;
- delete assets.

---

## What happens when I view the page?

```text
Browser
  ↓
GET /assets.php
  ↓
Apache
  ↓
PHP
  ↓
PDO
  ↓
SELECT from MariaDB
  ↓
rows returned
  ↓
PHP creates HTML
  ↓
Apache returns HTML
  ↓
Browser displays table
```

---

## What happens when I add an asset?

```text
Form
  ↓
POST /assets.php
  ↓
PHP reads fields
  ↓
prepared INSERT
  ↓
MariaDB stores row
  ↓
PHP redirects
  ↓
browser performs GET
  ↓
updated list appears
```

---

## What is PDO?

PDO stands for:

```text
PHP Data Objects
```

ELI5:

> PDO is the controlled doorway PHP uses to talk to the database.

It also supports prepared statements.

---

## What is a prepared statement?

Bad pattern:

```text
"INSERT ... " + whatever-the-user-typed
```

Better pattern:

```text
SQL structure
+
separate values
```

The database can treat the values as values instead of accidentally treating them as part of SQL syntax.

---

## Why not use the MariaDB root account?

The application does not need to:

- create databases;
- create users;
- change server configuration;
- administer every database.

It only needs:

```text
SELECT
INSERT
UPDATE
DELETE
```

So it gets only those permissions.

This is called:

```text
least privilege
```

---

## Why is the password outside `/var/www/html`?

`/var/www/html` is the web content directory.

Application secrets should not be stored where the web server might accidentally expose them as content.

The lab stores the live configuration in:

```text
/etc/assetlab-db.php
```

and keeps only an example template in Git.

---

## CRUD

CRUD is simply:

```text
Create → INSERT
Read   → SELECT
Update → UPDATE
Delete → DELETE
```

The Asset Register now demonstrates all four.

---

## Why does the page say `Not secure`?

The lab currently uses:

```text
HTTP
```

rather than:

```text
HTTPS
```

The application works, but browser traffic is not yet protected by TLS.

HTTPS is deliberately deferred to Module 3 so each layer is introduced separately.

---

## What broke?

Several commands failed because text travelled through:

```text
PowerShell
→ SSH
→ Bash
→ PHP / SQL
```

The application code was not always the problem.

Sometimes a quote disappeared before the target program ever saw it.

That is why the lab also documents:

- which program generated the error;
- stdin vs command-line arguments;
- shell quoting;
- environment ambiguity.

---

## Five things I now understand

1. Apache, PHP and MariaDB have separate jobs.
2. A web application is a chain of components, not one program.
3. CRUD maps directly to SQL operations.
4. The application should not run with database administrator privileges.
5. A failure message is easier to troubleshoot when I first identify which layer produced it.
