---
name: research
description: Conduct thorough, well-cited web research using parallel subagents. TRIGGER on `/research <topic>` or natural phrases like "research X", "look into Y", "find current info on Z", or any question requiring post-training-cutoff information. SKIP for trivially-known facts (HTTP status codes, language syntax, well-established concepts) or questions answerable from a single known source.
user-invokable: true
args:
  - name: topic
    description: The subject or question to research
    required: false
---

You have web tools and subagents. Used together, they let you produce research that is broader, deeper, and better-cited than a single search pass. Used poorly, they produce a credulous summary of the first three blog posts that came up. This skill teaches the difference: when to research, how to decompose, how to fan out, how to synthesize, and how to verify.

## When to Research vs. Skip

Default to answering directly. The bar to invoke this skill is "current/uncertain information that benefits from multiple sources."

**Research when:**
- The question depends on information that may be newer than your training cutoff (recent releases, current state of a tool, ongoing events).
- The topic is contested, evolving, or has multiple legitimate perspectives worth comparing.
- The user explicitly asks ("research X", "look into Y", "what's the current state of Z").
- Citations matter — the user needs to be able to verify or follow up.

**Skip when:**
- The fact is stable and well-established in training (how OAuth works, what a B-tree is, Python's import system).
- The answer is a single specific lookup the user could do faster themselves.
- One known authoritative source covers it — fetch that source directly with `WebFetch`, no fan-out needed.
- The user is mid-task and just needs a quick answer to keep moving.

If you're unsure whether to invoke, ask the user before fanning out three agents.

## Workflow

1. **Scope the question.** Before spawning anything, identify:
   - The *shape* of the answer — factual lookup, comparison, exploratory survey, current-state report.
   - Time-sensitivity — does "current" matter, or is historical context fine?
   - Sub-angles — what 2–3 distinct facets cover this question without overlap?

2. **Decompose into 2–3 sub-questions.** Each sub-question covers one angle. If a question only has one real angle, don't force three — use one agent or just do the search yourself.

3. **Fan out parallel `general-purpose` subagents** in a *single tool-call message*. One agent per sub-question. Single-message dispatch is what makes them concurrent — sequential messages run sequentially even if the work is independent. Hard cap: 3 agents.

4. **Synthesize the reports yourself.** Read each agent's report. Combine into one cohesive inline answer that addresses the original question, not three stapled-together summaries. Note contradictions between sources rather than smoothing them over.

5. **Verify before presenting.** For each sub-question, spot-check at least one cited claim by re-fetching the source URL with `WebFetch`. If the source doesn't support the claim — or doesn't exist — drop the claim and note the gap. Agent reports are claims, not facts.

6. **Format the reply** with inline `[1]`, `[2]`… citations and a `## Sources` block at the end (`[n] Title — URL`).

Never delegate synthesis. The agent gathers; you write the answer.

## Briefing Subagents

The agent has not seen this conversation. It does not know the broader question, what the user already tried, or what counts as a "good" source here. Brief it like a colleague who just walked into the room.

A good per-angle prompt has:

1. **Goal** — one sentence stating the sub-question.
2. **Context** — the broader research question this sub-question is part of, so the agent can recognize relevant tangents.
3. **Source guidance** — what counts as a good source (official docs, primary reporting, peer-reviewed, recent posts), what to skip (SEO farms, outdated tutorials, AI-generated content mills).
4. **Citation requirement** — every claim must include a source URL. No uncited claims.
5. **Output shape** — bullet findings, ≤200 words, with sources inline.

**Example prompt** (sub-question: "What's the current state of WebGPU browser support?"):

> Research the current state of WebGPU browser support across Chrome, Firefox, and Safari as of today. This is part of a broader question about whether to adopt WebGPU for a new project, so flag any "stable in Chrome but flagged in others" gotchas.
>
> Prefer: official browser release notes, caniuse.com, MDN, WPT dashboard. Skip: AI-generated SEO posts, tutorials older than 12 months.
>
> Every claim needs a source URL. Output: bullet findings under 200 words with inline source links.

**Anti-patterns in agent prompts:**
- Forwarding the user's vague prompt verbatim. If you needed to interpret it, the agent does too.
- Asking the agent to "research and recommend." Recommendation is synthesis — that's your job.
- No source guidance, leading the agent to cite the first three Google results regardless of quality.

## Synthesis & Citation Format

- Inline citations: `Claim text [1].` Numbers are assigned in order of first appearance in your synthesized answer, not in the order agents reported them.
- One `[n]` per source, even if cited multiple times.
- End with a `## Sources` block:
  ```
  ## Sources
  [1] Title of page — https://example.com/path
  [2] Another title — https://example.com/other
  ```
- If sources contradict each other, say so explicitly: "Source [1] reports X, but [2] (more recent) reports Y."
- If verification turned up a problem, note it: "Originally cited claim about Z was not supported by the source on re-check; omitted."

## Source Strategies

The skill is designed to expand. Current strategies:

**General web** (default; always available):
- `WebSearch` for discovery — broad keyword queries to find candidate sources.
- `WebFetch` for retrieval — pull full content of a specific URL for verification or deep reading.
- Subagents run a search-then-fetch loop inside their own context, which keeps raw search dumps out of the main conversation.

*Future strategies (not yet wired up — add as new entries here when adopted):*
- *Library/framework docs* — `context7` MCP for authoritative, version-specific docs on named libraries.
- *Academic / preprint search* — would slot in as a new strategy when an MCP for arXiv / Semantic Scholar is added.
- *Project-local context* — repo grep / file reads when research touches the current codebase.
- *Canvas MCP* — schoolwork-specific source for SFSU coursework.

Adding a strategy means: append a bullet here, update the briefing template if relevant, and decide whether the new source should be tried first, in parallel, or as a fallback.

## Anti-Patterns

- **Researching stable knowledge.** If the answer was true in 2020 and is still true now, you don't need three agents — you need to just answer.
- **Fanning out for a single-angle question.** "What version of Python does Django 5.1 require?" is one query, not three agents.
- **Stapling agent reports together.** Three sub-summaries pasted in sequence is not synthesis. Rewrite into one answer that addresses the original question.
- **Skipping verification because the agents "all agreed."** Agent agreement is not source agreement — they may have all cited the same wrong blog post.
- **Burying contradictions.** If sources disagree, the disagreement *is* the finding. Surface it.
- **Citing without reading.** A URL in the Sources block you never opened is a hallucination risk. Verification is non-optional.
- **Delegating the synthesis.** "Based on your research, recommend X" sent to an agent makes the agent do your job. The whole point of this skill is that *you* read the agent reports and decide what they mean.
