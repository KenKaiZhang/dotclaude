---
name: commit
description: Create a git commit whose message future Claude sessions can use as context. TRIGGER on `/commit`, "commit this", "make a commit", or any explicit request to commit staged/working-tree changes. SKIP for non-git work or when the user is only asking *what* to commit, not to do it.
user-invocable: true
allowed-tools: Bash Read Grep
argument-hint: [optional scope or note]
---

# Commit

You are creating a git commit. Beyond the immediate change, the commit message is a **handoff to future Claude sessions** — `git log` is the cheapest way for the next session to reconstruct what's been happening on this project. Write accordingly.

## Why this skill exists

A vague message like `fix bug` forces the next session to diff every file to figure out what changed and why. A specific subject + a short body that names the *why* gives the next session the gist in one read. Treat each commit as a paragraph in the project's running narrative.

## Workflow

1. **Survey state in parallel** (single message, three Bash calls):
   - `git status` (no `-uall`)
   - `git diff` — staged + unstaged
   - `git log -n 10 --oneline` to match existing style

2. **Group changes into logical commits.** One logical change per commit. If the working tree has unrelated changes, ask the user how to split rather than bundling.

3. **Draft the message** following the rules below. If multiple commits are needed, draft all of them up front so the user sees the whole sequence.

4. **Stage and commit** in parallel where possible:
   - `git add <specific files>` — never `git add -A` or `git add .` (risks committing secrets or unrelated noise).
   - `git commit -m "$(cat <<'EOF' ... EOF)"` via heredoc for clean formatting.
   - Then `git status` to confirm.

5. **On hook failure**: fix the underlying issue, re-stage, create a NEW commit. Never `--amend` after a failed hook (the previous commit is what gets modified, which can destroy work).

## Message rules

**Format**: conventional commits — `type(scope): description`. Types: `feat`, `fix`, `chore`, `refactor`, `docs`, `test`, `style`, `perf`, `ci`, `build`.

**Subject line** (under ~70 chars):
- Name the concrete change, not the area touched.
  - Good: `feat(entities): drag-to-reorder fields, FK auto-link, packed auto-layout`
  - Bad:  `feat(entities): update entities tab`
- If the repo has an established subject style (check `git log`), match it.

**Body** (when the change warrants — skip for true one-liners):
- Explain **why**, not what. The diff already shows what.
- Surface non-obvious context a future session can't recover from the code: the constraint that drove the choice, the alternative considered and rejected, the bug this prevents, the issue/ticket it relates to.
- If the commit is part of a larger arc (preparing for X, builds on Y, reverts Z), say so — that's exactly the kind of cross-commit signal `git log` is meant to surface.
- Keep it tight. 1–4 short lines beats a wall of text.

**What NOT to include**:
- A restatement of the diff.
- Generic filler ("improves code quality", "various fixes", "updates").
- Internal session bookkeeping ("as discussed", "per request").
- Co-author trailers, marketing footers, or signatures **unless the user asked for them**.

## Examples

**Trivial — no body needed:**
```
fix(auth): typo in error message
```

**Non-obvious decision — body explains why:**
```
refactor(api): drop retry wrapper around ingest endpoint

The wrapper was masking 4xx errors as transient and causing
duplicate writes when upstream returned 409. Caller already
retries idempotent paths; this layer was net-negative.
```

**Part of a larger arc — body links commits:**
```
feat(entities): packed auto-layout for FK graph

Prep for the drag-to-reorder change in the next commit — the
new layout needs stable slot indices, which the old radial
layout didn't provide.
```

## Safety

- Never `git add -A` / `git add .` — name files explicitly.
- Never `--amend` unless the user asks (modifies a published or hook-failed commit).
- Never `--no-verify` / `--no-gpg-sign` unless the user asks.
- Never push as part of `/commit` — committing and pushing are separate decisions.
- If a file looks sensitive (`.env`, credentials, keys, large binaries), stop and confirm before staging.
- Only commit when explicitly asked. `/commit` counts as explicit; ambient "looks good" does not.
