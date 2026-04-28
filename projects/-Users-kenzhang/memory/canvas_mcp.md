---
name: Canvas LMS MCP
description: User-scope MCP server giving Claude access to the user's SFSU Canvas data (courses, assignments, grades, deadlines) in every session
type: reference
originSessionId: 394023e9-a4dd-41ab-ab26-63f3be6b3124
---
Canvas LMS MCP server is registered at **user scope** in `~/.claude.json`, so it loads in every Claude Code session regardless of working directory.

- Source: `/Users/kenzhang/MCP/canvas-mcp/` (see `CLAUDE.md` there for full tool list)
- Command: `/Library/Frameworks/Python.framework/Versions/3.11/bin/python3 /Users/kenzhang/MCP/canvas-mcp/server.py`
- Env: `CANVAS_BASE_URL=https://sfsu.instructure.com`
- Institution: SFSU (canvas.sfsu.edu / sfsu.instructure.com)
- Auth: runtime — call `check_auth_status` → `set_canvas_token` or `set_canvas_cookie`. Persists to `.credentials.json` in the repo.
- Key tools: `list_courses`, `list_assignments`, `get_upcoming_deadlines`, `list_missing_submissions`, `get_all_grades_summary`, `get_course_grades`, `list_modules`, `list_announcements`, `get_activity_stream`.

**How to apply:** when the user asks about their schoolwork, coursework, assignments, grades, or deadlines, use the canvas tools directly rather than asking them to paste info. If `check_auth_status` reports unauthenticated, walk them through the cookie/token flow.
