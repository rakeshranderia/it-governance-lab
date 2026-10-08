# LAMP Health Checks

The health check verifies:

1. Apache is active.
2. MariaDB is active.
3. TCP/80 is listening.
4. TCP/443 is listening.
5. PHP PDO MySQL is loaded.
6. HTTP redirects.
7. HTTPS returns 200.
8. Database query succeeds.

Run:

```bash
sudo bash scripts/lamp-health-check.sh
```

The lab uses a self-signed certificate, so the HTTPS check deliberately uses `curl -k`.
