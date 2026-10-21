# Docker — Module 8 Troubleshooting

## CLI installed but Docker engine unavailable
Symptom:

```text
failed to connect to the docker API
dockerDesktopLinuxEngine
```

Meaning: Docker CLI is installed, but the Docker engine is not running.

Fix: start Docker Desktop and rerun:

```powershell
docker version
```

A healthy installation shows both `Client:` and `Server:`.

## Database service stopped
Test:

```powershell
docker compose stop db
```

Result: FastAPI remains up, but `/health` fails because `db` is unavailable.

Recovery:

```powershell
docker compose start db
docker compose ps
```

Wait for PostgreSQL to recover, then retest `/health`.

## Persistence
Safe:

```powershell
docker compose down
```

Destructive to the lab database:

```powershell
docker compose down -v
```

## `.env`
Verify it is ignored:

```powershell
git check-ignore -v .env
```

Do not commit real credentials.
