# Module 1 — Workstation, Git, Azure and Linux Baseline

## Objective

Create the foundation for the lab: local tooling, Azure CLI access, an Ubuntu VM, SSH access, a Linux baseline, patching, reboot and validation.

## Design principle

Keep the problem simple, the technical lifecycle complete, costs low, and the lab reusable by students or technical leaders refreshing hands-on skills.

## Completed outcomes

- GitHub is the source of truth.
- Azure CLI works locally.
- A dedicated ED25519 SSH key exists.
- Resource group `rg-it-governance-lab-dev` exists in Australia East.
- An Ubuntu 22.04.5 LTS Arm64 VM exists.
- `Standard_B2pts_v2` was selected after checking subscription/region availability.
- SSH connectivity and client compatibility were troubleshot.
- Linux baseline data was captured.
- The VM was patched.
- Restart requirements were reviewed.
- The VM was rebooted and validated.

## Workstation baseline

| Tool | Version |
|---|---|
| Windows OpenSSH | 9.5p2 |
| Git | 2.55.0 |
| VS Code | 1.138.0 |
| Azure CLI | 2.90.0 |
| Terraform | 1.16.2 |
| Docker | 29.8.1 |
| Git-bundled OpenSSH | 10.3p1 |

## Azure VM creation

The original `Standard_B1s` size was unavailable for this subscription in Australia East.

The available Arm64 size was:

```text
Standard_B2pts_v2
```

The successful VM command was:

```powershell
az vm create `
  --resource-group rg-it-governance-lab-dev `
  --name vm-itlab-dev-01 `
  --image Canonical:0001-com-ubuntu-server-jammy:22_04-lts-arm64:latest `
  --size Standard_B2pts_v2 `
  --admin-username azureuser `
  --ssh-key-values "$HOME\.ssh\it-governance-lab.pub"
```

## SSH

The built-in Windows OpenSSH client did not complete the session cleanly. Git for Windows included a newer OpenSSH client that worked reliably for remote command execution.

```powershell
& "C:\Program Files\Git\usr\bin\ssh.exe" `
  -i "$HOME\.ssh\it-governance-lab" `
  azureuser@<PUBLIC-IP> `
  "whoami; hostname; uname -a"
```

## Fresh Linux baseline

Commands used:

```powershell
& "C:\Program Files\Git\usr\bin\ssh.exe" `
  -i "$HOME\.ssh\it-governance-lab" `
  azureuser@<PUBLIC-IP> `
  "whoami; hostname; uname -a; cat /etc/os-release"
```

```powershell
& "C:\Program Files\Git\usr\bin\ssh.exe" `
  -i "$HOME\.ssh\it-governance-lab" `
  azureuser@<PUBLIC-IP> `
  "ip addr; df -h; free -h"
```

```powershell
& "C:\Program Files\Git\usr\bin\ssh.exe" `
  -i "$HOME\.ssh\it-governance-lab" `
  azureuser@<PUBLIC-IP> `
  "ps aux | head; ss -tulpn; systemctl --failed; journalctl -p err -b --no-pager | tail -30"
```

Observed:

- Ubuntu 22.04.5 LTS
- Arm64 / aarch64
- about 1 GB RAM
- no swap
- about 29 GB root filesystem
- SSH listening on TCP/22
- no failed systemd units
- unsolicited SSH pre-authentication traffic visible in the journal
- 112 updates available, including 92 standard security updates

## Patching

```powershell
& "C:\Program Files\Git\usr\bin\ssh.exe" `
  -i "$HOME\.ssh\it-governance-lab" `
  azureuser@<PUBLIC-IP> `
  "sudo apt update && sudo DEBIAN_FRONTEND=noninteractive apt upgrade -y"
```

`needrestart` reported services requiring restart and several deferred restarts.

Post-patch validation:

```powershell
& "C:\Program Files\Git\usr\bin\ssh.exe" `
  -i "$HOME\.ssh\it-governance-lab" `
  azureuser@<PUBLIC-IP> `
  "apt list --upgradable 2>/dev/null | head -20; echo '---'; systemctl --failed; echo '---'; free -h; echo '---'; df -h /"
```

The system remained healthy with no failed units and only `sosreport` still listed as upgradable.

## Reboot and final validation

```powershell
az vm restart `
  --resource-group rg-it-governance-lab-dev `
  --name vm-itlab-dev-01
```

Confirm state:

```powershell
az vm get-instance-view `
  --resource-group rg-it-governance-lab-dev `
  --name vm-itlab-dev-01 `
  --query "instanceView.statuses[].displayStatus" `
  --output table
```

Final health validation:

```powershell
& "C:\Program Files\Git\usr\bin\ssh.exe" `
  -i "$HOME\.ssh\it-governance-lab" `
  azureuser@<PUBLIC-IP> `
  "uptime; echo '---'; systemctl --failed; echo '---'; apt list --upgradable 2>/dev/null | head -20; echo '---'; free -h; echo '---'; df -h /"
```

## Module 1 complete

**Commit checkpoint:** `Complete Module 1 Linux baseline`
