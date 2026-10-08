# Known Gaps and Intentional Simplifications

The IT Asset Register is a learning application, not a production asset-management platform.

## HTTPS uses a self-signed certificate

TLS encryption is enabled, but the certificate is not signed by a public certificate authority.

A production-style implementation would normally use:

- a DNS name;
- a trusted certificate authority;
- automated certificate renewal.

## No authentication

Anyone who can reach the application can use it.

## No CSRF protection

Create, update and delete actions do not yet use CSRF tokens.

## Minimal server-side validation

Validation remains intentionally basic.

## No audit trail

The application does not record who changed a record, what changed, or when.

## Local configuration file for secrets

The live database password is stored outside the web root in:

```text
/etc/assetlab-db.php
```

Production systems should normally use a dedicated secrets-management approach.

## No automated application tests

CRUD has been tested manually.

## No backup/recovery workflow

The database currently has no documented backup or restore process.

## Limited monitoring

The lab currently uses a shell health check.

The point is to distinguish deliberate simplification from unknown risk.
