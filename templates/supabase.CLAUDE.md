# Full-Stack Supabase

## Client Setup

- `createServerClient` for server-side (Server Components, Route Handlers, Server Actions, middleware).
- `createBrowserClient` for client-side. Never expose the service role key to the client.
- Single Supabase client instance per request server-side. Singleton on the client.
- Generated types via `supabase gen types typescript` — never define DB types manually.

## Auth

- Middleware refreshes the session on every request. Use the `@supabase/ssr` cookie helpers.
- Server-side: `getUser()` for auth checks, NOT `getSession()` (session can be spoofed from JWT).
- Protect Server Actions: always call `getUser()` at the top, return error if unauthorized.
- Client-side: `onAuthStateChange` for reactive auth. Redirect on sign-out.
- Email/password, OAuth, magic link — configure in Supabase Dashboard, not in code.

## Row Level Security (RLS)

- RLS enabled on EVERY table. No exceptions.
- Policies use `auth.uid()` to scope access. Test both authorized and unauthorized access.
- Service role bypasses RLS — only use in trusted server contexts (webhooks, admin scripts).
- Common patterns: `auth.uid() = user_id` for ownership, join tables for team access.
- Test RLS policies explicitly: query as different users, verify denied access returns empty, not error.

## Database

- Migrations via `supabase migration new` CLI. Never modify production schema manually.
- Foreign keys with appropriate cascade rules (`ON DELETE CASCADE` vs `SET NULL`).
- Use DB functions for multi-table transactions — don't rely on client-side transaction logic.
- Indexes on columns used in WHERE, JOIN, ORDER BY. Check with `EXPLAIN ANALYZE`.
- Use views for complex read queries. Use RPC for complex write operations.

## Realtime & Edge Functions

- Realtime: subscribe/unsubscribe in `useEffect` cleanup. Filter channels to specific rows/events.
- Don't subscribe to entire tables — use filters: `.on('postgres_changes', { filter: 'id=eq.123' })`.
- Edge Functions: verify webhook signatures. Set CORS headers. Keep cold starts fast.
- Use `Deno.serve` pattern. Import from `https://esm.sh` for npm packages in Edge Functions.

## Storage

- Bucket policies mirror RLS patterns. Public buckets for assets, private for user uploads.
- Use signed URLs for temporary access to private files. Set short expiry times.
- Validate file types and sizes server-side before upload. Use `transformations` for images.
