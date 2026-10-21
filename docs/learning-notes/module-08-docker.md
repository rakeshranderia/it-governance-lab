# Module 8 — Docker Learning Notes

Before Docker:

```text
Windows
├─ Python / Uvicorn
└─ PostgreSQL Windows service
```

With Docker Compose:

```text
Docker
├─ api container
└─ db container
```

The application code stayed broadly the same. The runtime packaging and networking changed.

## Main lessons
- `localhost` is relative to the current host/container.
- From Windows, `127.0.0.1:8000` reaches the API container.
- From the API container, `db:5432` reaches PostgreSQL.
- Containers are disposable.
- Persistent database state belongs in a Docker volume.
- An API process can be up while a database dependency is unavailable.
- `.env.example` is public documentation; `.env` contains the real local values; GitHub Secrets are for CI/CD automation.
