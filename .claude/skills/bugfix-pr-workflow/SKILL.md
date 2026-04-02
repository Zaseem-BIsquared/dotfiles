---
name: bugfix-pr-workflow
description: Use when the user reports a bug or issue. Follows a structured workflow — investigate root cause, propose fix with alternatives, get approval, implement on a separate branch, show PR for review, then create PR to upstream/origin via gh cli.
---

# Bugfix PR Workflow

## Overview

End-to-end workflow for taking a user-reported bug from investigation to a merged PR. The user only needs to describe the issue — this skill handles the rest in a structured, reviewable flow.

**Core principle:** Never fix blindly. Investigate → propose with alternatives → get approval → implement → user verifies fix → PR review → push.

## When to Use

Use when the user reports a bug, UI issue, unexpected behavior, or any defect that needs to be fixed and submitted as a PR.

**Examples:**
- "This button isn't clickable"
- "The layout is broken on mobile"
- "The form doesn't submit"
- "I see a console error when I navigate to X"

## The Eight Phases

You **MUST** complete each phase in order. Do not skip phases. Use the `TodoWrite` tool to track progress through all eight phases from the start.

---

### Phase 1: Investigate Root Cause

**Goal:** Understand WHAT is broken and WHY, with evidence.

1. **Locate the relevant code**
   - Use subagents for broad codebase exploration if the issue could span many files
   - Search for the UI element, component, or feature the user described
   - Trace the issue through the component tree, styles, and logic

2. **Identify the root cause**
   - Don't stop at symptoms — find the underlying reason
   - Check CSS stacking, event handling, state management, data flow
   - Read the actual file content to confirm findings
   - Document the exact files, line numbers, and code causing the issue

3. **Build an evidence chain**
   - Explain the stacking order, data flow, or logic path that leads to the bug
   - Use tables or diagrams where helpful
   - Make it clear enough that someone unfamiliar could understand

---

### Phase 2: Propose Fix with Alternatives

**Goal:** Present the fix plan as markdown in the chat, then **explicitly wait** for user approval using `AskUserQuestion`. MUST include multiple approaches.

**IMPORTANT:** Do NOT use `ProposePlanToUser` — it can be auto-approved by permissive settings and bypass user review. Instead, present the proposal as markdown in your chat message, then call `AskUserQuestion` to gate on user approval. This ensures the user always reviews the plan regardless of permission level.

The proposal **MUST** contain:

1. **Root Cause Summary** — Clear explanation of what's wrong and why
2. **Multiple fix options** (at minimum 2-3 alternatives), each with:
   - What the fix does
   - Code diff / preview
   - Pros and cons
3. **Recommended option** — Clearly state which option you recommend and why
4. **Why other options were not chosen** — Justify the tradeoff

After presenting the proposal as markdown, call:
```
AskUserQuestion: "Does this fix plan look good? Pick an option or suggest changes."
  options: ["Option A (recommended)", "Option B", "Option C", "Suggest changes"]
```

**If rejected or changes requested:** Revise the proposal based on user feedback and re-propose.

---

### Phase 3: Implement on a Separate Branch

**Goal:** Apply the approved fix on a clean, descriptively named branch (but do NOT commit yet).

1. **Create a new branch from the correct base:**
   - First, determine the base: fetch and use `upstream/main` if upstream exists, otherwise `origin/main`
   - Create the branch from that base so the PR only contains fix-related commits:
   ```bash
   git fetch upstream  # or origin if no upstream
   git checkout -b fix/<descriptive-name> upstream/main
   ```
   - **IMPORTANT:** Do NOT branch from the current branch — it may contain unrelated commits that will pollute the PR.
   - Branch name should describe the issue (e.g., `fix/hero-button-unclickable`, `fix/form-submit-error`)

2. **Apply the fix** — Make only the changes discussed in the approved proposal. No extra refactoring.

3. **Verify the code** — Read back the changed files to confirm correctness.

**Do NOT commit yet** — the user must verify the fix works first (Phase 4).

---

### Phase 4: User Verification

**Goal:** Wait for the user to test the fix and confirm it works before committing.

**This phase is critical.** The fix might not work as expected — the user must verify it in their environment before we commit anything.

1. **Tell the user the fix is applied** and ask them to test it.
2. **Use `AskUserQuestion`** to explicitly wait:
   ```
   AskUserQuestion: "The fix has been applied. Please test it and let me know if the issue is resolved."
     options: ["Fix works — proceed", "Fix doesn't work", "Partially fixed — needs more changes"]
   ```
