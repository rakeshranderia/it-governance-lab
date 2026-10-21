# ELI5 — Docker

A useful analogy:

```text
VM = a whole house with its own operating system
container = a purpose-built appliance using the host's underlying infrastructure
```

## Image vs container

```text
image = packaged blueprint
container = running copy of that image
```

## Dockerfile
The recipe used to build the application image.

## Compose
Defines how several containers run together.

In this lab:

```text
FastAPI container
+
PostgreSQL container
+
persistent volume
```

## Why `db` instead of `localhost`?
Inside the FastAPI container, `localhost` means the FastAPI container itself.

Docker Compose provides DNS, so PostgreSQL is reached at:

```text
db:5432
```

## Why a volume?
Containers are disposable. The database volume survives container replacement.
