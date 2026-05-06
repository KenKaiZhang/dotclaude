---
name: Senior skills (engineer / architect / delegate)
description: Three global auto-triggering skills enforce senior judgment for coding, planning, and subagent delegation. Live in ~/.claude/skills/.
type: reference
originSessionId: 684075aa-7447-43c7-9261-329413af5ab8
---
Three global skills auto-trigger based on context, replacing what used to live in `~/.claude/CLAUDE.md`:

- **`senior-engineer`** — `~/.claude/skills/senior-engineer/SKILL.md`
  Triggers when writing/editing/reviewing code. Covers production quality (typing, error handling at boundaries, async correctness), perf (N+1, bundle size), security (OWASP, input validation, secrets), surgical-change discipline, and verification habits.

- **`senior-architect`** — `~/.claude/skills/senior-architect/SKILL.md`
  Triggers in plan mode and when designing systems / choosing approaches / drawing boundaries. Covers single responsibility, composition, explicit assumptions, push-back posture, "what NOT to build" (no speculative features / premature abstraction), plan structure, and tradeoff surfacing.

- **`delegate`** — `~/.claude/skills/delegate/SKILL.md`
  Triggers when subagent use is on the table. Covers when to spawn vs. work directly (Explore / Plan / general-purpose decision table), prompt craft (lookups vs. investigations), parallelization (single-message fan-out, max ~3), and trust-but-verify (read agent diffs, spot-check citations).

All three are also user-invokable via `/senior-engineer`, `/senior-architect`, `/delegate`.

`~/.claude/CLAUDE.md` is now slim — it indexes these skills and retains only universal rules: plan-first, verification, conventional commits.
