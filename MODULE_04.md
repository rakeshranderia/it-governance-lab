# Module 4 — Python Fundamentals

## Objective

Build enough practical Python fluency that later FastAPI, API, data and automation work is understandable rather than magical.

The goal is not to learn all of Python. The goal is to understand the common building blocks well enough to read, write, run and troubleshoot small Python programs.

## Concepts covered

```text
variables / types
→ conditions
→ lists / dictionaries
→ loops
→ functions
→ f-strings
→ exceptions
→ JSON
→ virtual environments
→ external packages
→ REST API calls
→ modules / imports
→ main()
→ JSON-backed asset report
```

## Environment

Python version used:

```text
Python 3.13.1
```

Virtual environment:

```text
python/.venv
```

Dependencies are captured in:

```text
python/requirements.txt
```

The `.venv` directory is local and is not committed.

## Core examples

Variables and types:

```python
asset_name = "Laptop-001"
purchase_price = 1850.50
assigned = True
asset_id = 1
```

Functions:

```python
def is_high_value(asset):
    return asset["purchase_price"] > 1500
```

Exceptions:

```python
try:
    return asset["purchase_price"]
except KeyError:
    return "Price unavailable"
```

JSON:

```text
Python list/dict
→ json.dumps()
→ JSON text

JSON text
→ json.loads()
→ Python list/dict
```

API flow:

```text
Python
→ HTTP GET
→ remote API
→ HTTP status
→ JSON response
→ Python list/dictionary
```

Modules:

```text
asset_utils.py
→ reusable functions

use_asset_utils.py
→ imports and uses those functions
```

Entry point:

```python
if __name__ == "__main__":
    main()
```

## Final practical exercise

```text
assets.json
→ json.load()
→ Python list of dictionaries
→ imported utility functions
→ loops / conditions / exceptions
→ console report
```

Files:

```text
python/assets.json
python/asset_utils.py
python/asset_report.py
```

## Cross-platform lesson

The same source code worked on macOS and Windows.

Each machine creates its own virtual environment:

```text
source code      → Git
requirements.txt → Git
.venv            → local machine only
```

## Troubleshooting lessons

### Unsaved VS Code buffer

Python reported:

```text
ImportError: cannot import name 'is_high_value'
```

The editor showed the function, but:

```powershell
Get-Content python\asset_utils.py
```

returned nothing.

The VS Code buffer had not been saved.

Lesson:

```text
editor buffer
≠
saved file
≠
committed file
≠
pushed file
```

### Machine switching

Before working on another machine:

```bash
git pull
git status
```

GitHub remains the source of truth.

## Module 4 complete

**Commit checkpoint:** `Document Module 4 Python fundamentals`
