# Module 7 — Integration

## Objective

Build a simple external-data integration pipeline:

```text
External API
→ Python requests
→ transform
→ PostgreSQL
→ FastAPI
```

## Phase A — ingestion

The first checkpoint proves that Python can call an external HTTP API, parse JSON, transform selected fields, store them in PostgreSQL, and safely rerun the import using an upsert.

The lab uses the public DummyJSON laptops endpoint because it requires no account or API key and provides predictable JSON suitable for the asset-register scenario.

External records are stored in `external_assets`. The original JSON is preserved in `source_payload JSONB`.

The unique key is `(source_system, source_record_id)`, so rerunning the import updates records instead of duplicating them.
