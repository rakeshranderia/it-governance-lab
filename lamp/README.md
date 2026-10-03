# LAMP Asset Register

This directory contains the version-controlled application and database examples created during Module 2.

## Files

```text
assets.php
schema.sql
assetlab-db.example.php
```

## Runtime locations

The lab deploys:

```text
lamp/assets.php
    ↓
/var/www/html/assets.php
```

The live database configuration is stored outside the web root:

```text
/etc/assetlab-db.php
```

The real database password is never committed.

## Architecture

```text
Browser
→ Apache
→ PHP
→ PDO
→ MariaDB
→ assetlab.assets
```

## Database

The application uses:

```text
Database: assetlab
Table: assets
```

## Application permissions

Recommended MariaDB application account:

```text
assetapp@localhost
```

Permissions:

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

## Learning purpose

This is intentionally not a production-grade asset management system.

It exists to demonstrate:

- LAMP request flow;
- PHP database access;
- CRUD;
- prepared statements;
- least privilege;
- basic secret separation;
- application troubleshooting.
