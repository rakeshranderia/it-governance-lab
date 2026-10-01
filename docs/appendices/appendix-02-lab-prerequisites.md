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

## Install Azure CLI

```powershell
winget install -e --id Microsoft.AzureCLI --accept-source-agreements --accept-package-agreements
```

If needed:

```powershell
winget install -e --id Microsoft.AzureCLI --source winget --accept-source-agreements --accept-package-agreements
```

## Install Terraform

```powershell
winget install -e --id Hashicorp.Terraform --accept-source-agreements --accept-package-agreements
```

## Install Docker Desktop

```powershell
winget install -e --id Docker.DockerDesktop --accept-source-agreements --accept-package-agreements
```

## Known issue — Winget source agreement

If `winget` appears stuck on Microsoft Store source terms, cancel and rerun with:

```text
--accept-source-agreements --accept-package-agreements
```

## Azure login

```powershell
az login
az account list --output table
az account show
```

## SSH key

```powershell
Get-ChildItem $HOME\.ssh
```

If required:

```powershell
ssh-keygen -t ed25519 -C "it-governance-lab"
```

## Recommended Azure naming

```text
Resource Group: rg-it-governance-lab-dev
Region: Australia East
VM: vm-itlab-dev-01
VNet: vnet-itlab-dev
Subnet: snet-app
```

## Cost safety

- Confirm the correct subscription.
- Create a dedicated resource group.
- Configure a budget/cost alert.
- Enable VM auto-shutdown.
- Prefer small burstable VM sizes.
- Stop/deallocate compute when not in use.
- Destroy temporary Terraform resources after experiments.

**Commit checkpoint:** `Complete lab workstation prerequisites`
