# Appendix 1 — Moving from VS Code to Git CLI

The goal is not to abandon VS Code. The goal is to understand what VS Code is doing for you so Git stops feeling like a hidden layer.

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

## Safe first commands

```bash
git status
git log --oneline --decorate -10
git remote -v
git branch
```

## Normal CLI workflow

```bash
git status
git diff
git add <file>
git diff --staged
git commit -m "Meaningful commit message"
git push
```

## Suggested progression

1. Observe: `status`, `diff`, `log`, `branch`, `remote -v`
2. Stage/commit: `add`, `diff --staged`, `commit`
3. Full local workflow: `pull`, `add`, `commit`, `push`
4. Branches: `switch -c`, `switch`, `merge`
5. Troubleshooting: `restore`, `revert`, `fetch`

## Practical exercise

Make a harmless documentation change and do the whole process from the terminal.

**Commit checkpoint:** `Complete first Git CLI commit exercise`
