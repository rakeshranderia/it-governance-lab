# Workstation and Azure Setup Guide

The primary workstation can be Windows. A Mac can also be used for SSH/Git work, but the main lab workflow is expected to run from the Windows PC.

## Recommended Windows workstation

Install or verify:

- Windows Terminal
- PowerShell 7
- OpenSSH client
- Git
- Visual Studio Code
- Azure CLI
- Terraform
- Docker Desktop
- Optional later: WSL2 + Ubuntu

## Quick version checks

```powershell
ssh -V
git --version
az --version
code --version
terraform -version
docker --version
```

## Azure CLI login

```powershell
az login
az account list --output table
az account show
```

If more than one subscription exists:

```powershell
az account set --subscription "<subscription-name-or-id>"
```

## SSH key

```powershell
Get-ChildItem $HOME\.ssh
```

If needed:

```powershell
ssh-keygen -t ed25519 -C "it-governance-lab"
```

Never commit the private key.

## Azure cost-safety checklist

- Confirm the subscription containing the trial credit.
- Create a dedicated resource group.
- Configure a cost alert/budget.
- Enable VM auto-shutdown.
- Prefer small VM sizes.
- Stop/deallocate compute when not in use.
- Destroy temporary Terraform resources after experiments.
- Review Azure Cost Management regularly.

## Suggested naming

```text
Resource group: rg-it-governance-lab-dev
Region: Australia East
VM: vm-itlab-dev-01
VNet: vnet-itlab-dev
Subnet: snet-app
```
