# Feed — phased rollout

> **Status 2026-11-14:** all phases are built in the app against the live API; see `PROGRESS.md` for what was verified on a device and what is left.

Goal: replace the dummy data **one slice at a time** without breaking the app.
Every phase is a separate backend ask (sections of `NEED_FROM_BACKEND_FEED.md`)
and a separate app change, verified on a real device before the next starts.

## Rules for every phase

1. **Flag per slice.** The dummy source stays registered; the repository picks
   dummy or API per method (a simple switch), so a half-built backend never
   breaks the tab.
2. **Reads before writes.** Posts/comments come from the API first; creating,
   liking and commenting follow.
3. **Optimistic writes** (like, follow) flip at once and roll back on error;
   server counts correct any drift.
4. **Verify on device** with real test accounts (posts, long thread, deleted
   post, blocked author) before ticking `PROGRESS.md`.
5. **Update the docs**: NEED file gets the backend's real answers; PROGRESS gets
   ticked; `02_DECISIONS.md` gets any new decision.

## Phases

| Phase | Backend (NEED §) | App work | "Done" means |
|---|---|---|---|
| **0 — identity + topics** | §1–§4 | `fetchMe`, `fetchTopics` from API; DTOs + mappers; author object with `userId`; `isMe` | chips and compose greeting come from the API |
| **1 — read-only** | §5–§7 | paged posts, post **by id**, comments + replies; id-based routes (`/feed/post/:id`, `/feed/profile/:userId`); pull-to-refresh, load-more; `DateTime` in entities | feed, post and comments are real; opening a post from a link works |
| **2 — create / like / edit / delete posts** | §8–§11 | create (no anonymous), optimistic like, own-post menu (Edit/Delete), "Edited" label | a post made on device A shows on device B |
| **3 — comments** | §12 | real composer, reply, edit, delete, like comment, "more comments", empty state | thread works end to end |
| **4 — profiles, follow, search** | §13–§16 | shared `profile_view` feature; profile page with Feed / Marriage sides and locked-profile treatment; follow; server-side search; remove Groups tab | one profile page used from Feed, Marriage, Explore, Chat |
| **5 — safety + reach** | §17–§19 | report (post/comment/user), block, mute, share links + deep links, Message rule | menu rows do real things |

## Order of the app work inside a phase

1. DTOs + remote data source + repository method (behind the flag).
2. Bloc changes (states for paging/refresh/errors).
3. UI changes.
4. Tests: repository (DTO parsing from a real example response), bloc, widget.
5. Device check, then tick the tracker.

## Explicitly not planned

Realtime counters, notifications, moderation tooling, media upload, groups,
saved posts (see `02_DECISIONS.md`).
