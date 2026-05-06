---
name: Local Finance Tool overview
description: High-level context for the local-finance project — what it is, why it exists, who uses it
type: project
originSessionId: 4e58fc98-acf1-46cb-a15c-424d757d9261
---
**Local Finance** is a privacy-first personal finance tool. The user uploads monthly credit card statements and pay stubs (PDF; mix of digital and scanned); a locally hosted Ollama LLM extracts transactions and earnings; everything is stored in a local SQLite DB. No data ever leaves the machine.

**Why:** Existing tools (Mint/Copilot/Monarch) require sending statements to a third-party SaaS, and bank scrapers are unreliable. This sidesteps both.

**Stack:** Python 3.11+ FastAPI + SQLAlchemy 2.0 + Alembic + Pydantic v2 backend; Vite + React 18 + TS + Tailwind + shadcn/ui + Recharts frontend; Ollama (`llama3.1:8b` text, `llama3.2-vision:11b` vision-fallback); SQLite at `data/finance.db`; self-hosted Langfuse v3 for LLM observability.

**Why:** Project is greenfield, single user, macOS Apple Silicon — durable context for future sessions.

**How to apply:** Reach for these stack defaults instead of re-asking. Reconcile every extraction (statement total ↔ sum of transactions, $0.01 tolerance) — non-negotiable. Money is always cents-as-int (BIGINT). Approved plan lives at `~/.claude/plans/i-want-to-create-polymorphic-snowglobe.md`.
