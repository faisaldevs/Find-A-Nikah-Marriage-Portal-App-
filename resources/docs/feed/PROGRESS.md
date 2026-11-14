# Feed — progress tracker

Updated: 2026-11-14 (after integrating the live API). Index: [README.md](README.md) · phases: [03_PHASES.md](03_PHASES.md) · verification: [07_VERIFICATION_LOG.md](07_VERIFICATION_LOG.md) · open backend items: [NEED_FROM_BACKEND_FEED_V2.md](NEED_FROM_BACKEND_FEED_V2.md).

Legend — **Ask** ✅ answered by backend · **App** ✅ built + unit-tested · **Device** ✅ tapped through on a phone against the live dev server · 🟡 partly · ☐ not yet · ➖ n/a.
The dummy data source is gone from the app (kept as `resources/outdated_code/dummy_feed_data_source.dart.txt`).

## Phase 0 — identity + topics

| Item | Ask | App | Device |
|---|---|---|---|
| `GET /v1/me/feed-author` | ✅ | ✅ | ✅ (compose greeting, comment bar) |
| `GET /v1/feed/topics` (+ `canPost`) | ✅ | ✅ | ✅ |

## Phase 1 — read-only

| Item | Ask | App | Device |
|---|---|---|---|
| `GET /v1/feed/posts` (For you / New / topic, cursor paging) | ✅ | ✅ | 🟡 one page only (5 seeded posts) — BE-8 |
| `GET /v1/feed/posts/:id` + id-based routes | ✅ | ✅ | ✅ (open from card) · deep link ☐ |
| `GET …/comments`, `…/replies` | ✅ | ✅ | 🟡 replies shown; "view more replies" not exercised |
| Pull-to-refresh, load-more, `DateTime` + "1 day ago" fix | ➖ | ✅ | 🟡 not exercised |

## Phase 2 — posts: create / like / edit / delete / views

| Item | Ask | App | Device |
|---|---|---|---|
| Create post | ✅ | ✅ | ✅ (BE-2: wrong topic in response, worked around) |
| Like / unlike post (optimistic) | ✅ | ✅ | ✅ (BE-1: seeded counts) |
| Edit post (15 min) / delete post | ✅ | ✅ | ✅ |
| Views (`POST /feed/posts/views`) | ✅ | ✅ | 🟡 sent; dedupe semantics BE-10 |
| Anonymous removed | ➖ | ✅ | ✅ |

## Phase 3 — comments

| Item | Ask | App | Device |
|---|---|---|---|
| Create comment | ✅ | ✅ | ✅ |
| Reply (one level, `mentionUserId`) | ✅ | ✅ | 🟡 tests only |
| Edit / delete comment | ✅ | ✅ | ✅ delete · 🟡 edit tests only |
| Like comment | ✅ | ✅ | 🟡 tests only |
| Empty state, composer modes (new / reply / edit) | ➖ | ✅ | 🟡 |

## Phase 4 — profiles, follow, search

| Item | Ask | App | Device |
|---|---|---|---|
| Feed profile + counters + tabs (Posts · Comments · Likes-own-only) | ✅ | ✅ | ✅ |
| Marriage side from `GET /profiles/:id` + `access` | 🟡 BE-4,5 | ✅ | ✅ full · ☐ locked/partial |
| Follow / unfollow | ✅ | ✅ | ☐ (side effects) |
| Search posts (Feed top bar) | ✅ | ✅ | ✅ |
| Search a member's posts / comments | ✅ | ✅ | 🟡 tests only |
| Followers / following lists, people search UI | ✅ | ☐ | ☐ |
| Shared `profile_view` feature | ➖ | ☐ (a copy lives in the Feed) | ➖ |
| Groups tab removed | ➖ | ✅ | ✅ |

## Phase 5 — safety + reach

| Item | Ask | App | Device |
|---|---|---|---|
| Report post / comment / member | ✅ | ✅ | ☐ BE-7 |
| Block (existing `/v1/blocks/:id`) / mute | ✅ | ✅ | ☐ BE-7 |
| Share (OS sheet with a link) | ✅ | ✅ | 🟡 sheet opens |
| Universal / app links | 🟡 BE-9 | ☐ | ☐ |
| Message from a Feed profile | 🟡 BE-11 | ☐ ("coming soon") | ➖ |
| Notifications bell | ➖ out of v1 | ➖ | ➖ |

## Cross-cutting

| Item | Status |
|---|---|
| Backend `FEED_MOBILE_IMPLEMENTATION_PLAN.md` | ✅ received |
| Round 2 to backend | ✅ written: `NEED_FROM_BACKEND_FEED_V2.md` (not sent yet) |
| Tests | ✅ 103 Feed tests (domain, mappers, repository, blocs, route helper) |
| Offline cache of page 1 | ☐ |
| Loading shimmer / offline banner | ☐ spinner only |
| Localisation | ☐ English strings inline (same as the rest of the app) |
