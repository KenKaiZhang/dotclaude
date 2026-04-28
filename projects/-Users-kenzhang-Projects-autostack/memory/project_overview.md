---
name: AutoStack project overview
description: AI-powered full-stack app generator with 4-phase workflow (Configure, Design, API, Generate). FastAPI backend + Next.js 19 frontend + PostgreSQL. PixiJS canvas editor for visual design.
type: project
---

AutoStack is an AI-powered full-stack application generator that converts natural language descriptions into production-ready code through a phased, reviewable workflow.

**Why:** The goal is to let users describe what they want, iteratively design the UI via an AI-powered canvas editor, auto-generate API specs from the design, then produce a complete downloadable codebase.

**How to apply:** All work should preserve the phased workflow architecture. The 4-tab workspace (Configure → Design → API → Generate) is the core UX. The Design tab pairs a chat panel (always visible, resizable) with a PixiJS canvas editor. SSE streaming is used for all LLM-powered endpoints. The template system is pluggable — new stacks can be added without changing core logic. UI uses shadcn/ui with Base UI primitives (not Radix) and Tailwind CSS 4.
