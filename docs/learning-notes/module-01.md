# Module 1 — Workstation, Azure and Linux Baseline

## Objectives

- Confirm workstation tooling
- Authenticate Azure CLI
- Confirm the intended Azure subscription
- Create a dedicated SSH key
- Create an Azure resource group
- Select an available low-cost/free-eligible VM size
- Create an Arm64 Ubuntu VM
- Diagnose Azure CLI deployment failures
- Diagnose an SSH connection that appeared to hang
- Connect successfully using key-based SSH
- Complete Linux baseline checks

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

## Lab design decision

Troubleshooting is a first-class learning outcome. The lab should show not only what worked, but how errors were interpreted and narrowed down.

The project follows these principles:

- simple problem;
- complete technical journey;
- free-first where practical;
- reusable by students and others refreshing skills;
- no sensitive account or workstation identifiers in public documentation.

## Azure baseline

Resource group:

```text
rg-it-governance-lab-dev
```

Region:

```text
Australia East
```

VM:

```text
vm-itlab-dev-01
```

OS:

```text
Ubuntu 22.04.5 LTS, Arm64
```

## SSH key

A dedicated ED25519 key pair was created.

```text
$HOME\.ssh\it-governance-lab
$HOME\.ssh\it-governance-lab.pub
```

The private key remains local and must never be committed.

### PowerShell issue

This did not pass the empty passphrase argument correctly:

```powershell
ssh-keygen -t ed25519 -C "it-governance-lab" -f "$HOME\.ssh\it-governance-lab" -N ""
```

Working alternative:

```powershell
cmd /c "ssh-keygen -t ed25519 -C it-governance-lab -f %USERPROFILE%\.ssh\it-governance-lab -N \"\""
```

## Azure VM troubleshooting

### Generic Azure CLI traceback

Initial VM creation attempts returned:

```text
The content for this response was already consumed
```

A Trusted Launch warning appeared nearby, but a retry with `--security-type Standard` produced the same result.

The useful diagnostic was:

```powershell
az vm list-skus `
  --location australiaeast `
  --size Standard_B1s `
  --all `
  --output table
```

`Standard_B1s` was `NotAvailableForSubscription`.

**Learning:** adjacent warnings are not automatically root causes. Check cloud-side constraints such as SKU availability, quota, policy, region and image compatibility.

### PowerShell/JMESPath quoting

A complex `--query` failed with:

```text
invalid jmespath_type value
```

A simpler approach was to return JSON and filter natively:

```powershell
$skus = az vm list-skus `
  --location australiaeast `
  --resource-type virtualMachines `
  --all `
  --output json | ConvertFrom-Json
```

```powershell
$skus |
  Where-Object {
    $_.restrictions.Count -eq 0 -and
    ($_.name -like "Standard_B*" -or $_.name -like "Standard_D*")
  } |
  Select-Object -First 20 `
    name,
    @{Name="vCPU";Expression={($_.capabilities | Where-Object name -eq "vCPUs").value}},
    @{Name="MemoryGB";Expression={($_.capabilities | Where-Object name -eq "MemoryGB").value}}
```

**Learning:** if shell quoting becomes harder than the data problem, use the shell's native object pipeline.

### CPU architecture mismatch

The selected `Standard_B2pts_v2` VM size was available, but Azure returned:

```text
Cannot create a VM ... this VM size only supports a CPU Architecture of 'Arm64',
but an image or disk with CPU Architecture 'x64' was given.
```

The useful way to read the nested error was:

```text
DeploymentFailed
    -> BadRequest
        -> architecture mismatch
```

Fix:

```powershell
az vm create `
  --resource-group rg-it-governance-lab-dev `
  --name vm-itlab-dev-01 `
  --image Canonical:0001-com-ubuntu-server-jammy:22_04-lts-arm64:latest `
  --size Standard_B2pts_v2 `
  --admin-username azureuser `
  --ssh-key-values "$HOME\.ssh\it-governance-lab.pub"
```

## SSH troubleshooting

### Symptom

```powershell
ssh -i "$HOME\.ssh\it-governance-lab" azureuser@<PUBLIC-IP>
```

appeared to hang.

### Confirm network reachability

```powershell
Test-NetConnection <PUBLIC-IP> -Port 22
```

Result:

```text
TcpTestSucceeded : True
```

This proves the port is reachable, not that authentication will succeed.

### Confirm VM state

```powershell
az vm get-instance-view `
  --resource-group rg-it-governance-lab-dev `
  --name vm-itlab-dev-01 `
  --query "instanceView.statuses[].displayStatus" `
  --output table
```

Result:

```text
Provisioning succeeded
VM running
```

### Check `sshd` from Azure

```powershell
az vm run-command invoke `
  --resource-group rg-it-governance-lab-dev `
  --name vm-itlab-dev-01 `
  --command-id RunShellScript `
  --scripts "uptime; systemctl is-active ssh; systemctl status ssh --no-pager | head -20"
```

This confirmed `sshd` was active and listening.

The logs also showed unrelated pre-authentication connection attempts shortly after the public VM was created.

**Security learning:** public services can be discovered by automated internet scanning very quickly.

### Inspect the SSH handshake

```powershell
ssh -vvv `
  -o ConnectTimeout=10 `
  -o IdentitiesOnly=yes `
  -i "$HOME\.ssh\it-governance-lab" `
  azureuser@<PUBLIC-IP>
```

The Windows client reached:

```text
Connection established
SSH2_MSG_KEXINIT sent
SSH2_MSG_KEXINIT received
```

but did not complete the session.

### Compare clients

Windows OpenSSH:

```text
OpenSSH_for_Windows_9.5p2
```

Git-bundled OpenSSH:

```text
OpenSSH_10.3p1
```

The newer Git-bundled client progressed through key exchange and received the server host key.

### Successful connection

```powershell
& "C:\Program Files\Git\usr\bin\ssh.exe" `
  -o StrictHostKeyChecking=accept-new `
  -i "$HOME\.ssh\it-governance-lab" `
  azureuser@<PUBLIC-IP>
```

Result:

```text
Welcome to Ubuntu 22.04.5 LTS (... aarch64)
```

### Troubleshooting model

```text
VM state
  -> network reachability
      -> SSH daemon
          -> protocol negotiation
              -> key exchange
                  -> host identity verification
                      -> user authentication
                          -> shell
```

Test one layer at a time.

## Current status

Completed:

- workstation tools confirmed;
- Azure CLI authenticated;
- resource group created;
- dedicated SSH key created;
- suitable VM SKU identified;
- Arm64 Ubuntu VM created;
- VM health verified;
- TCP/22 verified;
- SSH daemon verified;
- SSH client issue isolated;
- interactive SSH login successful.

Next:

- cost guardrails / auto-shutdown;
- Linux baseline commands;
- first Linux observations.

## Commit checkpoints

Current checkpoint:

```text
Document Azure VM setup and troubleshooting
```

End of module:

```text
Complete Module 1 Linux baseline
```
