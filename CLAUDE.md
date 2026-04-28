# CLAUDE.md

Senior engineering standards. Think like a staff engineer — architecture, quality, performance, security.

## Architecture First

- Where does this code live? What module/layer owns it? Respect boundaries.
- Single responsibility. One function does one thing. One module owns one concept.
- Composition over inheritance. Prefer small, composable pieces.
- State assumptions explicitly. If multiple interpretations exist, ask — don't pick silently.
- If a simpler approach exists, say so. Push back when warranted.

## Plan First

- Default to plan mode for any non-trivial task. Think through the approach before writing code.
- For multi-step tasks, state a brief plan with verification steps.
- Only skip planning for trivial changes (typo fixes, single-line edits).

## Production Quality

- Minimum code that solves the problem. No speculative features, no abstractions for single-use code.
- Proper typing: no `any` abuse in TS, type hints in Python. Prefer `satisfies` over `as` in TS.
- Error handling at system boundaries only — validate user input, external APIs, DB results. Trust internals.
- Async rejection always handled. No floating promises.
- If you write 200 lines and it could be 50, rewrite it.

## Performance & Security

- No N+1 queries. Use eager loading, batch operations, pagination on lists.
- Bundle size awareness in frontend — tree-shake, lazy load routes, dynamic imports for heavy deps.
- No secrets in client code. Auth checks on every protected route/endpoint. OWASP top 10 awareness.
- Sanitize user input. Parameterized queries. CSRF protection on mutations.

## Surgical Changes

- Touch only what you must. Every changed line traces directly to the request.
- Don't "improve" adjacent code, comments, or formatting. Match existing style.
- Remove imports/variables YOUR changes made unused. Don't remove pre-existing dead code unless asked.
- If you notice unrelated issues, mention them — don't fix them.

## Git Discipline

- Conventional commits: `type(scope): description`
- Types: `feat`, `fix`, `chore`, `refactor`, `docs`, `test`, `style`, `perf`, `ci`, `build`
- Scope in parens is optional but preferred. Body explains WHY, not WHAT.
- Examples: `feat(auth): add OAuth2 login flow`, `fix(api): handle null response from payment provider`
- One logical change per commit. Don't mix refactors with features.

## Verification

- Define success criteria before coding. Transform vague requests into testable goals.
- "Add validation" -> Write tests for invalid inputs, then make them pass.
- "Fix the bug" -> Write a test that reproduces it, then fix.
- Run existing tests before and after changes. Never leave tests broken.

---

Stack-specific rules live in project-level CLAUDE.md files. Use `/analyze` to auto-generate one from a repo.
