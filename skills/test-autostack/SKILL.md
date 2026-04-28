---
name: test-autostack
description: Run browser-based tests for AutoStack pages using Playwright MCP. Use when the user invokes /test-autostack <page> to test a specific area of the app.
user-invokable: true
argument-hint: "<page> — landing | projects | navigation | design | api | configure | generate | settings | errors | all"
args:
  - name: page
    description: "Which page/area to test: landing, projects, navigation, design, api, configure, generate, settings, errors, or all"
    required: true
---

# AutoStack Browser Test Runner

You are a test engineer executing browser-based tests for AutoStack (localhost:3000) using Playwright MCP tools. The app runs with DEV_MODE=true (auth bypassed).

## How to Execute Tests

1. Parse the `<page>` argument to determine which test group(s) to run
2. For each test in the group:
   - Execute the action using Playwright MCP tools
   - Take a `browser_snapshot` to verify the result
   - Report the result as `PASS` or `FAIL` with details
3. After all tests, print a summary table

## User Persona

When evaluating the UI, judge it from the perspective of AutoStack's target users:

**Who:** Software developers and engineers — ranging from junior devs building side projects to senior engineers prototyping MVPs. They're comfortable with technical concepts (APIs, databases, frameworks) but want to skip the boilerplate.

**What they value:**
- Speed — get from idea to working code fast, no unnecessary steps
- Clarity — know exactly what's happening at each phase, what they can control
- Control — ability to review and tweak designs, API specs, and config before code gen
- Technical accuracy — generated output should reflect real patterns, not toy examples

**When evaluating UI, consider:**
- Technical terminology is fine — don't flag "REST endpoint" or "PostgreSQL" as jargon
- Workflows should feel efficient — extra clicks or unclear next-steps are real problems
- Error states should be actionable — "something went wrong" is unacceptable for this audience
- The canvas/design phase should feel like a tool, not a toy

## Reporting Format

After each test, output exactly one line:
```
PASS: T1.1 - Test name
FAIL: T1.1 - Test name — reason for failure
SKIP: T1.1 - Test name — reason for skip
```

At the end, output a summary:
```
## Summary
Total: X | Passed: Y | Failed: Z | Skipped: W
```

## Important Notes

- Always use `browser_snapshot` (not screenshot) for verification — it gives structured accessibility data
- Use `browser_navigate` to go to pages
- Use `browser_click` with `ref=eXX` from snapshot to click elements
- Use `browser_fill_form` to fill text inputs
- Use `browser_press_key` for keyboard actions (Enter, Escape, etc.)
- Use `browser_hover` to test hover states
- Wait briefly after navigation or clicks before taking snapshots
- If a test depends on prior state (e.g., a project existing), note it and skip if preconditions aren't met
- The app is at `http://localhost:3000`, backend at `http://localhost:8000`
- DEV_MODE=true: auth is bypassed, dev user is auto-created

---

## Test Groups

### `landing` — Landing Page (`/`)

**T1.1 - Landing page renders**
- Action: `browser_navigate` to `http://localhost:3000/`
- Action: `browser_snapshot`
- Pass if: Snapshot contains text "Describe your app" AND "Get a full codebase" AND visible heading/hero content

**T1.2 - Feature cards display**
- Action: Check current snapshot
- Pass if: Snapshot contains "Phased Workflow", "Clean Output", and "SKILL.md Included"

**T1.3 - "Sign in" navigates to /projects**
- Action: Find and `browser_click` the "Sign in" link in the nav
- Action: `browser_snapshot`
- Pass if: Page URL is `http://localhost:3000/projects`

**T1.4 - "Get started" navigates to /projects**
- Action: `browser_navigate` back to `http://localhost:3000/`
- Action: Find and `browser_click` "Get started" button
- Action: `browser_snapshot`
- Pass if: Page URL is `http://localhost:3000/projects`

**T1.5 - "Start building" CTA navigates to /projects**
- Action: `browser_navigate` back to `http://localhost:3000/`
- Action: Find and `browser_click` "Start building" link in hero
- Action: `browser_snapshot`
- Pass if: Page URL is `http://localhost:3000/projects`

---

### `navigation` — Navigation & Layout

**T2.1 - Sidebar renders on /projects**
- Action: `browser_navigate` to `http://localhost:3000/projects`
- Action: `browser_snapshot`
- Pass if: Snapshot contains sidebar with "Projects" nav item, "Settings" nav item, and user email

**T2.2 - Sidebar active state**
- Action: Check current snapshot
- Pass if: "Projects" nav item appears active/selected, "Settings" does not

**T2.3 - Navigate to Settings via sidebar**
- Action: `browser_click` the "Settings" nav item
- Action: `browser_snapshot`
- Pass if: URL is `/settings` AND "Settings" nav appears active

