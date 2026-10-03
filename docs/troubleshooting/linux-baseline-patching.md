# Linux Baseline, Patching and Reboot Validation

## Symptom / starting point

A fresh Ubuntu VM was running successfully, but it reported:

```text
112 updates can be applied immediately.
92 of these updates are standard security updates.
```

## Baseline commands

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

## Patch command

```powershell
& "C:\Program Files\Git\usr\bin\ssh.exe" `
  -i "$HOME\.ssh\it-governance-lab" `
  azureuser@<PUBLIC-IP> `
  "sudo apt update && sudo DEBIAN_FRONTEND=noninteractive apt upgrade -y"
```

## `needrestart` interpretation

`needrestart` reported services that should be restarted and several deferred restarts.

Plain English:

- packages on disk had been updated;
- some running services still had old code loaded in memory;
- restarting or rebooting was needed to fully activate the updated components.

## Post-patch validation

```powershell
& "C:\Program Files\Git\usr\bin\ssh.exe" `
  -i "$HOME\.ssh\it-governance-lab" `
  azureuser@<PUBLIC-IP> `
  "apt list --upgradable 2>/dev/null | head -20; echo '---'; systemctl --failed; echo '---'; free -h; echo '---'; df -h /"
```

Observed:

- zero failed systemd units
- approximately 585 MiB memory available
- root disk around 10% used
- `sosreport` still listed as upgradable

## Reboot

```powershell
az vm restart `
  --resource-group rg-it-governance-lab-dev `
  --name vm-itlab-dev-01
```

## Final validation

```powershell
& "C:\Program Files\Git\usr\bin\ssh.exe" `
  -i "$HOME\.ssh\it-governance-lab" `
  azureuser@<PUBLIC-IP> `
  "uptime; echo '---'; systemctl --failed; echo '---'; apt list --upgradable 2>/dev/null | head -20; echo '---'; free -h; echo '---'; df -h /"
```

## What this taught me

A patch cycle is not simply `apt update && apt upgrade`.

The complete operational pattern is:

```text
understand current state
-> patch
-> review restart requirements
-> restart/reboot
-> validate health
```
