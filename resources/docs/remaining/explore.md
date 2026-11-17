# Explore tab

Code: `lib/features/explore/`. Checked 2026-11-16 on a Pixel (adb) + code read.

**Done: ~75%.** UI for both tabs is finished and pixel-matched to the mockups.
Seven of eight lists are on the real API (Drift cache-then-network, 12/page,
infinite scroll). What's left is the profile screen, the filters sheet, one
dummy section, the premium CTA and some backend data problems.

## Live vs dummy

| List | Source | Status |
|---|---|---|
| People who liked you | `/v1/likes/who-liked-me` | Live |
| Take a second look | `/v1/profiles/feed/second-look` | Live |
| Visited you | `/v1/profiles/feed/visited-you` | Live |
| Just joined | `/v1/profiles/feed/just-joined` | Live |
| Active near you | `/v1/profiles/feed/near-you` | Live |
| My history → Liked | `/v1/likes/sent` | Live |
| My history → Passed | `/v1/profiles/feed/passed` | Live |
| My history → Favourited | `/v1/favorites` | Live |
| My history → Complimented | `/v1/likes/compliments-sent` | Live |
| Currently available | `/v1/profiles/feed/currently-available` | Live (2026-11-17), needs a device check with seeded members |

## Still to build (App)

| ID | Sev | Item | Where |
|---|---|---|---|
| EXP-10 | 🔴 | **Tapping any card shows "Profile — coming soon"** (verified on device). No profile detail screen/route exists in `lib/`. Every card on both tabs is a dead end. Needs a profile view + like / pass / favourite / compliment actions (the history lists are only useful if these exist). | `explore_page.dart:112,119` |
| EXP-11 | 🔴 | **Filters button shows "Filters — coming soon"** (verified). `DiscoveryFilters` / location filter screen already exists in `features/auth/location` + `features/discovery`; Explore should open it and reload feeds on change (Marriage does this). | `explore_page.dart:101` |
| EXP-12 | 🟠 | **"Currently available" is dummy**: fake names/photos from an online avatar service (needs internet), fixed 300 ms delay. No backend endpoint yet (see EXP-B1). Hide the section until one exists, or keep it behind a flag. | `dummy_explore_data_source.dart`, `explore_repository_impl.dart:49` (`fetchFeed`) |
| EXP-13 | 🟠 | **"See who likes you" crown CTA** only shows "Premium feature — coming soon". Decide: remove while everything is free, or build the paywall. | `explore_page.dart:129` |
| EXP-14 | 🟡 | Dead code: `fetchHistory` + `ExploreHistoryFeed` still wired to the dummy source but the UI no longer reads them. `ExploreBloc` still loads the dummy `feed` for just one section. Remove once EXP-12 is settled (comment out, don't delete — house rule). | `explore_repository_impl.dart:52` |
| EXP-15 | 🟡 | Grey person placeholder is shown for profiles with no photo (most of My history and "Active near you" on the test data). Looks like a loading bug; show initials/blur or a proper no-photo state, and add a shimmer while photos load (old EXP-03). | `explore_photo.dart` |
| EXP-16 | 🟡 | `city` mapper TODO: `near-you` once returned null city; now it returns one, so re-check and drop the fallback. | `explore_feed_mapper.dart:27` |
| EXP-17 | 🟡 | Locked-card handling (`locked: true` → lock overlay, no tap) is implemented but a locked response has never been seen from the API. Untested path. | `explore_lock_overlay.dart` |
| EXP-18 | 🟡 | No empty-state copy per section when a list is empty ("Passed" with 0 shows blank grey). Check the empty and error states on device. | `explore_page.dart` |
| EXP-19 | 🟡 | Hard-coded English strings, no l10n (migration pending app-wide). | all of explore |
| EXP-20 | 🟡 | No tests for `ExploreBloc` / repository / mapper. Fixtures exist in `test/fixtures/explore/`. | `test/` |

## Needs backend

| ID | Item |
|---|---|
| EXP-B1 | Endpoint for "Currently available" (members with a free chat slot). |
| EXP-B2 | `passed` `totalCount` says 3, only 2 returned; pending/low-completeness accounts (completeness 35, unverified) are hidden from `second-look`, `just-joined`, `passed`. See ISS-006. |
| EXP-B3 | Seed data: repeated names/photos ("Maliha" ×4, "Tanijila"), test names ("Zayd Blocked", "Fatima NoPhoto", "Khalil Khan") — clean before demo/store review. Many seeded profiles have no photo (`/public/upload/sample_*.jpg`). |
| EXP-B4 | **My history → Liked and Complimented show the same four people** on the test account (Khalil, Fatima, Maryam, Amina). Check whether `/v1/likes/sent` and `/v1/likes/compliments-sent` really return different data, or one of them echoes the other. |
| EXP-B5 | `like-list`/`sent` return the same people twice (`likes` wrapper + flat `profiles`, different order). App uses flat order + `likedAt` from `likes`. |
| EXP-B6 | Open questions: should matched people still appear in "People who liked you"? Do `who-liked-me` / `sent` hide low-completeness accounts like the other feeds? |
| EXP-B7 | "Active" window looks like ~7 days (empty near-you once `lastActiveAt` is older). Confirm. `faith` and `sect` carry identical values on seeds. |

## Not yet verified on device

Paging past page 1, pull to refresh, offline/cache fallback, and error states.
My history lists were only checked with 1–4 items, so scroll-to-load-more is
untested there.

## Verified on device 2026-11-16

- For you: People who liked you (1), Second look, Visited you (1), Active near you load and render.
- My history: Liked (4), Passed (2), Favourited (1), Complimented (4) all load real data.
- Card tap → toast "Profile — coming soon". Filters → toast "Filters — coming soon". Crown → "Premium feature" toast.