3. **If the fix doesn't work or needs changes:**
   - Investigate further based on user feedback
   - Update the code
   - Ask the user to verify again
   - Do NOT proceed until the user confirms the fix works

**Do NOT skip this step.** Never assume the fix works — always wait for user confirmation.

---

### Phase 5: Commit

**Goal:** Commit the verified fix.

1. **Commit with a concise message:**
   - First line: `fix: <short description>`
   - Body: Briefly explain **what** the bug was (the problem/symptom), NOT how the fix works. Keep it to 2-3 lines max.
   - Follow conventional commits format
   - Example:
     ```
     fix: use routeId instead of match id in Header's useRouteContext

     Header passed match.id to useRouteContext({ from }), but TanStack Router
     expects a routeId. The mismatch produced a double-slash path that doesn't
     match any route, crashing the /dashboard page.
     ```

---

### Phase 6: Show PR to User for Review

**Goal:** Present the full PR description in **readable markdown** format BEFORE creating it on GitHub.

The PR description **MUST** contain:

1. **🐛 Bug Description** — What the user experienced
2. **🔍 Root Cause** — Technical explanation with code snippets showing the problematic code
3. **✅ Fix Applied** — What was changed, with code snippets showing the fix
4. **🤔 Alternative Approaches Considered** — Each alternative with why it was rejected (use ❌ bullet points)
5. **🏆 Why This Fix Was Chosen** — Bullet points explaining the tradeoff decision
6. **📁 Files Changed** — List of changed files with brief descriptions

**Display this as markdown in the chat** and ask the user for approval.

**If the user requests changes:** Revise and show again.

---

### Phase 7: Push Branch

**Goal:** Push the fix branch to the remote.

```bash
git push origin fix/<branch-name>
```

---

### Phase 8: Create PR via gh CLI

**Goal:** Create the PR on the appropriate remote (upstream if available, otherwise origin).

1. **Check remotes:**
   ```bash
   git remote -v
   ```

2. **Determine target:**
   - If `upstream` exists → create PR to upstream with cross-fork head reference (`OWNER:branch`)
   - If only `origin` exists → create PR to origin

3. **Create PR using `gh` cli:**
   - Use `--body-file -` with heredoc (`<<'EOF'`) to avoid shell escaping issues
   - Target the `main` branch (or appropriate default branch)
   - Use the PR description from Phase 4

4. **Share the PR link** with the user.

---

## Todo Tracking

At the **start** of the workflow, create all eight todos:

```
1. Investigating the root cause
2. Proposing a fix with alternatives
3. Implementing the fix on a separate branch
4. Waiting for user to verify the fix
5. Committing the verified fix
6. Showing PR to user for review
7. Pushing the branch
8. Creating PR via gh cli
```

Update status as you progress through each phase.

---

## Shell Escaping Notes

When creating PRs with `gh pr create`, use heredoc for the body to avoid escaping issues:

```bash
gh pr create \
  --repo OWNER/REPO \
  --base main \
  --head OWNER:branch-name \
  --title "fix: description" \
  --body-file - <<'EOF'
PR body content here...
No escaping needed with single-quoted heredoc delimiter.
EOF
```

---

## Red Flags — STOP

- **Don't skip investigation** — No fixing without understanding root cause
- **Don't skip alternatives** — Always present at least 2-3 options with tradeoffs
- **Don't skip user approval** — Use `AskUserQuestion` (NOT `ProposePlanToUser`) and wait
- **Don't skip user verification** — Never commit until the user confirms the fix works
- **Don't skip PR preview** — Always show the PR markdown to the user before creating it
- **Don't bundle unrelated changes** — Fix only what was discussed
- **Don't guess the remote** — Check `git remote -v` to determine upstream vs origin
- **Don't branch from the current branch** — Always branch from `upstream/main` (or `origin/main`) to avoid unrelated commits polluting the PR

## Quick Reference

| Phase | Key Action | Gate |
|-------|-----------|------|
| **1. Investigate** | Find root cause with evidence | Must have evidence chain |
| **2. Propose** | Multiple options as markdown + `AskUserQuestion` | User approval required |
| **3. Implement** | New branch, apply fix (no commit) | Code changes applied |
| **4. Verify** | User tests the fix | User confirms fix works |
| **5. Commit** | Commit with concise message | Clean commit only |
| **6. Show PR** | Display PR markdown in chat | User approval required |
| **7. Push** | Push branch to remote | Branch pushed |
| **8. Create PR** | `gh pr create` to upstream/origin | PR link shared |
