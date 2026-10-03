# Known Gaps and Intentional Simplifications

The IT Asset Register is a learning application, not a production asset-management platform.

These gaps are intentional and should be visible rather than hidden.

## Current gaps

### HTTP only

The application currently uses HTTP.

HTTPS/TLS is intentionally deferred to Module 3.

### No authentication

Anyone who can reach the application can use it.

Authentication and authorisation are outside Module 2's scope.

### No CSRF protection

Create, update and delete actions do not yet use CSRF tokens.

This is acceptable for the isolated learning exercise but not for a production web application.

### Minimal server-side validation

The application checks that required fields are present, but validation is intentionally basic.

A production application should validate allowed values, lengths, formats and business rules server-side.

### No audit trail

The application does not record:

- who changed a record;
- what changed;
- when it changed.

### Local configuration file for secrets

The live database password is stored outside the web root in:

```text
/etc/assetlab-db.php
```

This is better than committing it or putting it in `/var/www/html`, but production systems should normally use a dedicated secrets-management approach.

### No automated tests

CRUD was tested manually in Module 2.

Automated application tests are introduced later in the broader learning path.

### No backup/recovery workflow

The database currently has no documented backup or restore process.

### No application monitoring

Module 2 uses manual health checks only.

Monitoring, health endpoints and operational runbooks are covered later.

## Why document gaps?

A useful technical portfolio should distinguish between:

```text
deliberate simplification
```

and:

```text
unknown risk
```

The goal is not to pretend the lab is production-ready.

The goal is to demonstrate that the missing controls are understood and intentionally sequenced into later learning.
