# Module 8 — Docker Learning Notes

## What changes from Module 7?

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

The application code is still the same.

What changes is how the runtime dependencies are packaged, connected and started.

## Important networking lesson

`localhost` is relative to the machine or container where the process is running.

From the Windows host:

```text
127.0.0.1:8000 → FastAPI container
```

From the FastAPI container:

```text
db:5432 → PostgreSQL container
```

## Important storage lesson

Containers are disposable.

Persistent database state belongs in a Docker volume, not only in the container filesystem.
