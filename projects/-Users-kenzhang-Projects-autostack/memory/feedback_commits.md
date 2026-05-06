---
name: Commits should help Claude catch up
description: Commit messages on this project are written so future Claude sessions can reconstruct context — be specific about what changed and why.
type: feedback
originSessionId: e6fa2227-4b6a-4fc3-a3ea-3c35fb2ed0ad
---
Commits in this repo are read by future Claude sessions (via `git log`) to understand recent work. Write commit messages that maximize that signal.

**Why:** Ken treats commit messages as a primary handoff mechanism between sessions, alongside STATUS.md. A vague message like "fix entities tab" forces the next Claude to diff every file to figure out what happened; a descriptive subject + body gives them the gist immediately.

**How to apply:**
- Subject line: name the concrete changes, not the area touched (e.g. "Entities tab: drag-to-reorder fields, FK auto-link, packed auto-layout" beats "update entities tab").
- Body (when changes warrant it): briefly list the *why* behind non-obvious decisions. Skip body for trivial commits.
- Match the existing style: recent commits use `Area: thing1, thing2, thing3` format (see 77c9683, e48b773).
- One logical change per commit — don't bundle unrelated working-tree changes in just because they're sitting there.
