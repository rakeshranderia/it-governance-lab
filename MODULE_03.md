# Module 3 — Web Request Flow, Break/Fix and HTTPS

## Objective

Take the working LAMP Asset Register from Module 2 and learn how to identify which layer is failing, deliberately break and restore the stack, enable HTTPS, understand a self-signed certificate warning, redirect HTTP to HTTPS, and update the health check for the new architecture.

## Starting point

```text
Browser
  ↓
HTTP :80
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
```

## Break/Fix 1 — Apache stopped

```bash
sudo systemctl stop apache2
```

Expected: no normal HTTP response.

Diagnose:

```bash
systemctl status apache2 --no-pager
ss -ltn | grep ':80' || echo 'Nothing listening on port 80'
curl -I --max-time 5 http://localhost || echo 'Local HTTP request failed'
```

Restore:

```bash
sudo systemctl start apache2
```

Lesson: if Apache is stopped, it cannot normally generate an HTTP error page.

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

Lesson: a 404 means an HTTP server answered but could not find the requested resource.

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

Lesson: the web application can be reachable while a dependency is unavailable.

## Break/Fix 4 — Wrong database credentials

Back up:

```bash
sudo cp /etc/assetlab-db.php /etc/assetlab-db.php.bak
```

Temporarily use an incorrect application password, then restore:

```bash
sudo mv /etc/assetlab-db.php.bak /etc/assetlab-db.php
```

Lesson:

```text
MariaDB stopped
→ service problem

MariaDB running + wrong password
→ authentication/configuration problem
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

Expected:

```text
ssl_module (shared)
```

and Apache listening on TCP/443.

## Privilege lesson

This failed because the command was not elevated:

```bash
systemctl restart apache2
```

Correct:

```bash
sudo systemctl restart apache2
```

That was a privilege/elevation issue, not an Apache issue.

## Self-signed warning

Browsing to:

```text
https://<PUBLIC-IP>/assets.php
```

produces a browser certificate warning.

That is expected.

```text
HTTP
→ not encrypted

HTTPS + self-signed certificate
→ encrypted
→ browser does not trust issuer

HTTPS + trusted certificate
→ encrypted
→ browser trusts certificate chain
```

## Redirect HTTP to HTTPS

The port-80 site redirects to HTTPS.

```bash
sudo a2dissite 000-default.conf
sudo a2ensite assetlab-http.conf
sudo apache2ctl configtest
sudo systemctl reload apache2
```

Test:

```bash
curl -I http://localhost/assets.php
```

Expected:

```text
HTTP/1.1 301 Moved Permanently
Location: https://<PUBLIC-IP>/assets.php
```

Test HTTPS:

```bash
curl -k -I https://localhost/assets.php
```

Expected:

```text
HTTP/1.1 200 OK
```

## Final architecture

```text
Browser
  ↓
HTTP :80
  ↓
Apache
  ↓
301 redirect
  ↓
Browser creates new request
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

## Failure signatures

| Symptom | Likely layer |
|---|---|
| No usable HTTP response | Apache/listener/network |
| 404 Not Found | Web server answered but resource/route missing |
| 500 Internal Server Error | Application/dependency problem |
| MariaDB healthy but app fails | Credentials/configuration/application |
| Browser certificate warning | TLS works but issuer is not trusted |
| HTTP 301 | Redirect working as designed |

## Updated health check

The desired state is now:

```text
HTTP  → redirect
HTTPS → 200
DB    → query succeeds
```

**Commit checkpoint:** `Complete Module 3 break-fix and HTTPS`