**T2.4 - Theme toggle**
- Action: Find the theme toggle button (Moon/Sun icon) and `browser_click` it
- Action: `browser_snapshot`
- Pass if: Theme icon changed (Moon to Sun or vice versa)

**T2.5 - Theme toggle back**
- Action: `browser_click` theme toggle again
- Action: `browser_snapshot`
- Pass if: Theme icon reverted

**T2.6 - Sign out**
- Action: Find "Sign out" button/link and `browser_click` it
- Action: `browser_snapshot`
- Pass if: URL is `/login`
- Cleanup: Navigate back to `/projects` for subsequent tests

---

### `projects` — Projects Dashboard (`/projects`)

**T3.1 - Projects page loads**
- Action: `browser_navigate` to `http://localhost:3000/projects`
- Action: `browser_snapshot`
- Pass if: Snapshot contains "Projects" heading and "New Project" button

**T3.2 - Project cards display**
- Action: Check current snapshot
- Pass if: At least one project card is visible with a project name and status badge

**T3.3 - Click project card navigates to workspace**
- Action: `browser_click` on a project card (the first one found)
- Action: `browser_snapshot`
- Pass if: URL matches `/project/[uuid]` pattern AND tabs (Design, API, Configure, Generate) are visible

**T3.4 - Back to projects**
- Action: `browser_navigate_back` or click back arrow
- Action: `browser_snapshot`
- Pass if: URL is `/projects`

**T3.5 - "New Project" opens overlay**
- Action: `browser_click` "New Project" button
- Action: `browser_snapshot`
- Pass if: Overlay visible with "What do you want to build?" text and textarea

**T3.6 - Overlay: Escape closes it**
- Action: `browser_press_key` "Escape"
- Action: `browser_snapshot`
- Pass if: Overlay is gone, project list visible

**T3.7 - Overlay: Back button closes it**
- Action: `browser_click` "New Project" again
- Action: Find and `browser_click` the "Back" button in overlay
- Action: `browser_snapshot`
- Pass if: Overlay is gone

**T3.8 - Overlay: Submit disabled when empty**
- Action: `browser_click` "New Project" to open overlay
- Action: `browser_snapshot`
- Pass if: Submit/send button appears disabled

**T3.9 - Overlay: Type prompt enables submit**
- Action: `browser_fill_form` the textarea with "A test notes app"
- Action: `browser_snapshot`
- Pass if: Submit button no longer appears disabled

**T3.10 - Overlay: Viewport toggle**
- Action: Find viewport toggle and `browser_click` it
- Action: `browser_snapshot`
- Pass if: Toggle state changed (e.g., from Desktop to Mobile)

**T3.11 - Overlay: Model selector**
- Action: Find model selector button and `browser_click` it
- Action: `browser_snapshot`
- Pass if: Dropdown shows available models

**T3.12 - Overlay: Create project**
- Action: Close any dropdowns, ensure textarea has text
- Action: `browser_press_key` "Enter" to submit
- Action: Wait for navigation, `browser_snapshot`
- Pass if: URL changed to `/project/[new-uuid]` — a new project workspace

**T3.13 - Delete: confirmation dialog**
- Action: `browser_navigate` to `/projects`
- Action: `browser_hover` over a project card to reveal trash icon
- Action: `browser_click` the trash/delete icon
- Action: `browser_snapshot`
- Pass if: AlertDialog visible with "Delete project?" text and Cancel/Delete buttons

**T3.14 - Delete: cancel**
- Action: `browser_click` "Cancel" in the dialog
- Action: `browser_snapshot`
- Pass if: Dialog closed, project card still visible

---

### `tabs` — Workspace Tab Navigation

**T4.1 - Workspace loads with all tabs**
- Action: `browser_navigate` to a project URL (find one from `/projects` first if needed)
- Action: `browser_snapshot`
- Pass if: 4 tabs visible: Design, API, Configure, Generate

**T4.2 - Switch to API tab**
- Action: `browser_click` the "API" tab
- Action: `browser_snapshot`
- Pass if: API tab content loads (endpoints table or empty state)

**T4.3 - Switch to Configure tab**
- Action: `browser_click` the "Configure" tab
- Action: `browser_snapshot`
- Pass if: Configure content loads (Project Name input, language/framework grids)

**T4.4 - Switch to Generate tab**
- Action: `browser_click` the "Generate" tab
- Action: `browser_snapshot`
- Pass if: Generate content loads ("Code Generation" heading, "Generate Code" button)

**T4.5 - Switch back to Design tab**
- Action: `browser_click` the "Design" tab
- Action: `browser_snapshot`
- Pass if: Design content loads (chat panel + canvas area)

