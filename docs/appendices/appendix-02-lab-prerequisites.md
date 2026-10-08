# Appendix 2 — Lab Setup and Prerequisites

## Workstation baseline

| Tool | Version |
|---|---|
| OpenSSH | 9.5p2 |
| Git | 2.55.0 |
| VS Code | 1.138.0 |
| Azure CLI | 2.90.0 |
| Terraform | 1.16.2 |
| Docker | 29.8.1 |

## Version checks

```powershell
ssh -V
git --version
az --version
code --version
terraform -version
docker --version
```

## Azure login

```powershell
az login
az account list --output table
az account show
```

## Cost safety

- Confirm the correct subscription.
- Create a dedicated resource group.
- Configure a budget/cost alert.
- Enable VM auto-shutdown.
- Stop/deallocate compute when not in use.
- Destroy temporary Terraform resources after experiments.
