# Troubleshooting Notes

Troubleshooting is a first-class learning outcome in this repository.

The goal is not only to record the fix, but to show how an error was interpreted and how the fault domain was narrowed.

Use one page per incident or deliberate break/fix exercise.

## Recommended format

1. **Symptom** — what was actually seen.
2. **Plain-English interpretation** — what the message appears to mean.
3. **First hypothesis** — clearly labelled as a hypothesis.
4. **Commands/tools used** — exact reusable commands with sensitive values replaced.
5. **Evidence found** — what each diagnostic step proved or ruled out.
6. **Root cause** — only after evidence supports it.
7. **Fix** — the command or configuration change.
8. **Why the fix worked** — connect fix to cause.
9. **Security/cost implications** — where relevant.
10. **What this taught me** — the transferable lesson.

## Sanitisation rules

Do not publish:

- local Windows usernames;
- account email addresses;
- subscription IDs;
- tenant IDs;
- public IP addresses;
- historic employer tenant names;
- SSH private keys;
- real third-party scanner IP addresses.

Use placeholders such as:

```text
<PUBLIC-IP>
<SUBSCRIPTION-ID>
<TENANT-ID>
<USERNAME>
```

Prefer portable paths such as:

```powershell
$HOME\.ssh\it-governance-lab
```
