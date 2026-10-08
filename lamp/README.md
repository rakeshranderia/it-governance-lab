# LAMP Asset Register

## Files

```text
assets.php
schema.sql
assetlab-db.example.php
apache/
```

## Runtime

```text
lamp/assets.php
→ /var/www/html/assets.php
```

Live DB config:

```text
/etc/assetlab-db.php
```

## Architecture

```text
Browser
→ Apache
→ PHP
→ PDO
→ MariaDB
```
