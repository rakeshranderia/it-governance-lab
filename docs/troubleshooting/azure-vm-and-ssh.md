# Azure VM and SSH Troubleshooting

## Lessons captured

- VM SKU availability can vary by subscription/region.
- PowerShell/JMESPath quoting can be more trouble than the data problem.
- Arm64-only VM sizes require Arm64 images.
- TCP/22 reachability does not prove SSH negotiation will complete.
- Different SSH clients can behave differently.
- Public VMs receive unsolicited scans quickly.

## Useful checks

```powershell
az vm get-instance-view --resource-group rg-it-governance-lab-dev --name vm-itlab-dev-01
Test-NetConnection <PUBLIC-IP> -Port 22
ssh -vvv -i "$HOME\.ssh\it-governance-lab" azureuser@<PUBLIC-IP>
```

## Troubleshooting model

```text
VM state
→ network reachability
→ SSH daemon
→ key exchange
→ host identity
→ user authentication
→ shell
```
