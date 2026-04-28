---
name: Ken's UI preferences and past decisions
description: UI design preferences and lessons learned from past iterations on the canvas editor and design tab.
type: feedback
---

**Minimal, compact UI** — Ken prefers a modern, minimal feel. Combined header + tabs into a single compact row (h-11). Project name bold, tabs right-aligned.

**Why:** Ken consistently pushes toward less chrome and more content area. Merged separate header and tab bars, removed unnecessary gaps, removed border boxes around assistant messages.

**How to apply:** Default to compact, information-dense layouts. Avoid extra wrappers, borders, and spacing that don't add value.

---

**Don't attempt full-screen canvas with overlay approach** — Multiple attempts to make the canvas full-screen with toolbar/layers/properties/chat as overlays failed due to CSS stacking context issues (child z-indexes can't escape parent stacking context). All attempts were reverted.

**Why:** z-index stacking bugs caused layers panel to hide behind chat, broken layouts. ResizeObserver also didn't fire reliably with absolute positioning during CSS transitions.

**How to apply:** Keep the current flex layout in design-tab.tsx and canvas-editor.tsx. Don't try to restructure the canvas as a full-screen base layer with everything else as overlays. The flex approach works.

---

**Chat panel is always visible** — After trying open/close toggle animations (text warping during close, canvas not resizing to fill freed space), Ken decided to remove the toggle entirely. Chat is always shown.

**Why:** CSS width transitions caused text reflow artifacts, and the PixiJS canvas didn't reliably resize during/after transitions. Multiple approaches failed.

**How to apply:** Don't add a chat open/close toggle back unless Ken explicitly asks. The chat panel is always visible and resizable via drag handle.
