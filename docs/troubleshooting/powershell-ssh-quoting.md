# PowerShell, SSH, Bash and Quoting

Commands may pass through:

```text
PowerShell
→ ssh.exe
→ remote Bash
→ PHP / SQL
```

Each layer has its own quoting rules.

## Better pattern for structured content

```powershell
$sql = @"
SELECT * FROM assets;
"@

$sql | & $SSH `
  -i "$HOME\.ssh\it-governance-lab" `
  "azureuser@$VMIP" `
  "sudo mariadb assetlab"
```

## Which layer failed?

```text
ParserError → PowerShell
Permission denied / timeout → SSH
bash syntax error → Bash
ERROR 10xx → MariaDB
HTTP 500 → PHP/application/dependency
```

Always ask:

> Which program produced the error?
