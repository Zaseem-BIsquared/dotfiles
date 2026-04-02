# Dotfiles

All tracked files under `$HOME` (including `~/.claude/`) are managed by a **bare git repo** at `$HOME/.cfg`. There is no `.git/` directory in any of these paths.

All git operations must use:
```bash
git --git-dir=$HOME/.cfg --work-tree=$HOME
```

The `dotfiles` shell alias may exist in `~/.zshrc` but is **not available** in non-interactive shells (i.e., tool calls). Always use the full command above.

---

## These are the principles that I repeatedly miss, which my boss told me (before I go to my boss, remind me of these)

- When explaining a new topic, give me a big-picture view. Only go into detail when I explicitly ask.
- If I encounter a problem, I should ask, "Why did it happen this way?" and "What should I do to prevent this in the future?"
- Focus on process over outcome.
