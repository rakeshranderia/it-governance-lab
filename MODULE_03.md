# Module 3 — Web Request Flow, Break/Fix and HTTPS

## Objective

Take the working LAMP Asset Register from Module 2 and learn how to identify which layer is failing, deliberately break and restore the stack, enable HTTPS, understand a self-signed certificate warning, redirect HTTP to HTTPS, and update the health check for the new architecture.

## Break/Fix 1 — Apache stopped

```bash
sudo systemctl stop apache2
```

Expected: no normal HTTP response.

Restore:

```bash
sudo systemctl start apache2
```

## Break/Fix 2 — Application file missing

```bash
sudo mv /var/www/html/assets.php /var/www/html/assets.php.broken
```

Expected:

```text
404 Not Found
```

Restore:

```bash
sudo mv /var/www/html/assets.php.broken /var/www/html/assets.php
```

## Break/Fix 3 — MariaDB stopped

```bash
sudo systemctl stop mariadb
```

Expected application response:

```text
Database operation failed.
```

Expected HTTP status:

```text
500 Internal Server Error
```

Restore:

```bash
sudo systemctl start mariadb
```

## Break/Fix 4 — Wrong database credentials

MariaDB remained healthy while the application credentials were made incorrect.

Lesson:

```text
service healthy
≠
application can authenticate
```

## HTTPS

The lab uses a self-signed certificate:

```text
/etc/ssl/certs/assetlab.crt
/etc/ssl/private/assetlab.key
```

Enable SSL:

```bash
sudo a2enmod ssl
sudo apache2ctl configtest
sudo systemctl restart apache2
```

Confirm:

```bash
sudo apache2ctl -M | grep ssl
sudo ss -ltnp | grep :443
```

## Redirect HTTP to HTTPS

```bash
sudo a2dissite 000-default.conf
sudo a2ensite assetlab-http.conf
sudo apache2ctl configtest
sudo systemctl reload apache2
```

Expected:

```text
HTTP :80   → 301 redirect
HTTPS :443 → 200
```

## Final architecture

```text
Browser
  ↓
HTTP :80
  ↓
301 redirect
  ↓
HTTPS :443
  ↓
TLS
  ↓
Apache
  ↓
PHP
  ↓
PDO
  ↓
MariaDB
```

**Commit checkpoint:** `Complete Module 3 break-fix and HTTPS`
