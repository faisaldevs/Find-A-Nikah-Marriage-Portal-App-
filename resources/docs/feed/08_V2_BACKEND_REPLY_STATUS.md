# Feed — backend v2 reply: what the app did with it

Source: `from_backend.txt` (2026-11-14). Checked against the dev server with curl.

| BE | Backend | App |
|---|---|---|
| 1 counts | fixed | nothing to do; recheck like/unlike on device |
| 2 topic on create/edit | fixed | app still forces the chosen topic (harmless; can be removed) |
| 3 topComment | `replyCount`, `likedByMe` added | ☐ not yet shown in the card preview |
| 4 locked samples | delivered + 3 test accounts | ✅ mapper tests use the real payloads (partial, locked BLOCKED, locked PREMIUM_REQUIRED) |
| 5 source | `?source=feed` | ✅ sent on `GET /profiles/:id` |
| 6 deletes | cascades confirmed | ✅ matches the app's counts |
| 7 mute/block state | `isMuted`, `isBlocked` on `/feed/users/:id`, `GET /feed/mutes` | ✅ mute state read; ☐ mutes list screen |
| 8 paging data | 65+ posts seeded | ☐ page-2 / load-more not yet checked on device |
| 9 links | assetlinks + AASA + web fallback | ✅ Android filter + `/feed/u/` route; ☐ iOS entitlement |
| 10 views | 1-hour dedupe, no self views | nothing to do |
| 11 messageAction | `chat / compliment / upgrade / none` | ✅ chat → opens chat room (router builds the peer); compliment → Compliment page; upgrade → "coming soon" toast; none → button hidden |
| 12 verified | harmonised | nothing to do |
| 13 thumbs | `photoThumbUrl` | ✅ avatars use it |
| 14/15 people, followers | ready, `isFollowing` on items | ☐ screens not built |
| 16 rate limit | 60/h, 429 `RATE_LIMITED` | existing 429 mapping shows the generic message; ☐ friendlier text |
| 17 mentions | server parses `@handle` | nothing to do |

Notes: the backend doc quotes `localhost:5001`; the app keeps using the dev URL in `lib/flavors/env/dev.json`.
A blocked member's `GET /feed/users/:id` is 403 `BLOCKED`.
