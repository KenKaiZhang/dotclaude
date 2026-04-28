---
name: analyze
description: Explore a repository's structure, stack, patterns, and conventions, then generate or update a project-level CLAUDE.md tailored to what was found. Saves tokens in future sessions by front-loading context.
user-invocable: true
disable-model-invocation: true
allowed-tools: Read Grep Glob Bash Write Edit Agent
effort: max
argument-hint: [path-to-repo]
---

# Analyze Repository

You are generating a project-level CLAUDE.md by exploring the actual repository. This file will be loaded into every future Claude session for this project, so accuracy and conciseness matter.

## Step 1: Discover the Stack

Scan the project root for dependency/config files to identify the stack:
- `package.json` -> Node.js (check for Next.js, React, Vue, Svelte, Express, etc.)
- `pyproject.toml` / `requirements.txt` / `Pipfile` -> Python (check for Django, FastAPI, Flask, etc.)
- `Cargo.toml` -> Rust
- `go.mod` -> Go
- `Gemfile` -> Ruby
- `composer.json` -> PHP
- `supabase/config.toml` or `@supabase/supabase-js` in deps -> Supabase
- `tsconfig.json` -> TypeScript (check `strict` mode, path aliases)
- `.env.example` / `.env.local` -> Environment variable patterns
- `Dockerfile` / `docker-compose.yml` -> Container setup
- `Makefile` / `Justfile` -> Build commands

Also scan for: ORM (Prisma, Drizzle, SQLAlchemy, Django ORM), CSS approach (Tailwind, CSS Modules, styled-components), test framework (Jest, Vitest, pytest, Playwright), linter/formatter (ESLint, Prettier, Ruff, Black).

## Step 2: Map the Architecture

Identify the directory structure:
- Entry points and routing patterns (App Router, Pages Router, Django URLs, FastAPI routers)
- Component/module organization (co-located, feature-based, layer-based)
- API structure (route handlers, controllers, views)
- Shared utilities, types, and config locations
- Test directory structure and naming conventions

## Step 3: Detect Conventions

Sample 3-5 existing files to detect:
- Naming conventions (camelCase, snake_case, PascalCase for components)
- Import ordering and style
- Error handling patterns
- State management approach
- API call patterns
- Component structure (functional, hooks usage, prop patterns)

## Step 4: Check for Existing CLAUDE.md

If a CLAUDE.md already exists at the project root:
- Read it carefully
- Plan an UPDATE (merge new findings) rather than a full overwrite
- Preserve any user-written rules or preferences
- Add newly discovered information

## Step 5: Select and Adapt Template

Match detected stack to templates in `~/.claude/templates/`:
- `nextjs.CLAUDE.md` for Next.js projects
- `python.CLAUDE.md` for Python projects
- `supabase.CLAUDE.md` for Supabase projects

Use the closest template as a starting point. Customize based on actual findings:
- If the project uses Drizzle instead of Prisma, reflect that
- If there's a specific test runner, note the commands
- If there are unusual patterns, document them
- Remove template rules that don't apply

If no template matches, generate rules from scratch based on the detected stack and conventions.

## Step 6: Generate Project CLAUDE.md

Write or update `<project-root>/CLAUDE.md` with these sections (keep it under 80 lines):

```
# Project Name

Brief one-line description of what this project is.

## Stack
- List detected technologies and versions

## Structure
- Key directories and what they contain

## Conventions
- Detected patterns the AI should follow

## [Stack-Specific Best Practices]
- Adapted from template, relevant to THIS project

## Commands
- `dev`: how to start dev server
- `test`: how to run tests
- `build`: how to build
- `lint`: how to lint
- (any other important scripts)
```

## Step 7: Report

After writing, summarize:
- What stack was detected
- What template was used (if any)
- Key conventions found
- What was written to CLAUDE.md
- Suggest any manual tweaks the user might want to make
