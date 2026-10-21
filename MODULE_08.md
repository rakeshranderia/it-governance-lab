# Module 8 — Docker

## Objective
Containerise the FastAPI application and run FastAPI + PostgreSQL together with Docker Compose.

## Outcome
Module 8 demonstrates Docker Desktop/engine, Docker CLI, Dockerfile builds, images, containers, Docker Compose, service-name DNS, container networking, environment variables, local `.env` secret handling, PostgreSQL health checks, named-volume persistence, container recreation, break/fix troubleshooting, and Windows host port publishing.

## Architecture

```text
Windows host
    |
    | localhost:8000
    v
FastAPI container (api)
    |
    | db:5432
    v
PostgreSQL container (db)
    |
    v
postgres_data volume
```

## Key concepts
- **Image** — packaged application/runtime template.
- **Container** — running instance of an image.
- **Dockerfile** — recipe used to build the FastAPI image.
- **Compose** — defines and runs the multi-container stack.
- **Volume** — storage whose lifecycle is separate from an individual container.
- **Service-name DNS** — the API reaches PostgreSQL at `db:5432`, not `localhost:5432`.

## Persistence proof
A `Docker-Persistence-Test` record was created, the containers were removed with `docker compose down`, and recreated with `docker compose up -d`. The record still existed afterwards.

This proves:

```text
container lifecycle != database lifecycle
```

The data survived because PostgreSQL stores state in the named volume `postgres_data`.

`docker compose down -v` would remove that volume and therefore delete the lab database.

## Break/fix proof
PostgreSQL was deliberately stopped:

```powershell
docker compose stop db
```

FastAPI stayed running, but `/health` failed with:

```text
Database unavailable: failed to resolve host 'db'
```

After:

```powershell
docker compose start db
```

the health endpoint recovered to:

```json
{
  "status": "healthy",
  "database": "reachable"
}
```

This demonstrated that a web process can be running while a required dependency is unavailable.

## `.env`, `.env.example` and GitHub Secrets

### `.env.example`
Committed to GitHub. Contains fake placeholders only:

```text
POSTGRES_PASSWORD=change-me
```

Never place a real or commonly reused password in `.env.example`.

### `.env`
Local-only file containing the real lab secret:

```text
POSTGRES_PASSWORD=<unique-lab-password>
```

It must be ignored by Git. Verification:

```powershell
git check-ignore -v .env
```

Use a unique disposable lab password, not a reused temporary password.

### GitHub Secrets
Not required for this local Docker Compose workflow. They become relevant when GitHub Actions or other GitHub-hosted automation needs credentials.

```text
local development -> .env
GitHub Actions / CI -> GitHub Secrets
cloud deployment -> managed secret store such as Azure Key Vault
```

## Windows Firewall
Publishing the API on `0.0.0.0:8000` can trigger a Windows Firewall prompt. This is host-level exposure.

Internal Docker traffic such as:

```text
api -> db:5432
```

uses the Docker network.

## Module 8 complete
The application now runs as a multi-container Docker Compose stack with persistent PostgreSQL storage, internal service networking and dependency-aware health behaviour.

**Commit checkpoint:** `Complete Module 8 Docker`
