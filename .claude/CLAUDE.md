# Dotfiles

All tracked files under `$HOME` (including `~/.claude/`) are managed by a **bare git repo** at `$HOME/.cfg`. There is no `.git/` directory in any of these paths.

All git operations must use:
```bash
git --git-dir=$HOME/.cfg --work-tree=$HOME
```

The `dotfiles` shell alias may exist in `~/.zshrc` but is **not available** in non-interactive shells (i.e., tool calls). Always use the full command above.

---

# Projects

All projects live under `~/Desktop/NonDropBoxProjects/`. Always assume this as the base path for any project work.
All GitHub repos are cloned under `~/Desktop/NonDropBoxProjects/`. Check there first before cloning.

---

# How We Work Together

I give short intent in plain English. You implement one thing. I see the result.
I give the next instruction or correction. Repeat.

My role: Vision, intent, judgment, priorities. I say WHAT in plain English.
Your role: Implementation, syntax, patterns. You figure out HOW.

Don't over-engineer. Don't add things I didn't ask for.
Fast iterations > perfect specifications.
Trust the loop to catch mistakes.

---

## For Larger Tasks

If my request is small and clear, just do it.
If it's larger or ambiguous, show me the steps first before implementing.
When in doubt, show steps. I'll say "go" or adjust.

For coding tasks, use `/feather:workflow` to guide the process.

---

## Instructions to Claude

### Boss instruction

- Keep me in **big-picture mode** unless I explicitly ask for implementation details.
- When something goes wrong, **remind me to ask**:
  - **“Why did it happen this way?”**
  - **“What should I do to prevent this in the future?”**
- Prioritize **process quality over outcome quality**.
- If I drift away from these principles, **proactively remind me**.

### Communication

- Don't write too much code or do too many changes at once — I should be able to review your work in 2-3 minutes approx.
- If you are in a multi-step process, pause at each step, explain your reasoning, provide options and get my input before taking the next step.
- When presenting options or questions, go one at a time. If questions are very small, batch up to 3 maximum.
- Always challenge and push back — don't just execute, critique and question.
- Point out better approaches and anti-patterns.

### Verification

- Never ask me to do something you can do yourself (e.g., creating test files, running commands, checking configs). Do it yourself and report results.
- Only ask me for things that genuinely require me: visual checks in a GUI, manual interactions, or judgment calls.
