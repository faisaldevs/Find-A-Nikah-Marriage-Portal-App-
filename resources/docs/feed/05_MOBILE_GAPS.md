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
| M1 | **Locked-profile UI not seen on a device** | needs BE-4 sample + a test viewer |
| M2 | Message button | "coming soon" until BE-11; then route to chat / compliment via the router, not a feature import |
| M3 | Universal / app links + deep-link routing from a cold start | needs BE-9 + Android/iOS config |
| M4 | Shared `profile_view` (replace the Preview copy) | see `04_PROFILE_DESIGN.md` |
| M5 | Followers / following lists; people search | counts are not tappable yet (BE-14, BE-15) |
| M6 | Page-1 cache + offline banner + shimmer | spinner only today |
| M7 | Show muted state (`isMuted`) | BE-7 |
| M8 | Default profile side by entry point | Feed → Feed activity (done); other entry points don't open this page yet |
| M9 | Dev-only: images over ngrok | fine; production URLs differ |
| M10 | Comment / profile / search flows tapped through on a device | see verification log |
| M11 | Localisation | strings inline, like the rest of the app |
| M12 | Thumbnails for avatars | BE-13 |

## Tests

103 Feed tests: domain (time, edit window, paging), mappers (real payload
shapes incl. locked / partial profiles), repository (mode mapping, error
mapping, report bodies), blocs (feed, post detail, profile, search-debounce,
compose / edit), route helper. No widget tests yet.
