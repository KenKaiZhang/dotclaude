---
name: Canvas MCP Server
description: Python MCP server for Canvas LMS student workflows — project purpose, stack, and setup requirements
type: project
originSessionId: 8f64ce22-2740-4205-81c1-966becff878b
---
A Python MCP server at /Users/kenzhang/MCP that gives Claude access to Canvas LMS data for a student user.

**Why:** User wanted an MCP to support their educational ventures, allowing Claude to answer questions about assignments, grades, course content, announcements, and analytics directly from Canvas.

**Stack:** Python 3.11, FastMCP (mcp[cli]), httpx (async), python-dotenv

**Key files:**
- server.py — FastMCP entry point
- canvas_client.py — async httpx Canvas API client with auto-pagination
- config.py — Settings from CANVAS_API_TOKEN and CANVAS_BASE_URL env vars
- tools/{courses,assignments,grades,content,discussions,analytics}.py — 19 tools total
- .mcp.json — Claude Code MCP server registration

**How to apply:** Before making changes, note the user is a student (read-only tools only — no assignment creation or grade modification). All tools return formatted Markdown strings and never raise exceptions.

**Setup still needed:** User must fill in CANVAS_API_TOKEN and CANVAS_BASE_URL in .mcp.json (or create a .env file) before the server will authenticate.
