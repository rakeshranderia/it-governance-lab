# Module 3 — Request Flow Architecture

## Final flow

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
   | HTTPS :443
   | TLS
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

The redirect is not Apache internally converting HTTP into HTTPS.

Instead:

```text
1. Browser sends HTTP request.
2. Apache returns 301 + Location.
3. Browser reads the Location header.
4. Browser opens a new HTTPS connection.
5. TLS negotiation occurs.
6. Browser sends the HTTPS request.
```

## Certificate model

```text
Private key  → remains on server
Certificate  → presented to client
CA trust     → establishes public trust in normal production HTTPS
```

The lab uses a self-signed certificate, so encryption works but the browser cannot establish third-party trust.
