# Feed — app-side gaps, bugs and risks

First list 2026-11-14 (before integration); statuses updated after.
☐ open · 🔧 partly · ✅ done.

## Bugs / risks found in the old code

| # | Issue | Status |
|---|---|---|
| B1 | Anonymous posting in UI/bloc/repo | ✅ removed |
| B2 | `state.extra!` routes crash on links / process death | ✅ id-based routes; object only as optional `extra` |
| B3 | Members identified by `handle` | ✅ `userId` everywhere |
| B4 | No paging / refresh; topics + posts failed together; re-tap did nothing | ✅ cursor paging, pull-to-refresh, independent failures. ☐ refresh when returning to the tab after a long time |
| B5 | Local prepend vs server ranking | ✅ inserts from the create response (topic forced to the chosen one, BE-2) |
| B6 | Search only filtered the loaded page | ✅ server search, debounced (a double-search bug found by tests and fixed) |
| B7 | No `isMe` / `isMine` checks | ✅ flags from the API drive buttons and menus |
| B8 | Post made inside another topic filter vanished silently | ✅ toast "Posted in X" |
| B9 | Profile search reloaded the profile | ✅ own `MemberSearchBloc` |
| B10 | "Coming soon" toasts in 5 files | 🔧 only Notifications and Message remain |
| B11 | Time as strings ("1 days ago") | ✅ `DateTime` + `feedTimeAgo` |

## Built

Paging UI, `likedByMe` hearts with rollback, own-post / other-post menus,
real comment composer (new / reply / edit), empty states, report reasons,
block / mute, share (OS sheet), profile switch with real Marriage data and the
locked-profile treatment, remove Groups tab, edit post, views batching.

## Still open

| # | Item | Notes |
|---|---|---|
| M1 | **Locked-profile UI not seen on a device** | BE-4 samples + test accounts received (`from_backend.txt`); mapper tested on the real payloads; open Tariq (`6af81c84…`) from Feed as the main user to see `partial`. A blocked member's Feed profile is 403 `BLOCKED` → failure page, never the locked UI |
| M2 | Message button | ✅ opens the Compliment page (copy of Marriage's), sends `POST /profiles/swipe` `complement`; reply lands in Messages. Not yet seen on a device. BE-11 may add `messageAction` rules |
| M3 | Universal / app links | ✅ Android intent filter (autoVerify) + `/feed/u/:id` → profile redirect. ☐ iOS associated-domains entitlement (Xcode); ☐ signed-out cold start doesn't return to the link after login; not tested on a device |
| M4 | Shared `profile_view` (replace the Preview copy) | see `04_PROFILE_DESIGN.md` |
| M5 | Followers / following lists; people search | backend ready (BE-14/15): `isFollowing` is already parsed on authors; **screens not built** |
| M6 | Page-1 cache + offline banner + shimmer | spinner only today |
| M7 | Show muted state (`isMuted`) | ✅ profile menu reads it; muted-members list (`GET /feed/mutes`) has no screen |
| M8 | Default profile side by entry point | Feed → Feed activity (done); other entry points don't open this page yet |
| M9 | Dev-only: images over ngrok | fine; production URLs differ |
| M10 | Comment / profile / search flows tapped through on a device | see verification log |
| M11 | Localisation | strings inline, like the rest of the app |
| M12 | Thumbnails for avatars | ✅ `FeedAuthor.avatarUrl` uses `photoThumbUrl` |

## Tests

103 Feed tests: domain (time, edit window, paging), mappers (real payload
shapes incl. locked / partial profiles), repository (mode mapping, error
mapping, report bodies), blocs (feed, post detail, profile, search-debounce,
compose / edit), route helper. No widget tests yet.
