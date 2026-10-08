# Module 3 Break/Fix Troubleshooting Record

## Apache stopped

Expected: no normal HTTP response.

## Application file missing

Expected:

```text
404 Not Found
```

## MariaDB stopped

Expected:

```text
500 Internal Server Error
```

## Wrong DB credentials

MariaDB remained active but the app could not authenticate.

## Restart without sudo

Incorrect:

```bash
systemctl restart apache2
```

Correct:

```bash
sudo systemctl restart apache2
```

## Shortcut

```text
No HTTP response → service/listener/network
404              → resource/route
500              → application/dependency
TLS warning      → inspect trust/identity
```
