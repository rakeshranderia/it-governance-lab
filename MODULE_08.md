# Module 8 — Docker

## Objective

Containerise the FastAPI application and run FastAPI + PostgreSQL together with Docker Compose.

## Target architecture

```text
Host browser / PowerShell
        |
        | localhost:8000
        v
+-----------------------+
| FastAPI container     |
| service: api          |
| port: 8000            |
+-----------+-----------+
            |
            | db:5432
            v
+-----------------------+
| PostgreSQL container  |
| service: db           |
| database: assetlab    |
+-----------+-----------+
            |
            v
      Docker volume
      postgres_data
```

## Key Docker concepts

- **Image** — packaged filesystem + runtime instructions.
- **Container** — a running instance of an image.
- **Dockerfile** — recipe used to build the FastAPI image.
- **Compose** — defines and runs the multi-container application.
- **Volume** — persistent storage independent of a container instance.
- **Service name DNS** — the API connects to PostgreSQL using `db`, not `localhost`.

## Why `PGHOST=db`?

Inside the API container, `localhost` means the API container itself.

Docker Compose provides internal DNS, so the PostgreSQL service is reachable by its service name:

```text
db
```

That makes the database address:

```text
db:5432
```

## Persistence

PostgreSQL data is stored in the named volume:

```text
postgres_data
```

Recreating containers should not delete the database.

Deleting the volume will delete the lab database.

## Secret handling

The password is supplied from a local `.env` file.

`.env` is excluded from the Docker build context and should not be committed.

## Module checkpoints

1. Build the FastAPI image.
2. Start API + PostgreSQL with Compose.
3. Prove the API reaches PostgreSQL over the Docker network.
4. Run the Module 7 external import inside the containerised stack.
5. Recreate containers and prove database persistence.
6. Deliberately break one container/network dependency and troubleshoot it.
