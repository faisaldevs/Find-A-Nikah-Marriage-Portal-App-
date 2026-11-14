# Feed — review of the backend reply (2026-11-14)

Source: [FEED_MOBILE_IMPLEMENTATION_PLAN.md](FEED_MOBILE_IMPLEMENTATION_PLAN.md)
(verbatim copy). The backend says all phases 0–5 are built; their suite reports
**75/75 Feed tests passing**. We have **not** verified any of it on a device yet.

## What they answered (decisions closed)

| Our item | Their answer |
|---|---|
| O1 / NEED §10 edit window | **15 minutes** for posts and comments, `403 EDIT_WINDOW_EXPIRED`; topic not editable |
| O2 / §19 Message a non-matched author | Free members: **no direct chat**; opens the compliment sheet (`POST /profiles/swipe {action:"complement", targetUserId, text}`); matched → chat; Gold/Premium with `canMessageBeforeMatch` → direct chat |
| O3 / §14 Likes tab | **Private** — only the owner sees it; others get an empty list |
| O4 / §13 view counted | Yes, recorded as a profile visit with source `"feed"` |
| §5 "For you" | engagement + freshness score; "stable cursor" (see concern C1) |
| §6 deep links | `GET /feed/posts/:id` with `404 POST_NOT_FOUND`, `410 POST_DELETED`, `403 BLOCKED` |
| §13 locked profile | `access {level, reason, unlockable, lockedSections}` on `GET /profiles/:userId`; locked sections **removed on the server** |
| §22 reports | 5 unique reports → auto-hidden; reporting hides the post for the reporter |
| §18 share | `https://findanikah.app/feed/post/:id`, `/feed/u/:userId` |
| Limits | post ≤ 5000 chars, comment ≤ 2000, 30 posts/hour |

## Decisions this changes for the app

- **Likes tab:** show it **only on your own profile**; hide it on other members' profiles (`02_DECISIONS` O3).
- **Message button:** matched → open chat; unmatched → open the existing compliment sheet; hide for others only if no entitlement and compliments unavailable (O2).
- **Compose topic picker:** list only topics with `canPost: true` (e.g. "Announcements" is read-only).
- **Edit UI:** offer Edit only while `createdAt` is < 15 min; handle `EDIT_WINDOW_EXPIRED`.
- **Auto-hide / report:** after reporting, remove the post from the list locally.
- Follow button: hide on own profile (`isMe`), handle `CANNOT_FOLLOW_SELF`.

## Concerns / things to verify on a device

| # | Item | Why |
|---|---|---|
| C1 | "For you" is ranked by engagement score **but** paged by `_id < cursor` — those two don't agree. Sample shows `nextCursor` set even when `hasMore:false` | Verify by paging a seeded feed: no duplicates / skips; treat `hasMore` as the stop signal, ignore `nextCursor` when false |
| C2 | Base URL is `http://localhost:5001/api/v1`; `photoUrl` samples are `http://localhost:5001/uploads/...` | A phone can't reach localhost: need a tunnel / `adb reverse tcp:5001` or a hosted dev URL; image URLs may need rewriting to `IMAGE_BASE_URL` (relative vs absolute?) — ask |
| C3 | Both test accounts show `displayName: "Chat T."`; all `photoUrl: null` | Can't tell authors apart on screen; ask for seeded members with different names and photos |
| C4 | `topComment` inside list items has no `replyCount` (id, author, body, likeCount, createdAt only) | Our preview shows "N Replies" — default 0 or ask for the field |
| C5 | No example for: **locked / partial** `GET /profiles/:userId` payload and what a **blurred photo** looks like (field name? URL?) | We can't build the lock UI without it. Ask for a real locked-response sample |
| C6 | How does the server know the visit came from Feed (`source:"feed"`)? | Query param? header? Not specified |
| C7 | `access.reason` also lists `HIDDEN`, `PREMIUM_REQUIRED`; same-gender profiles come back `partial / NOT_ELIGIBLE` | Confirm: does a man opening a man's Feed profile get a mostly-empty Marriage side? Define the copy for each reason |
| C8 | Search: examples show `{ items: [...] }` without `nextCursor/hasMore`; no min query length | Confirm paging + minimum length |
| C9 | **Comments tab** (`/users/:id/comments`) shape is described, no real example; **followers/following** only shape-described | Ask for sample responses |
| C10 | Still unanswered from our doc: what deleting a post does to its comments (§10); what deleting a comment does to its replies (§12); comment rate limit (§12); how to **block** from Feed (reuse existing block API?) and confirm blocked members vanish from Feed (§17); unmute / muted list; deleted-account author behaviour confirmed only as "Deleted member" | Ask in a short round 2 |
| C11 | Views: `POST /feed/posts/views {postIds}` — app must send impressions | Design: batch + dedupe, send on scroll idle / leave; keep it off the critical path |
| C12 | Their sample DTO defaults `countryCode` to `'bd'` | Don't copy that; use `null` → no flag badge |
| C13 | Universal links need Android App Links / iOS associated domains on `findanikah.app` | App-side + domain setup, later (Phase 5) |
| C14 | Response envelope: `{statusCode, success, message, data}` with `data.items/nextCursor/hasMore`; `204` for deletes | Matches existing app envelope handling — confirm the shared parser copes with `success` + `code` on errors |

## Next steps

1. Get a reachable dev URL + seeded members (C2, C3).
2. Round 2 to backend: C4–C10 (short list).
3. Start **Phase 0** in the app against the live server (identity + topics), then Phase 1 — see `03_PHASES.md`.
