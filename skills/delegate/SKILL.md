---
name: delegate
description: Apply delegation judgment when deciding to spawn subagents vs. work directly. TRIGGER when facing multi-step research, broad codebase exploration (>3 queries expected), parallelizable independent work, or when main-context bloat is a risk. SKIP for one-shot lookups where the target is already known (use Read/grep directly).
user-invokable: true
---

You have subagents. Used well, they let you tackle bigger tasks and protect the main context. Used poorly, they add latency, duplicate work, and produce shallow answers. This skill teaches the judgment: when to delegate, how to brief, how to parallelize, and how to verify.

## When to Spawn vs. Work Directly

Default to working directly. The bar to delegate is "would I save tokens or time, and is the task self-contained enough to brief?"

**Work directly when:**
- The target is known: a specific file path, a known symbol, a one-line config change.
- The task is one or two tool calls: a single `Read`, a single `grep`, a single edit.
- The work depends on conversation context the agent can't easily inherit.
- You'd spend more time briefing the agent than doing it yourself.

**Delegate to `Explore` when:**
- Open-ended search: "where is X defined", "which files reference Y", "find all callers of Z".
- You expect more than ~3 search queries to find the answer.
- You want to scan a directory tree without burning main-context tokens.
- Read-only — Explore can't edit, so don't ask it to.

**Delegate to `Plan` when:**
- You need an implementation strategy designed.
- The architectural tradeoff deserves a second opinion.
- The user asked "how would you approach X" and the answer needs structure.

**Delegate to `general-purpose` when:**
- The task spans research + analysis + multiple categories.
- You're unsure which specialized agent fits.
- Multi-step execution is required and the agent needs broad tool access.

**Domain-specific agents** (e.g. `claude-code-guide`) — use when the agent description matches the question shape, not just the topic.

## How to Write Good Agent Prompts

The agent has not seen this conversation. It does not know what you've tried, what you've ruled out, or why the task matters. Brief it like a colleague who just walked into the room.

A good prompt has:

1. **Goal in one sentence.** What you're trying to learn or produce.
2. **Context.** What you already know, what you've ruled out, what's surrounding this task.
3. **Specifics.** File paths, symbol names, line numbers, exact commands — anything concrete.
4. **Scope guardrails.** What's in scope, what isn't. "Don't read past the auth module."
5. **Output shape.** "Report under 200 words", "list of file paths only", "one-paragraph recommendation + risks".

Two prompt shapes to keep separate:

- **Lookups** — hand over the *exact command or path*. The agent shouldn't be re-deciding what to grep for.
- **Investigations** — hand over the *question*. Prescribed steps become dead weight when the premise is wrong; let the agent's judgment do the work.

**Bad prompt:** "find the auth code"
**Better prompt:** "Find where session tokens are issued in this repo. I've checked `src/auth/` and `src/middleware/`. Look beyond those — likely candidates are `lib/`, `server/`, or framework integrations. Report file:line of the issuing call and the storage mechanism (cookie, header, JWT). Under 100 words."

**Never delegate the synthesis.** Don't write "based on your findings, fix the bug" or "based on the research, implement it." Synthesis is your job; the agent gathers facts.

## Parallelization Patterns

**Fan out when work is independent.** Send multiple agents in a *single tool-call message* — that's what makes them run concurrently. Sequential messages run sequentially even if the calls don't depend on each other.

**Sequential when there's a data dependency.** Don't fan out a "design" agent and an "implement" agent in parallel — implementation needs the design's output.

**Quality > quantity.** Three focused agents beat seven shallow ones. Hard cap: 3 concurrent for most tasks.

**Don't duplicate work.** If you delegated research to an agent, don't also run the same searches yourself in the meantime. Wait, then build on the result.

**Don't fan out for the sake of fanning out.** If the question is "where is X", that's one agent, not three.

## Trust But Verify

Agent summaries describe **intent**, not necessarily what happened. Treat their reports as claims to be checked, not facts to be assumed.

**When an agent reports findings:**
- Spot-check at least one cited file:line. If the file doesn't exist or the symbol isn't there, the rest of the report is suspect.
- Watch for hallucinated file paths, function names, and line numbers — especially in deep dives where the agent's own context started to fill up.

**When an agent claims to have written or edited code:**
- Read the actual diff before reporting "done" to the user. Always.
- Check that the change was scoped — agents drift into adjacent edits the user didn't ask for.
- Run the relevant tests yourself. "Tests pass" from an agent is a claim, not a guarantee.

**When an agent reports a build/test result:**
- Re-run the command if the result is load-bearing for your next step.

## Anti-Patterns

- **Delegating because you're unsure** — clarify the question first; spawn after.
- **Spawning a research agent and then re-doing the research yourself.**
- **Using subagents to bypass thinking** — the cognitive work is yours; the agent is a tool.
- **Forwarding the user's vague prompt verbatim.** If you need to think to interpret it, the agent does too — interpret first, then brief.
- **Never reading the agent's actual output, just summarizing it to the user.** You own the report.
- **Stacking offers to delegate** — propose subagent use when it actually helps, not by reflex.

## Quick Decision Table

| Situation | Action |
|---|---|
| Known file, single edit | Direct |
| "Where is X" — 1-2 queries | Direct (`grep`, `Read`) |
| "Where is X" — broad search | `Explore` |
| Multi-area exploration | Up to 3 `Explore`, parallel |
| Implementation strategy | `Plan` |
| Independent research + design | Multiple agents, parallel, single message |
| Multi-step with editing | `general-purpose` |
| You're not sure | Default to direct; spawn only when the cost case is clear |
