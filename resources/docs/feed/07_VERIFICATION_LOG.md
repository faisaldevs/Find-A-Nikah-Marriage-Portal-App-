# Feed — verification log (live dev server, real device)

Run 2026-11-14 on a Pixel 5 against the dev server (`API_BASE_URL` in
`lib/flavors/env/dev.json`, i.e. the ngrok URL — **not** the `localhost:5001`
the backend doc quoted). Test accounts from the backend reply.

## Verified on the device ✅

| Area | What was checked | Result |
|---|---|---|
| Feed list | posts, topic chips, photos, relative times, liked heart, counts | works; photos resolve (server-relative paths → image base) |
| Topics | chips from API; compose picker | works; read-only "Announcements" correctly hidden in the picker |
| Like / unlike | optimistic flip, server count, list follows after returning from the post | works (see BE-1: server recomputed seeded counts) |
| Post by id | open from a card (id route + `extra`), view count +1 on open | works |
| Comments | list, nested replies, `@mention`, "Author" badge, sort sheet present | works |
| Add comment | post, composer clears + unfocuses, post count 5 → 6 | works |
| Own-comment menu | Edit (inside 15 min) + Delete; confirm dialog; delete → count back to 5 | works |
| Create post | topic picker → Post → appears on top | works; BE-2 (wrong topic name in response) worked around |
| Edit post | prefilled, Save disabled until changed, "Edited" label | works |
| Delete post | menu → confirm → removed from list | works |
| Own-post menu | Share · Edit · Delete (no Follow/Block/Report on own post) | works |
| Member profile | header, counts, Follow button, stats, Posts tab, Comments tab (real rows with the post they were on), Likes tab hidden on others | works |
| Marriage side | real `GET /profiles/:userId` (hero, details, about me, intentions) | works for `access.level: full` |
| Feed search | typed "tea" in the top bar → server search narrows to the matching post | works (also: views kept rising 385 → 387 from list/search impressions, BE-10) |

## Verified by automated tests only (not on device)

- Locked / partial / unknown `access` mapping and the "unknown level = partial"
  rule (`feed_marriage_mapper_test.dart`) — **no second account to see it live**.
- Error mapping: 410 → not found, 403 `EDIT_WINDOW_EXPIRED` keeps the server
  message, 429, 409 duplicate report (`feed_repository_impl_test.dart`).
- Paging, search debounce (found + fixed a double-search bug), optimistic
  rollback, reply nesting, count bookkeeping (≈100 bloc tests).

## Not verified yet ❌ (and why)

| Item | Why |
|---|---|
| Locked-profile UI (blur + notice) | needs a viewer who gets `partial`/`locked` (same-gender / blocked / filtered) |
| Report, Block, Mute | have real side effects on shared test data (block would sever the two test accounts) |
| Follow / unfollow | changes the other test account's counters; tests cover it |
| Member-profile search (posts / comments) | covered by tests; not tapped through |
| Reply + comment edit on device | covered by tests; only new-comment/delete were tapped |
| Paging past one page | seed data has 5 posts (page size 20) |
| Pull-to-refresh, offline | not exercised |
| Share sheet, deep links | share sheet opens the OS sheet; universal links not configured (BE-9 / app config) |
