# Module 1 — Learning Notes

## What I built

- Windows workstation toolchain
- Azure CLI authentication
- dedicated SSH key
- Azure resource group
- Ubuntu 22.04.5 LTS Arm64 VM
- working SSH command path
- Linux baseline
- patch/reboot/validation cycle

## What broke and what I learned

### VM SKU unavailable

`Standard_B1s` returned `NotAvailableForSubscription`.

**Lesson:** cloud SKUs are constrained by subscription, region and zone. Check availability rather than assuming a documented size is deployable.

### PowerShell/JMESPath quoting

A complex Azure CLI `--query` became harder to troubleshoot than the data itself.

**Lesson:** return JSON and use `ConvertFrom-Json` plus PowerShell objects when shell quoting becomes fragile.

### Arm64/x64 mismatch

`Standard_B2pts_v2` is Arm64-only, while the convenient Ubuntu alias resolved to x64.

**Lesson:** VM hardware architecture and image architecture must match.

### SSH troubleshooting

Network connectivity, the VM, and `sshd` were all healthy.

The built-in Windows OpenSSH client did not complete the session cleanly, while Git for Windows OpenSSH did.

**Lesson:** troubleshoot SSH in layers:

```text
VM state
-> TCP reachability
-> sshd
-> protocol negotiation
-> key exchange
-> host verification
-> authentication
-> shell
```

### Public SSH exposure

The VM received unsolicited pre-authentication SSH traffic shortly after creation.

**Lesson:** public IPs are scanned continuously. An unadvertised address is not a security control.

## Fresh Linux baseline

Observed:

- Ubuntu 22.04.5 LTS
- Arm64 / aarch64
- approximately 952 MiB RAM
- no swap
- approximately 29 GB root filesystem
- no failed systemd units
- SSH listening on TCP/22
- 112 updates available
- 92 standard security updates

## Patching

The VM was patched with:

```powershell
& "C:\Program Files\Git\usr\bin\ssh.exe" `
  -i "$HOME\.ssh\it-governance-lab" `
  azureuser@<PUBLIC-IP> `
  "sudo apt update && sudo DEBIAN_FRONTEND=noninteractive apt upgrade -y"
```

`needrestart` identified services still using older binaries/libraries.

A reboot was used to complete the maintenance cycle cleanly.

## Post-patch validation

After patching:

- `systemctl --failed` still showed zero failed units
- memory remained healthy
- disk usage remained low
- only `sosreport` remained listed as upgradable

The VM was rebooted and validated again.

## Operational lesson

A complete patch cycle is:

```text
baseline
-> patch
-> review restart requirements
-> reboot/restart
-> validate
```

A successful package command does not, by itself, prove the system is healthy afterwards.

## Status

Module 1 complete.

Next:

```text
Module 2 — LAMP stack
```

## Commit checkpoint

```text
Complete Module 1 Linux baseline
```
