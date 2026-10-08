# Learning Path

## Phase 1 — Core Lab

### Module 1 — Workstation, Git, Azure and Linux baseline
Outcome: GitHub repo, Azure CLI, Ubuntu VM, SSH, Linux baseline, cost controls.

### Module 2 — LAMP stack
Outcome: Linux + Apache + PHP + MariaDB with a simple CRUD IT Asset Register.

### Module 3 — Web request flow, break/fix and HTTPS
Outcome: Understand browser → listener → Apache → PHP → database flow; deliberately break and repair the stack; enable HTTPS; redirect HTTP to HTTPS.

### Module 4 — Python fundamentals
Outcome: Variables, lists, dicts, functions, modules, exceptions, venvs, JSON and an external REST API.

### Module 5 — FastAPI
Outcome: Build GET, POST, PUT/PATCH and DELETE endpoints; understand common HTTP status codes.

### Module 6 — PostgreSQL
Outcome: Relational schema, core SQL, and FastAPI persistence.

### Module 7 — Integration
Outcome: Python ingests external data, transforms it, stores it in PostgreSQL and exposes it via API.

### Module 8 — Docker
Outcome: Containerise FastAPI and run FastAPI + PostgreSQL with Docker Compose.

### Module 9 — Terraform fundamentals
Outcome: provider, resource, variable, output, data and state; init, plan, apply and destroy.

### Module 10 — Azure infrastructure with Terraform
Outcome: Resource group, VNet, subnet, NSG, compute and storage.

### Module 11 — Terraform state and drift
Outcome: Remote Azure state, locking, drift, import and deliberate drift detection.

### Module 12 — Terraform modules
Outcome: Refactor into reusable modules and a dev environment.

### Module 13 — Deploy the application
Outcome: Terraform-created Azure infrastructure hosting the containerised Python application.

### Module 14 — Operability
Outcome: Logs, monitoring, health checks, secret handling, hardening and an operations runbook.

## Optional side quests

- Linux: cron, bash scripting, log rotation, process/disk troubleshooting.
- Git: merge conflict, revert, branch, PR, release tag.
- Python: pytest and deliberate test failure.
- SQL: indexing, parameterised queries and injection risk.
- APIs: API key, bearer token, JWT and OAuth concepts.
- Security: relevant OWASP Top 10 review.
- Azure: cost alerts, auto-shutdown, tagging, cleanup.

## Appendices

### Appendix 1 — Moving from VS Code to Git CLI
[Read Appendix 1](docs/appendices/appendix-01-git-cli.md)

### Appendix 2 — Lab Setup and Prerequisites
[Read Appendix 2](docs/appendices/appendix-02-lab-prerequisites.md)

### Appendix 3 — Working in a Messy Lab Environment
[Read Appendix 3](docs/appendices/appendix-03-working-in-a-messy-lab.md)

### Appendix 4 — Connecting to the Lab from macOS
[Read Appendix 4](docs/appendices/appendix-04-macos-access.md)
