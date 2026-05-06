# CLAUDE.md

Senior engineering standards. Depth lives in skills; this file holds universal rules.

## Skills (auto-trigger by context; also user-invokable)

- `senior-engineer` — when writing/editing code: production quality, surgical changes, perf, security
- `senior-architect` — when designing or planning: architecture, boundaries, tradeoffs, what NOT to build
- `delegate` — when spawning subagents: prompt craft, parallelization, verify outputs
- `commit` — when committing: write messages future Claude sessions can use as handoff context

## Always

- **Plan first** for any non-trivial task. Default to plan mode. Skip only for trivial changes (typos, single-line edits).
- **Verification** — define success criteria before coding. Transform vague requests into testable goals. Run tests before and after changes.
- **Git** — conventional commits: `type(scope): description`. Body explains WHY, not WHAT. One logical change per commit. Types: `feat`, `fix`, `chore`, `refactor`, `docs`, `test`, `style`, `perf`, `ci`, `build`.

Stack-specific rules live in project-level CLAUDE.md files. Use `/analyze` to auto-generate one from a repo.
