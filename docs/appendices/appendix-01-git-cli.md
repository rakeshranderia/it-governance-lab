# Appendix 1 — Moving from VS Code to Git CLI

## Git vs GitHub — ELI5

**Git** is the version-control system running on your computer.

**GitHub** stores a remote copy of your repository and adds collaboration features.

```text
Working files
    ↓
Staging area
    ↓
Local Git commit
    ↓
GitHub remote repository
```

## VS Code → Git CLI

| VS Code / GitHub action | Git CLI |
|---|---|
| View changed files | `git status` |
| View exact changes | `git diff` |
| Stage one file | `git add <file>` |
| Stage everything | `git add .` |
| Unstage a file | `git restore --staged <file>` |
| Commit | `git commit -m "message"` |
| Push | `git push` |
| Pull | `git pull` |
| History | `git log --oneline` |
| Create branch | `git switch -c <branch>` |
| Change branch | `git switch <branch>` |
| Remote info | `git remote -v` |

## Normal CLI workflow

```bash
git status
git diff
git add <file>
git diff --staged
git commit -m "Meaningful commit message"
git push
```
