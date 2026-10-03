# Appendix 3 — Working in a Messy Lab Environment

Most real learning machines are not clean-room builds.

They may contain:

- old work identities;
- multiple Azure tenants;
- multiple subscriptions;
- several SSH clients;
- Git installed years ago;
- mixed PowerShell and Git Bash usage;
- stale environment variables;
- old credentials;
- partially installed tools;
- copied commands with stray characters.

This guide assumes that is normal.

The objective is not to rebuild the machine every time something is ambiguous.

The objective is to learn how to identify the active context.

---

## 1. Identity first

Before creating cloud resources:

```powershell
az account show --output table
```

If required:

```powershell
az account list --output table
```

Confirm:

- the expected account;
- the expected subscription;
- the expected tenant/context.

Do not assume `az login` selected the account you wanted.

---

## 2. Which executable am I actually running?

Windows may contain more than one copy of a tool.

Example:

```powershell
where.exe ssh
```

Then:

```powershell
ssh -V
```

A Git installation may also include SSH:

```powershell
& "C:\Program Files\Git\usr\bin\ssh.exe" -V
```

In this lab, the two SSH clients behaved differently.

That made the executable path important.

---

## 3. Use variables for repeated values

Instead of repeatedly pasting:

```text
20.x.x.x
```

into every command, define:

```powershell
$VMIP = "<PUBLIC-IP>"
$SSH = "C:\Program Files\Git\usr\bin\ssh.exe"
```

Then:

```powershell
& $SSH `
  -i "$HOME\.ssh\it-governance-lab" `
  "azureuser@$VMIP" `
  "hostname"
```

### Why this helps

It reduces:

- copy/paste mistakes;
- accidental trailing backticks;
- accidental disclosure in screenshots/docs;
- command length;
- effort if the public IP changes.

---

## 4. PowerShell backticks are fragile

PowerShell uses a backtick for line continuation:

```powershell
command `
  argument `
  argument
```

If you copy only part of a command, the backtick may accidentally travel with the copied value.

Example problem:

```text
<PUBLIC-IP> `
```

pasted into another command may change how PowerShell parses the following line.

### Practical habit

Put repeated values in variables instead of copying them from an earlier command.

---

## 5. Shells are not interchangeable

These are different environments:

```text
PowerShell
Command Prompt
Git Bash
Linux Bash
```

The same-looking command may behave differently because:

- quoting differs;
- environment variables differ;
- executable resolution differs;
- path syntax differs;
- escaping differs.

Always know which shell is interpreting the command.

---

## 6. Pre-flight sanity check

Before a new module or after returning to the lab after a break:

```powershell
az account show --output table
where.exe ssh
ssh -V
git --version
terraform version
docker --version
```

Then set session variables:

```powershell
$VMIP = "<PUBLIC-IP>"
$SSH = "C:\Program Files\Git\usr\bin\ssh.exe"
```

For this VM, confirm remote identity:

```powershell
& $SSH `
  -i "$HOME\.ssh\it-governance-lab" `
  "azureuser@$VMIP" `
  "whoami; hostname; uname -a"
```

---

## 7. Public documentation hygiene

Do not commit or publish:

- local usernames;
- personal email addresses;
- tenant IDs;
- subscription IDs;
- public IP addresses;
- old employer identities;
- private SSH keys;
- database passwords.

Prefer:

```text
<PUBLIC-IP>
<USERNAME>
<TENANT-ID>
<SUBSCRIPTION-ID>
```

and:

```powershell
$HOME\.ssh\it-governance-lab
```

instead of literal profile paths.

---

## 8. The troubleshooting mindset

A messy lab is useful because it teaches a real operational skill:

```text
What environment am I in?
        ↓
Which identity is active?
        ↓
Which executable is running?
        ↓
Which shell is parsing this?
        ↓
Which remote system am I targeting?
        ↓
Which application produced the error?
```

That is more transferable than memorising one perfect command.
