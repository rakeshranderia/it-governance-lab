# Module 3 — Learning Notes

## What I changed

Module 3 added deliberate break/fix exercises, HTTPS, a self-signed certificate, an HTTP → HTTPS redirect, and an updated health check.

## Failure signatures

```text
No normal HTTP response → service/listener/network
404 → resource/route
500 → application/dependency
TLS warning → encryption may work; trust is the issue
```

## HTTPS

```text
HTTP :80
→ 301 redirect
→ HTTPS :443
→ TLS
→ Apache
→ PHP
→ MariaDB
```

## What I understand now

1. A 404 and a connection failure are different.
2. HTTP status codes help narrow the fault domain.
3. Service health and application authentication are separate.
4. Validate Apache configuration before restart/reload.
5. HTTPS and certificate trust are related but separate concepts.
