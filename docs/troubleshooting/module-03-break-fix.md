# Module 3 Break/Fix Troubleshooting Record

## Troubleshooting model

```text
Browser
→ network
→ TCP listener
→ Apache
→ requested resource
→ PHP
→ database authentication
→ MariaDB
```

## Apache stopped

```bash
sudo systemctl stop apache2
```

Symptoms: no normal HTTP response, no port-80 listener.

Restore:

```bash
sudo systemctl start apache2
```

## `assets.php` missing

```bash
sudo mv /var/www/html/assets.php /var/www/html/assets.php.broken
```

Symptom:

```text
404 Not Found
```

Restore:

```bash
sudo mv /var/www/html/assets.php.broken /var/www/html/assets.php
```

Lesson: a 404 proves the web server answered.

## MariaDB stopped

```bash
sudo systemctl stop mariadb
```

Symptom: application returns a database failure / HTTP 500.

Restore:

```bash
sudo systemctl start mariadb
```

## Wrong database credentials

MariaDB remained active while the application password was temporarily made incorrect.

Lesson:

```text
service availability
```

and:

```text
application access
```

are separate checks.

## Restart attempted without sudo

Incorrect:

```bash
systemctl restart apache2
```

Correct:

```bash
sudo systemctl restart apache2
```

The resulting authentication failure was a privilege problem, not an Apache problem.

## HTTPS validation

```bash
sudo apache2ctl -M | grep ssl
sudo ss -ltnp | grep :443
curl -k -I https://localhost/assets.php
```

`-k` is used only because this lab intentionally uses a self-signed certificate.

## Redirect validation

```bash
curl -I http://localhost/assets.php
```

Expected:

```text
301 Moved Permanently
```

## Shortcut

```text
No HTTP response → service/listener/network
404              → resource/route
500              → application/dependency
TLS warning      → inspect trust/identity
```
