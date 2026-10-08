# Module 3 — Request Flow Architecture

```text
Browser
   |
   | HTTP :80
   v
Apache
   |
   | 301 redirect
   v
Browser creates a new request
   |
   | HTTPS :443 / TLS
   v
Apache
   |
   v
PHP
   |
   v
PDO
   |
   v
MariaDB
```

The redirect causes a new browser request; Apache is not internally converting HTTP into HTTPS.
