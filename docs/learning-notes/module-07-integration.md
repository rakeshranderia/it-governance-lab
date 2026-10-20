# Module 7 — Integration Learning Notes

Modules 5 and 6 handled:

```text
HTTP client
→ FastAPI
→ PostgreSQL
```

Module 7 adds an upstream system:

```text
External API
→ Python integration code
→ PostgreSQL
→ FastAPI
```

Keeping the original API record in PostgreSQL `JSONB` lets us compare the raw source with transformed fields and helps with troubleshooting and governance.

`ON CONFLICT ... DO UPDATE` makes the import repeatable without creating duplicates.
