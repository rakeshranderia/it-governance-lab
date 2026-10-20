# ELI5 — FastAPI and HTTP

FastAPI acts like a receptionist for HTTP requests.

```text
client asks for a URL
→ FastAPI finds the matching route
→ Python function runs
→ response is returned
```

HTTP methods:

```text
GET    → give me something
POST   → create something
PATCH  → change part of something
DELETE → remove something
```

Useful status codes:

```text
200 → worked
201 → created
204 → worked, nothing to return
404 → not found
422 → request validation failed
```

Uvicorn is the server process that listens for requests. FastAPI is the application framework that handles them.
