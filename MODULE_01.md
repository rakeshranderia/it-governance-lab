# Module 1 — Workstation, Git, Azure and Linux Baseline

## Objective

Create the foundation for the entire lab.

By the end of this module:

- GitHub is the source of truth.
- Azure CLI works locally.
- an Ubuntu VM exists in Azure.
- SSH access works using a key.
- cost controls are in place.
- basic Linux administration is comfortable.

## Design principle

This lab is designed to be simple, practical, free-first or very low cost where that does not reduce the learning value, and reusable by students or technical leaders refreshing hands-on skills.

The business problem remains deliberately simple so the technical lifecycle is the thing being learned.

## Step 1 — Confirm the workstation toolchain

Use Appendix 2 to confirm OpenSSH, Git, VS Code, Azure CLI, Terraform and Docker.

Current Windows baseline:

| Tool | Version |
|---|---|
| Windows OpenSSH | 9.5p2 |
| Git | 2.55.0 |
| VS Code | 1.138.0 |
| Azure CLI | 2.90.0 |
| Terraform | 1.16.2 |
| Docker | 29.8.1 |
| Git-bundled OpenSSH | 10.3p1 |

**Commit checkpoint:** `Document local workstation toolchain`

## Step 2 — Authenticate to Azure

```powershell
az login
az account list --output table
az account show
```

Confirm the intended personal lab subscription is enabled and set as default.

Do not publish subscription IDs, tenant IDs, account email addresses or historic employer tenant information.

**Commit checkpoint:** `Document Azure subscription and lab access setup`

## Step 3 — Create a dedicated SSH key

```powershell
New-Item -ItemType Directory -Force -Path $HOME\.ssh
```

On this workstation, PowerShell did not pass an empty `-N` argument to `ssh-keygen` as expected. The working command was:

```powershell
cmd /c "ssh-keygen -t ed25519 -C it-governance-lab -f %USERPROFILE%\.ssh\it-governance-lab -N \"\""
```

This creates:

```text
$HOME\.ssh\it-governance-lab       # private key — never commit
$HOME\.ssh\it-governance-lab.pub   # public key
```

## Step 4 — Create the lab resource group

```powershell
az group create `
  --name rg-it-governance-lab-dev `
  --location australiaeast
```

Confirm:

```powershell
az group list --output table
```

## Step 5 — Choose a suitable VM SKU

The original `Standard_B1s` choice was unavailable for this subscription in Australia East.

```powershell
az vm list-skus `
  --location australiaeast `
  --size Standard_B1s `
  --all `
  --output table
```

The free-eligible `Standard_B2pts_v2` was available. It provides 2 vCPU, 1 GB RAM and uses Arm64.

## Step 6 — Create the Ubuntu VM

The convenient `Ubuntu2204` alias resolved to x64 and was incompatible with the Arm64-only `Standard_B2pts_v2`.

The successful command used an explicit Arm64 Ubuntu image:

```powershell
az vm create `
  --resource-group rg-it-governance-lab-dev `
  --name vm-itlab-dev-01 `
  --image Canonical:0001-com-ubuntu-server-jammy:22_04-lts-arm64:latest `
  --size Standard_B2pts_v2 `
  --admin-username azureuser `
  --ssh-key-values "$HOME\.ssh\it-governance-lab.pub"
```

## Step 7 — Confirm the VM

```powershell
az vm list -d `
  --resource-group rg-it-governance-lab-dev `
  --output table
```

```powershell
az vm get-instance-view `
  --resource-group rg-it-governance-lab-dev `
  --name vm-itlab-dev-01 `
  --query "instanceView.statuses[].displayStatus" `
  --output table
```

Expected:

```text
Provisioning succeeded
VM running
```

## Step 8 — Test SSH connectivity

```powershell
Test-NetConnection <PUBLIC-IP> -Port 22
```

If SSH appears to hang, inspect the server from Azure:

```powershell
az vm run-command invoke `
  --resource-group rg-it-governance-lab-dev `
  --name vm-itlab-dev-01 `
  --command-id RunShellScript `
  --scripts "uptime; systemctl is-active ssh; systemctl status ssh --no-pager | head -20"
```

This confirmed the VM was healthy, `sshd` was active and TCP/22 was reachable.

## Step 9 — Connect using the working SSH client

The built-in Windows OpenSSH 9.5p2 client stalled during key exchange on this workstation.

Git for Windows included OpenSSH 10.3p1, which completed key exchange successfully.

```powershell
where.exe ssh
ssh -V
& "C:\Program Files\Git\usr\bin\ssh.exe" -V
```

Connect:

```powershell
& "C:\Program Files\Git\usr\bin\ssh.exe" `
  -o StrictHostKeyChecking=accept-new `
  -i "$HOME\.ssh\it-governance-lab" `
  azureuser@<PUBLIC-IP>
```

Successful result:

```text
Welcome to Ubuntu 22.04.5 LTS (... aarch64)
```

**Commit checkpoint:** `Document Azure VM setup and troubleshooting`

## Step 10 — Apply cost guardrails

- configure a budget/cost alert;
- enable VM auto-shutdown;
- stop/deallocate compute when not in use;
- prefer free-eligible or always-free services where they teach the same concept;
- remember disks, public IPs and supporting resources may still have charges.

## Step 11 — Linux baseline

```bash
sudo apt update
sudo apt upgrade -y
whoami
hostname
uname -a
ip addr
df -h
free -h
ps aux
ss -tulpn
systemctl --failed
journalctl -p err -b
```

File and permission basics:

```bash
pwd
ls -la
mkdir lab-test
touch lab-test/example.txt
chmod 640 lab-test/example.txt
ls -l lab-test/example.txt
```

## Step 12 — Update learning notes

Update `docs/learning-notes/module-01.md`.

**Commit checkpoint:** `Complete Module 1 Linux baseline`
