# PowerShell, SSH, Bash and Quoting

## Why this page exists

Several Module 2 commands looked correct but failed because they passed through multiple interpreters.

The important model is:

```text
PowerShell
  ↓
ssh.exe
  ↓
remote Bash
  ↓
PHP / SQL / another command
```

Each layer has its own quoting rules.

The visible error may come from a later layer even though the original mistake happened earlier.

---

## Incident 1 — PHP test command

### Goal

Create:

```php
<?php echo 'PHP is working'; ?>
```

on the remote VM.

### Symptom

PowerShell reported:

```text
Unexpected token 'PHP' in expression or statement.
```

### Interpretation

The command never reached Linux.

PowerShell parsed the nested quotes first and rejected the local command.

### Lesson

When the error says:

```text
ParserError
```

and identifies a PowerShell line number, troubleshoot PowerShell before Apache, PHP or SSH.

---

## Incident 2 — SQL table creation

### Symptom

Remote Bash returned:

```text
syntax error near unexpected token '('
```

### What Bash actually received

The quote boundaries around the SQL had disappeared.

Bash saw SQL punctuation such as:

```text
(
)
;
```

as shell syntax rather than text intended for MariaDB.

### Lesson

The SQL itself was valid.

The transport method was fragile.

---

## Incident 3 — INSERT statement

### Intended SQL

```sql
INSERT INTO assets (asset_name, asset_type, status)
VALUES ('Laptop-001','Laptop','Active');
```

### What the remote shell effectively received

Something closer to:

```text
INSERT INTO assets (asset_name, asset_type, status)
VALUES (Laptop-001,Laptop,Active)
```

The SQL string quotes were gone.

### Better solution

Stop embedding the SQL inside a shell argument.

Send it via stdin:

```powershell
$sql = @"
INSERT INTO assets (asset_name, asset_type, status)
VALUES ('Laptop-001','Laptop','Active');
"@

$sql | & $SSH `
  -i "$HOME\.ssh\it-governance-lab" `
  "azureuser@$VMIP" `
  "sudo mariadb assetlab"
```

---

## ELI5 — arguments vs stdin

### Argument

This:

```text
program "some text"
```

puts the text on the command line.

The shell must interpret all the quotation marks correctly first.

### Standard input

This:

```text
some text | program
```

sends the text to the program after the command has started.

That often avoids multiple layers of quote escaping.

---

## Preferred pattern for structured content

Use a PowerShell here-string:

```powershell
$content = @"
line one
line two
line three
"@
```

Then pipe it:

```powershell
$content | & $SSH `
  -i "$HOME\.ssh\it-governance-lab" `
  "azureuser@$VMIP" `
  "remote-command"
```

Useful for:

- SQL
- PHP files
- JSON
- configuration
- shell scripts
- multiline text

---

## How to identify which layer failed

### PowerShell failure

Typical clues:

```text
ParserError
Unexpected token
At line:...
```

The command probably never reached SSH.

### SSH/client failure

Typical clues:

```text
Connection timed out
Permission denied
Could not resolve hostname
```

The command may not have reached the remote shell.

### Bash failure

Typical clues:

```text
bash: -c:
syntax error near unexpected token
command not found
```

SSH worked. Bash received something, but not what was intended.

### MariaDB failure

Typical clues:

```text
ERROR 1064
ERROR 1045
ERROR 1146
```

The SQL reached MariaDB.

### PHP/application failure

Typical clues:

- HTTP 500
- PHP error log
- application error message

At this point the HTTP and PHP layers are involved.

---

## Transferable lesson

Do not only ask:

> What does the error say?

Also ask:

> Which program produced the error?

That identifies the layer that actually saw the malformed input.
