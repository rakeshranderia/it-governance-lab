# Python Imports, Saved Files and Editor State

## Symptom

```text
ImportError: cannot import name 'is_high_value' from 'asset_utils'
```

Python had found `asset_utils.py`, so this was not a `ModuleNotFoundError`.

## Check the saved file

```powershell
Get-Content python\asset_utils.py
```

The command returned nothing.

## Root cause

VS Code showed the code in the editor, but the file had not been saved.

```text
VS Code buffer
≠
file saved on disk
```

## Fix

Save the file:

```text
Ctrl + S
```

Then verify:

```powershell
Get-Content python\asset_utils.py
```

and rerun:

```powershell
python python\use_asset_utils.py
```

## Transferable lesson

When code appears to be missing:

```text
1. Read the exact error.
2. Confirm the path Python is using.
3. Inspect the saved file from the shell.
4. Do not assume the editor buffer equals disk.
5. Save and rerun.
```

## Error distinction

```text
ModuleNotFoundError
→ Python cannot find the module

ImportError: cannot import name ...
→ Python found the module
→ requested symbol is unavailable
```
