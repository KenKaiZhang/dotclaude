# Brembo Assignment — Project Memory

## Stack
- **Backend**: Python 3.12 (via `.venv`), FastAPI, SQLAlchemy 2.0, SQLite, httpx, pytest
- **Frontend**: Next.js 16 (App Router), React 19, TypeScript, TailwindCSS v4, shadcn/ui, Vitest

## Key Decisions
- Python 3.12 venv at `backend/.venv`
- SQLite DB auto-created at `backend/tasks.db` on startup (not committed)
- **Vitest**: Use `happy-dom` (not `jsdom` — jsdom v28 has ESM compat issues with Vite v7)
- **package.json**: must have `"type": "module"` for Vitest v4 + Vite v7 ESM support
- pytest uses `StaticPool` for SQLite in-memory test DB (ensures all connections share same DB)
- `from __future__ import annotations` NOT needed for Python 3.12 (supports `X | None` natively)

## Test Commands
```bash
# Backend
cd backend && source .venv/bin/activate && python -m pytest tests/ -v

# Frontend
cd frontend && npm run test:run
```

## Run Commands
```bash
# Backend dev server
cd backend && source .venv/bin/activate && uvicorn app.main:app --reload --port 8000

# Frontend dev server
cd frontend && npm run dev
```
