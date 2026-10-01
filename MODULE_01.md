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

## Step 1 — Confirm the workstation toolchain

Use Appendix 2 to confirm OpenSSH, Git, VS Code, Azure CLI, Terraform and Docker.

**Commit checkpoint:** `Document local workstation toolchain`

## Step 2 — Authenticate to Azure

```powershell
az login
az account list --output table
az account show
```

Confirm that the subscription containing the trial credit is active.

**Commit checkpoint:** `Document Azure subscription and lab access setup`

## Step 3 — Confirm or create an SSH key

```powershell
Get-ChildItem $HOME\.ssh
```

If needed:

```powershell
ssh-keygen -t ed25519 -C "it-governance-lab"
```

## Step 4 — Create the lab resource group

Recommended:
- Name: `rg-it-governance-lab-dev`
- Region: `Australia East`

## Step 5 — Apply cost guardrails

- configure a budget/cost alert;
- enable VM auto-shutdown;
- prefer a small burstable VM;
- stop/deallocate compute when not in use.

## Step 6 — Create the Ubuntu VM

Recommended:
- Ubuntu LTS
- small burstable size
- SSH public-key authentication
- public IP for initial learning
- inbound SSH restricted to your current public IP where practical
- auto-shutdown enabled

## Step 7 — Connect

```bash
ssh <admin-user>@<public-ip>
```

**Commit checkpoint:** `Document Azure Ubuntu VM and SSH setup`

## Step 8 — Linux baseline

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

File/permission basics:

```bash
pwd
ls -la
mkdir lab-test
touch lab-test/example.txt
chmod 640 lab-test/example.txt
ls -l lab-test/example.txt
```

## Step 9 — Update learning notes

Update `docs/learning-notes/module-01.md`.

**Commit checkpoint:** `Complete Module 1 Linux baseline`
