# Appendix 3 — Working in a Messy Lab Environment

Most real learning machines are not clean-room builds.

They may contain old identities, multiple tenants/subscriptions, several SSH clients, mixed shells, stale credentials and partial installs.

## Identity first

```powershell
az account show --output table
az account list --output table
```

## Which executable am I using?

```powershell
where.exe ssh
ssh -V
```

## Use variables for repeated values

```powershell
$VMIP = "<PUBLIC-IP>"
$SSH = "C:\Program Files\Git\usr\bin\ssh.exe"
```

## Pre-flight sanity check

```powershell
az account show --output table
where.exe ssh
ssh -V
git --version
terraform version
docker --version
```

## Public documentation hygiene

Do not publish usernames, personal emails, tenant IDs, subscription IDs, public IPs, private SSH keys or database passwords.

Use placeholders such as:

```text
<PUBLIC-IP>
<USERNAME>
<TENANT-ID>
<SUBSCRIPTION-ID>
```

## Troubleshooting mindset

```text
Which identity is active?
→ Which executable is running?
→ Which shell is parsing this?
→ Which remote system am I targeting?
→ Which application produced the error?
```
