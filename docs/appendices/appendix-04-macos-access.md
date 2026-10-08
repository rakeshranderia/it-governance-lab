# Appendix 4 — Connecting to the Azure Lab from macOS

This appendix documents the optional macOS access path. The main lab remains Windows-first/platform-neutral where practical.

## Check local tools

```bash
git --version
ssh -V
```

Azure CLI is optional for basic SSH work.

## Create a Mac-specific SSH key

```bash
mkdir -p ~/.ssh
chmod 700 ~/.ssh

ssh-keygen -t ed25519 \
  -C "it-governance-lab-mac" \
  -f ~/.ssh/it-governance-lab-mac
```

Show only the public key:

```bash
cat ~/.ssh/it-governance-lab-mac.pub
```

Add that public key to the VM user's `~/.ssh/authorized_keys`, then connect:

```bash
ssh -i ~/.ssh/it-governance-lab-mac azureuser@<PUBLIC-IP>
```

## Run the health check from macOS

```bash
cat ./scripts/lamp-health-check.sh | \
ssh -i ~/.ssh/it-governance-lab-mac azureuser@<PUBLIC-IP> \
"sudo bash -s"
```

## Git hygiene when switching machines

Before working:

```bash
git pull
git status
```

After working:

```bash
git add .
git commit -m "Meaningful message"
git push
```

Treat GitHub as the source of truth between devices.
