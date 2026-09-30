# Module 1 — Workstation, Git, Azure and Linux Baseline

## Objective

Create the foundation for the entire lab.

By the end of this module:

- GitHub is the source of truth.
- Azure CLI works locally.
- an Ubuntu VM exists in Azure.
- SSH access works using a key.
- cost controls are in place.
- basic Linux administration is comfortable.

## Step 1 — Create the GitHub repo

Suggested name: `it-governance-lab`

Suggested description:

> Hands-on lab covering Linux, web stacks, Python, APIs, PostgreSQL, Docker, Terraform and Azure for practical technical leadership.

Clone:

```bash
git clone <repo-url>
cd it-governance-lab
```

## Step 2 — Initial Git workflow

```bash
git status
git add .
git commit -m "Initial project structure and learning plan"
git push
```

Useful commands:

```bash
git status
git diff
git log --oneline
git branch
git switch -c <branch-name>
```

## Step 3 — Azure resource group

Recommended:

```text
Name: rg-it-governance-lab-dev
Region: Australia East
```

Later, Terraform will recreate this.

## Step 4 — Ubuntu VM

Recommended lab settings:

- Ubuntu LTS
- small burstable size
- SSH public-key authentication
- public IP for initial learning
- inbound SSH restricted to your current public IP where practical
- auto-shutdown enabled

Avoid using a password for SSH.

## Step 5 — Connect

```bash
ssh <admin-user>@<public-ip>
```

## Step 6 — Linux baseline

```bash
sudo apt update
sudo apt upgrade -y
whoami
hostname
uname -a
ip addr
df -h
free -h
ps aux
top
ss -tulpn
systemctl --failed
journalctl -p err -b
```

File and permission basics:

```bash
pwd
ls -la
mkdir lab-test
touch lab-test/example.txt
chmod 640 lab-test/example.txt
ls -l lab-test/example.txt
```

## Step 7 — Troubleshooting pattern

```text
What failed?
↓
Is the service running?
↓
What do the logs say?
↓
Is the port listening?
↓
Is the firewall/network path open?
```

Useful commands:

```bash
systemctl status <service>
journalctl -u <service>
```

## Step 8 — Learning note

Create `docs/learning-notes/module-01.md` and record commands, failures, fixes and questions.

## Completion checklist

- [ ] Repo created
- [ ] Repo cloned locally
- [ ] Initial commit pushed
- [ ] Azure CLI authenticated
- [ ] Dedicated resource group exists
- [ ] Cost alert/budget configured
- [ ] Ubuntu VM running
- [ ] SSH key authentication works
- [ ] VM auto-shutdown configured
- [ ] Linux updated
- [ ] Basic Linux commands tested
- [ ] Learning notes committed
