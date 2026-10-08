# Module 1 — Learning Notes

## What I built

- Azure Ubuntu VM
- SSH access
- Linux baseline
- patch/reboot/validation workflow

## Important lessons

- VM size availability can differ by subscription/region.
- CPU architecture must match the image.
- Adjacent warnings are not necessarily root cause.
- Multiple SSH clients can behave differently.
- Public VMs are scanned almost immediately.
- A complete patch cycle includes validation and reboot where required.

## Troubleshooting model

```text
VM state
→ network reachability
→ SSH daemon
→ protocol negotiation
→ authentication
→ shell
```
