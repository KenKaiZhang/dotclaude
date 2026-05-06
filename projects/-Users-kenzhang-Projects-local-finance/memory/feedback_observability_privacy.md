---
name: Privacy-first defaults — self-hosted LLM observability
description: User strongly prefers self-hosted Langfuse over SaaS for any LLM observability in this project
type: feedback
originSessionId: 4e58fc98-acf1-46cb-a15c-424d757d9261
---
When wiring LLM observability, default to **self-hosted Langfuse v3** via Docker Compose (web, worker, postgres, clickhouse, redis, minio). Don't suggest cloud.langfuse.com.

**Why:** This project's whole premise is privacy — financial documents must not leave the machine. The user was deliberate in selecting "Self-hosted via Docker Compose (Recommended)" over the SaaS option. They explicitly rejected the SaaS path during planning.

**How to apply:** Any new LLM call gets traced through `backend/app/services/observability.py` to local Langfuse. If Langfuse is unreachable, extraction must continue (graceful degradation) — observability never blocks the data path. Prompts are version-controlled in Langfuse (`lf.get_prompt(...)`), with in-repo fallback strings.
