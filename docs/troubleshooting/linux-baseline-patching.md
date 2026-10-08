# Linux Baseline, Patching and Reboot Validation

## Patch cycle

```text
understand current state
→ patch
→ review restart requirements
→ restart/reboot
→ validate health
```

## Patch command

```bash
sudo apt update && sudo DEBIAN_FRONTEND=noninteractive apt upgrade -y
```

## Validate

```bash
systemctl --failed
free -h
df -h /
```
