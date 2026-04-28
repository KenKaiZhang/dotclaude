---
name: Prefer Explore subagent for multi-file searches
description: Use the Explore subagent instead of direct Grep/Read when searching across multiple files or directories to preserve main-session context
type: feedback
originSessionId: ef2ec5a7-5dd7-4c0c-a88b-9865e4a4b895
---
Prefer the `Explore` subagent over direct Grep/Read/Glob calls whenever a search spans more than ~3 files or crosses directory boundaries. Use direct tools only when the target file/symbol is already known.

**Why:** This project is large and each session wastes context traversing it. The Explore subagent runs in an isolated context — raw tool output stays there, only a distilled summary returns to the main session. Ken flagged this as a recurring pain point on 2026-04-16.

**How to apply:**
- Open-ended questions ("where does X live?", "how does Y work?", "find all usages of Z") → Explore subagent.
- Known target (specific file path, exact symbol name) → direct Read/Grep.
- Brief the Explore agent with the question and ask for a concise summary with file paths + line numbers, not raw dumps.
- When unsure whether a search will stay narrow, default to Explore — the cost of a subagent call is lower than the cost of polluting main context.
