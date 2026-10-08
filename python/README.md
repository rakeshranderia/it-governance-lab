# Python — Module 4

## Files

- `basics.py` — variables, types, conditions, lists, dictionaries, loops, functions and exceptions.
- `json_demo.py` — Python ↔ JSON conversion.
- `api_demo.py` — REST API calls, status codes and list responses.
- `requirements.txt` — project dependencies.
- `asset_utils.py` — reusable asset helper functions.
- `use_asset_utils.py` — modules/imports and `main()`.
- `assets.json` — sample data outside the code.
- `asset_report.py` — loads JSON and produces a report.

## Virtual environment

### Windows

```powershell
python -m venv python\.venv
python\.venv\Scripts\Activate.ps1
pip install -r python\requirements.txt
```

### macOS / Linux

```bash
python3 -m venv python/.venv
source python/.venv/bin/activate
pip install -r python/requirements.txt
```

The `.venv` directory is local and should not be committed.
