# Next.js + React + TypeScript

## Server vs Client Components

- Default to Server Components. Add `"use client"` only for interactivity, hooks, or browser APIs.
- Data fetching happens in Server Components — no `useEffect` for initial data loads.
- Server Actions for mutations. Use `"use server"` at the top of the action file or inline.
- Never import server-only code in client components. Use the `server-only` package to enforce.

## TypeScript

- Strict mode. No `any` — use `unknown` and narrow. No `as` without a comment explaining why.
- Zod schemas at API boundaries (route handlers, server actions, form validation).
- Prefer `satisfies` for type checking without widening: `const config = { ... } satisfies Config`.
- Use `React.ComponentProps<typeof X>` over manually redefining prop types.

## Data & State

- No prop drilling past 2 levels — use composition, context, or server component data flow.
- Co-locate data fetching with the route that needs it. Fetch in `page.tsx`, pass to children.
- For client state: `useState` for local, URL params for shareable, context sparingly.
- Cache and deduplicate with `fetch` defaults or `React.cache` for DB queries in server components.

## Routing & Files

- Use App Router conventions: `page.tsx`, `layout.tsx`, `loading.tsx`, `error.tsx`, `not-found.tsx`.
- Co-locate components with their route. Shared components in `components/`.
- Route groups `(group)` for layout organization without affecting URL.
- Parallel routes and intercepting routes when the UX calls for it.

## Styling

- Tailwind utility classes. Design tokens via `tailwind.config`.
- Extract repeated patterns into components, not CSS classes.
- Use `cn()` (clsx + twMerge) for conditional class merging.

## Performance

- Use `next/image` for images, `next/font` for fonts, `next/link` for navigation.
- Dynamic imports (`next/dynamic`) for heavy client components.
- Streaming with `loading.tsx` and `Suspense` boundaries for progressive rendering.
- Metadata API for SEO — `generateMetadata` in layouts/pages.
