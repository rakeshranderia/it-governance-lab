# Azure VM Creation and SSH Connection Troubleshooting

## Summary

This incident covers the first Azure VM deployment and SSH connection for the lab.

Issues encountered:

1. generic Azure CLI traceback;
2. unavailable VM SKU;
3. PowerShell/JMESPath quoting;
4. Arm64/x64 image mismatch;
5. SSH session appearing to hang;
6. SSH client compatibility difference;
7. first-use host key verification.

The main lesson is to diagnose one layer at a time rather than treat everything as one generic Azure or SSH problem.

## 1. Generic Azure CLI traceback

### Symptom

```text
The content for this response was already consumed
```

A Trusted Launch warning appeared nearby.

### First hypothesis

Trusted Launch might be causing the deployment failure.

Retrying with:

```powershell
--security-type Standard
```

did not change the outcome.

### Diagnostic command

```powershell
az vm list-skus `
  --location australiaeast `
  --size Standard_B1s `
  --all `
  --output table
```

### Evidence

```text
NotAvailableForSubscription
```

### Root cause

The originally requested VM size was unavailable to this subscription in Australia East.

### Lesson

Do not assume the line immediately above an error is the cause. Check service constraints such as SKU availability, region, quota, policy and image compatibility.

## 2. JMESPath query failed in PowerShell

### Symptom

```text
invalid jmespath_type value
```

### Alternative

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

### Lesson

If nested quoting becomes harder than the data problem, return JSON and use PowerShell objects.

## 3. VM size and OS image architecture mismatch

### Symptom

```text
Cannot create a VM ... this VM size only supports a CPU Architecture of 'Arm64',
but an image or disk with CPU Architecture 'x64' was given.
```

### How to read it

```text
DeploymentFailed
    -> BadRequest
        -> architecture mismatch
```

### Root cause

`Standard_B2pts_v2` is Arm64-only while the original Ubuntu alias selected x64.

### Fix

```powershell
az vm create `
  --resource-group rg-it-governance-lab-dev `
  --name vm-itlab-dev-01 `
  --image Canonical:0001-com-ubuntu-server-jammy:22_04-lts-arm64:latest `
  --size Standard_B2pts_v2 `
  --admin-username azureuser `
  --ssh-key-values "$HOME\.ssh\it-governance-lab.pub"
```

## 4. SSH appeared to hang

### Step 1 — VM state

```powershell
az vm get-instance-view `
  --resource-group rg-it-governance-lab-dev `
  --name vm-itlab-dev-01 `
  --query "instanceView.statuses[].displayStatus" `
  --output table
```

Evidence:

```text
Provisioning succeeded
VM running
```

### Step 2 — TCP/22

```powershell
Test-NetConnection <PUBLIC-IP> -Port 22
```

Evidence:

```text
TcpTestSucceeded : True
```

### Step 3 — Check `sshd` from Azure

```powershell
az vm run-command invoke `
  --resource-group rg-it-governance-lab-dev `
  --name vm-itlab-dev-01 `
  --command-id RunShellScript `
  --scripts "uptime; systemctl is-active ssh; systemctl status ssh --no-pager | head -20"
```

Evidence:

- Ubuntu was up;
- `ssh.service` was active;
- `sshd` was listening on port 22.

The logs also showed unrelated pre-authentication traffic from internet scanners. Source IPs are intentionally omitted.

### Step 4 — Verbose SSH

```powershell
ssh -vvv `
  -o ConnectTimeout=10 `
  -o IdentitiesOnly=yes `
  -i "$HOME\.ssh\it-governance-lab" `
  azureuser@<PUBLIC-IP>
```

The built-in Windows client reached:

```text
Connection established
SSH2_MSG_KEXINIT sent
SSH2_MSG_KEXINIT received
```

but did not complete the session.

### Step 5 — Compare clients

```powershell
ssh -V
& "C:\Program Files\Git\usr\bin\ssh.exe" -V
```

Observed:

```text
OpenSSH_for_Windows_9.5p2
OpenSSH_10.3p1
```

The newer Git-bundled client progressed beyond key exchange.

### Step 6 — Successful connection

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

### Why `accept-new`

`StrictHostKeyChecking=accept-new` accepts a host key that has never been seen before while still rejecting an unexpected change to a previously known key.

## Troubleshooting model

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

## Security observation

A newly created public VM received unsolicited connection attempts within minutes.

Lessons:

- public services are continuously scanned;
- an unknown IP is not a security control;
- restrict inbound access where practical;
- keep authentication strong;
- monitor logs;
- remove public exposure when the lab no longer needs it.

This will be revisited during the later hardening and operability modules.