**T4.6 - Back arrow to /projects**
- Action: Find back arrow link and `browser_click` it
- Action: `browser_snapshot`
- Pass if: URL is `/projects`

**T4.7 - Rapid tab switching**
- Action: Navigate to a project, quickly click Design → API → Configure → Generate → Design
- Action: `browser_snapshot` after final switch
- Pass if: Design tab renders correctly, no errors in console

---

### `configure` — Configure Tab

**T5.1 - Project Details section**
- Action: Navigate to a project workspace, click "Configure" tab
- Action: `browser_snapshot`
- Pass if: "Project Name" input and "Description" textarea visible with pre-filled values

**T5.2 - Backend Language grid**
- Action: Check snapshot
- Pass if: Three language options visible: Python, TypeScript, Go

**T5.3 - Change backend language**
- Action: `browser_click` "TypeScript" option
- Action: `browser_snapshot`
- Pass if: TypeScript highlighted AND Backend Framework section shows TypeScript frameworks (Express, NestJS, Hono)

**T5.4 - Frontend Framework grid**
- Action: Check snapshot
- Pass if: Three options visible: React/Next.js, Vue/Nuxt, Svelte/SvelteKit

**T5.5 - Database grid**
- Action: Check snapshot
- Pass if: Five options visible: PostgreSQL, MySQL, SQLite, MongoDB, None

**T5.6 - Change project name**
- Action: Clear the project name input and type "Test Project Renamed"
- Action: `browser_snapshot`
- Pass if: Input shows "Test Project Renamed"

**T5.7 - Save Configuration**
- Action: `browser_click` "Save Configuration" button
- Action: Wait briefly, `browser_snapshot`
- Pass if: Toast notification "Configuration saved" appears OR button shows success state

---

### `generate` — Generate Tab

**T6.1 - Initial state**
- Action: Navigate to a project workspace, click "Generate" tab
- Action: `browser_snapshot`
- Pass if: "Code Generation" heading visible, "Generate Code" button visible

**T6.2 - Click Generate Code**
- Action: `browser_click` "Generate Code" button
- Action: Wait a few seconds, `browser_snapshot`
- Pass if: Button shows "Generating..." OR progress step badges are visible

**T6.3 - Progress steps appear**
- Action: `browser_snapshot` during generation
- Pass if: Step badges visible (scaffolding, models, routes, components, pages, skillmd, readme) with some completed (green) and some pending

**T6.4 - Generation completes**
- Action: Wait for generation to finish (poll with snapshots every 3-5 seconds, max 60 seconds)
- Action: `browser_snapshot`
- Pass if: "Download ZIP" button/link appears OR file tree is visible

**T6.5 - Previous generations**
- Action: Check snapshot after generation
- Pass if: "Previous Generations" section visible with at least one entry showing version, status badge

---

### `settings` — Settings & Provider Management

**T7.1 - Settings page loads**
- Action: `browser_navigate` to `http://localhost:3000/settings`
- Action: `browser_snapshot`
- Pass if: "Settings" heading, Profile section (email, tokens), LLM Providers section visible

**T7.2 - Profile section**
- Action: Check snapshot
- Pass if: Email field shows dev user email, token usage displayed

**T7.3 - Providers section state**
- Action: Check snapshot
- Pass if: Either shows configured providers list OR empty state ("No providers configured" with "Add your first provider" button)

**T7.4 - Navigate to add provider**
- Action: `browser_click` "Add provider" or "Add your first provider" button
- Action: `browser_snapshot`
- Pass if: URL is `/settings/providers/new`, form visible with provider dropdown

**T7.5 - Provider dropdown**
- Action: Find and `browser_click` the provider dropdown/select
- Action: `browser_snapshot`
- Pass if: Options visible: OpenAI, Anthropic, Google, Self-Hosted (minus already configured ones)

**T7.6 - Select Self-Hosted**
- Action: `browser_click` "Self-Hosted" option
- Action: `browser_snapshot`
- Pass if: Additional fields appear: "Base URL" input and "Model Name" input

**T7.7 - Validation: empty save**
- Action: Clear any fields, `browser_click` "Save endpoint" button
- Action: `browser_snapshot`
- Pass if: Error toast appears (e.g., "Base URL and model name are required")

**T7.8 - Cancel returns to settings**
- Action: `browser_click` "Cancel" button
- Action: `browser_snapshot`
- Pass if: URL is `/settings`

**T7.9 - Default Model picker**
- Action: Find the Default Model section and `browser_click` to expand
- Action: `browser_snapshot`
- Pass if: Model list visible showing available models (GPT-4o Mini, Claude Sonnet 4, etc.)

