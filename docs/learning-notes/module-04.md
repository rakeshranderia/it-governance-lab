# Module 4 — Learning Notes

## What I built

I progressed from basic Python syntax to a small structured asset-processing program.

```text
variables
→ types
→ conditions
→ lists
→ dictionaries
→ loops
→ functions
→ exceptions
→ JSON
→ REST APIs
→ modules/imports
→ main()
→ JSON-backed asset report
```

## Key understanding

A list of dictionaries is the same broad shape seen in many API JSON responses.

Functions made intent clearer:

```python
if is_high_value(asset):
```

instead of repeating:

```python
asset["purchase_price"] > 1500
```

JSON mapped cleanly to Python:

```text
JSON object ↔ Python dictionary
JSON array  ↔ Python list
```

A real API call made the path concrete:

```text
Python
→ HTTP request
→ server
→ HTTP 200
→ JSON
→ Python data
```

Reusable logic moved into `asset_utils.py`, while scripts imported and used those functions.

## Cross-platform lesson

The source moved cleanly between Mac and PC.

The virtual environment did not move; each machine recreated it from `requirements.txt`.

## Troubleshooting worth keeping

The most useful issue was an unsaved VS Code file.

Python found the module but could not import the function because the editor buffer had not been saved to disk.

The sequence was:

```text
read exact error
→ confirm module path
→ inspect saved file from shell
→ compare with editor
→ save
→ rerun
→ success
```

## Outcome

FastAPI should now feel like Python plus HTTP/API structure rather than an unfamiliar framework.
