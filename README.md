# Dotfiles

Personal dotfiles managed with a [bare git repo](https://www.atlassian.com/git/tutorials/dotfiles) method.

## Setup (Fresh Mac)

```bash
# One-liner: clone, checkout, install everything
curl -sL https://raw.githubusercontent.com/Zaseem-BIsquared/dotfiles/master/setup.sh | bash
```

Or step by step: see `setup.sh` for what it does.

## What's Included

### Claude Code

- `.claude/CLAUDE.md` — global AI assistant instructions
- `.claude/settings.json` — permissions, hooks, and config
- `.claude/statusline.sh` — custom context usage statusline
- `.claude/skills/` — custom skills:
  - `bugfix-pr-workflow` — structured bug investigation → PR workflow
  - `debug-issue` — root cause investigation before fixes
  - `receive-review` — handle code review feedback critically
  - `request-review` — dispatch code reviewer agent
  - `setup-pwa` — PWA setup for Vite + React projects

### Not Tracked (installed separately)

- `feather-flow` — `npm install -g feather-flow` (TDD workflow)
- `get-shit-done-cc` — `npm install -g get-shit-done-cc` (project management)
- `plugins/` — Claude Code plugin marketplace
- Convex testing skills — installed via `feather-testing-convex`

## How It Works

Uses a **bare repo** in `~/.cfg` with `$HOME` as the work tree. The `.cfg-ignore` file uses an allowlist approach — everything is ignored by default (`*`), and tracked files are explicitly un-ignored with `!` entries.

```bash
# Quick alias (add to .zshrc)
alias dotfiles='git --git-dir=$HOME/.cfg --work-tree=$HOME'

# Usage
dotfiles status
dotfiles add ~/.claude/settings.json
dotfiles commit -m "update claude settings"
dotfiles push
```