**T7.10 - Change default model**
- Action: `browser_click` a different model from the expanded list
- Action: `browser_snapshot`
- Pass if: Selected model changes (check mark moves), toast "Default model updated" appears

**T7.11 - Delete provider (if one exists)**
- Action: If a provider is configured, find its delete/trash icon and `browser_click`
- Action: `browser_snapshot`
- Pass if: Provider removed from list
- Skip if: No providers configured

---

### `api` — API Tab

**T8.1 - API tab state**
- Action: Navigate to a project workspace, click "API" tab
- Action: `browser_snapshot`
- Pass if: Either shows endpoints table OR empty state ("No endpoints yet" with "Generate from design" button)

**T8.2 - Add Endpoint**
- Action: If endpoints exist, find "Add Endpoint" button and `browser_click`
- Action: `browser_snapshot`
- Pass if: New row appears in edit mode with method dropdown, path input, description input

**T8.3 - Edit endpoint inline**
- Action: `browser_click` on an endpoint row to enter edit mode
- Action: `browser_snapshot`
- Pass if: Row shows editable fields (method dropdown, path input, description input)

**T8.4 - Change method**
- Action: In edit mode, `browser_click` the method dropdown, select "POST"
- Action: `browser_snapshot`
- Pass if: Method badge changes to POST (blue)

**T8.5 - Delete endpoint**
- Action: `browser_click` the trash/delete icon on an endpoint row
- Action: `browser_snapshot`
- Pass if: Row removed from table

**T8.6 - Save Changes**
- Action: `browser_click` "Save Changes" button
- Action: `browser_snapshot`
- Pass if: Toast "API spec saved" appears

---

### `design` — Design Tab

**T9.1 - Design tab layout**
- Action: Navigate to a project workspace (Design tab is default)
- Action: `browser_snapshot`
- Pass if: Left chat panel visible with "CHAT" label, right side has canvas area with toolbar

**T9.2 - Chat input area**
- Action: Check snapshot
- Pass if: Textarea with "Describe changes..." placeholder, viewport toggle, model selector, send button visible

**T9.3 - Send button disabled when empty**
- Action: Ensure textarea is empty
- Action: `browser_snapshot`
- Pass if: Send button appears disabled

**T9.4 - Viewport toggle**
- Action: Find viewport toggle and `browser_click` Desktop/Mobile button
- Action: `browser_snapshot`
- Pass if: Toggle state changed

**T9.5 - Model selector**
- Action: Find model selector button and `browser_click`
- Action: `browser_snapshot`
- Pass if: Model dropdown appears with available models

**T9.6 - Canvas toolbar visible**
- Action: Check snapshot for toolbar area
- Pass if: Tool buttons visible (Select, Rectangle, Ellipse, Text, Frame identifiable by their refs)

**T9.7 - Zoom controls**
- Action: Find zoom percentage display in toolbar
- Pass if: Zoom percentage visible (e.g., "80%" or "100%")

**T9.8 - Click zoom in**
- Action: `browser_click` zoom in button
- Action: `browser_snapshot`
- Pass if: Zoom percentage increased

**T9.9 - Click zoom out**
- Action: `browser_click` zoom out button
- Action: `browser_snapshot`
- Pass if: Zoom percentage decreased

**T9.10 - Layers panel**
- Action: Check snapshot
- Pass if: "Layers" heading visible, either shows element tree or "No elements yet"

**T9.11 - Type a chat message**
- Action: `browser_click` the textarea, type "Add a header with the app name"
- Action: `browser_snapshot`
- Pass if: Text appears in textarea, send button becomes enabled

**T9.12 - Generation overlay (if generating)**
- Action: If design generation is in progress, check snapshot
- Pass if: Overlay shows "Designing your app..." or similar status text
- Skip if: No generation in progress

---

### `errors` — Error States & Edge Cases

**T10.1 - Invalid project ID**
- Action: `browser_navigate` to `http://localhost:3000/project/00000000-0000-0000-0000-000000000000`
- Action: Wait for redirect, `browser_snapshot`
- Pass if: URL redirected to `/projects`

**T10.2 - Invalid provider ID**
- Action: `browser_navigate` to `http://localhost:3000/settings/providers/invalid-id`
- Action: Wait for redirect, `browser_snapshot`
- Pass if: URL redirected to `/settings`

**T10.3 - Design without API key**
- Action: Navigate to a project with no LLM provider configured
- Action: Check Design tab snapshot
- Pass if: Either blur overlay with "Connect an LLM provider" message, or error in chat

**T10.4 - Rapid tab switching**
- Action: On a project workspace, quickly click: API → Configure → Generate → Design (use browser_click in sequence)
- Action: `browser_snapshot` after last click
- Pass if: Design tab renders correctly without errors
