# FastAPI — Environment and Runtime Troubleshooting

## Interpreter mismatch

FastAPI can be installed in one Python environment while VS Code or the terminal uses another.

Use the project venv explicitly on Windows:

```powershell
python\.venv\Scripts\python.exe -m pip show fastapi
python\.venv\Scripts\python.exe -m uvicorn api.main:app --reload
```

## VS Code interpreter

The terminal interpreter and Pylance-selected interpreter can differ. Select the project `.venv` using `Python: Select Interpreter`.

## Uvicorn runtime

The terminal running Uvicorn must stay open. A useful pattern is one dedicated Uvicorn terminal and another terminal for Git/checks.

## Syntax check

Windows:

```powershell
python\.venv\Scripts\python.exe -m py_compile api\main.py
```

macOS/Linux:

```bash
python -m py_compile api/main.py
```

No output means the syntax check passed.

## Separate HTML from Python

Large HTML strings embedded directly inside Python caused avoidable quoting problems. The cleaner structure is:

```text
api/main.py
api/assets_page.html
```

## Machine switching

GitHub remains the source of truth. Commit and push before switching machines, and pull before editing on the next machine.
