# Module 3 — Learning Notes

## What I changed

Module 3 added deliberate break/fix exercises, HTTPS, a self-signed certificate, an HTTP → HTTPS redirect, and an updated health check.

## Failure signatures learned

### Apache stopped

No normal HTTP response. Apache and the port-80 listener were unavailable.

### Application file missing

```text
404 Not Found
```

Apache was healthy, but `assets.php` was missing.

### MariaDB stopped

```text
500 Internal Server Error
```

The request reached PHP, but the database dependency was unavailable.

### Wrong database password

MariaDB remained healthy, but the application could not authenticate.

Lesson:

```text
service healthy
≠
application can authenticate
```

## HTTPS

Apache SSL was enabled with:

```bash
sudo a2enmod ssl
```

Configuration was checked before restart:

```bash
sudo apache2ctl configtest
```

The listener was confirmed with:

```bash
sudo ss -ltnp | grep :443
```

## Self-signed certificate

The browser warning was expected.

TLS encryption worked, but the certificate was not signed by a certificate authority trusted by the browser.

## HTTP redirect

The final request path is:

```text
HTTP :80
→ 301 redirect
→ new HTTPS request
→ TLS
→ Apache
→ PHP
→ MariaDB
```

## Health-check change

Module 2 expected:

```text
HTTP = 200
```

Module 3 expects:

```text
HTTP  = redirect
HTTPS = 200
```

## What I understand now

1. A 404 and a connection failure are fundamentally different.
2. HTTP status codes help narrow the fault domain.
3. A healthy database service does not prove application authentication works.
4. Apache configuration should be validated before reload/restart.
5. HTTPS and certificate trust are related but separate concepts.
6. An HTTP redirect causes the browser to make a new request.
7. Health checks must evolve when the intended architecture changes.
8. Privilege errors should not be mistaken for application errors.

**Commit checkpoint:** `Complete Module 3 break-fix and HTTPS`
