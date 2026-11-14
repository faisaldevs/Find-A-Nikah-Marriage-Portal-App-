# Feed — full-flow device test report

**Date:** 2026-11-14 · **Build:** debug, dev flavor (`lib/flavors/main_dev.dart`, ngrok dev backend) · **Device:** Pixel 5-class, Android, 1080×2340 · **Method:** driven over adb (taps, screenshots, UI dump), plus curl against the same backend for API facts. **Account:** `user@example.com` (male), viewing Tariq (same gender → `partial`) and Khalil (matched → `full`).

Severity: **High** = broken flow or wrong behaviour users will hit · **Med** = wrong/confusing but has a workaround · **Low** = polish.
Owner: **App** or **Backend**.

## Summary

| | Count |
|---|---|
| Flows that passed | 19 |
| App issues | 2 High, 4 Medium, 7 Low |
| Backend issues | 1 High, 2 Low |

Most important: **(1)** deep links leave a dead Back button and cold-start links are ignored, **(2)** the partial-profile screen shows a red "Main photo missing" error and large blank gaps, **(3)** the backend accepts compliments to same-gender members and accepts duplicates, **(4)** there is no way to open your own Feed profile.

---

## Fix status (2026-11-14, same day)

| # | Status |
|---|---|
| A1 | ✅ fixed and re-tested on the device: a link opened from a closed app now lands on the post; Back (in-app and system) goes to the Feed tab instead of doing nothing / closing the app |
| A2 | ✅ fixed and re-tested: locked-photo state in the hero, no stray gaps, no "photo verified" line while the photo is hidden. Hidden fields still show "—" (left as is) |
| A3 | ✅ per-target reason lists (post/comment vs member), checked on the device. Free-text description not added (waiting for the length limit, BE-20) |
| A4 | ✅ own avatar opens your Feed profile; Menu has a "My posts" chip. Checked on the device (Posts · Comments · Likes, no Follow/Message) |
| A5 | ✅ in-session memory in the repository + unit tests. Not re-tested on the device (sending has side effects). A server flag is asked for in BE-18 |
| A6 | 🔧 Feed reads now retry once instead of three times (new optional `maxRetries` request flag, default unchanged for the rest of the app). Error toasts for failed likes/refresh already existed. The new wait time was not measured on the device |
| A7–A13 | open (polish) |
| B1 | ✅ backend fixed (400 `NOT_ELIGIBLE`, 409 `ALREADY_LIKED`, `messageAction: "none"`, `complimentSent`); app uses all of it — checked on the device for Tariq (no Message button) |
| B2 | ✅ rule (b): blocked → 403 on both endpoints; the app shows "This profile isn't available" (checked) |
| B3 | ✅ distinct seed names |
| A14 (new) | ✅ found and fixed during re-test: a second shared link opened while a profile or post is on screen showed the *first* one's data. Pages are now keyed by id |

## Findings

### High

**A1 · App · Deep links: dead Back on warm start, ignored on cold start**
- Steps: `adb shell am start -a VIEW -d https://findanikah.app/feed/u/<userId> com.findanikah.app` while the app runs.
- Result: the profile opens as the *only* screen. The in-app Back button does nothing; the system Back exits the app (landed in an unrelated app).
- Cold start (app killed, `…/feed/post/<id>` link): the link is dropped; the app opens on Marriage.
- Expected: the link opens the target with Feed underneath (Back returns to the Feed tab); cold start routes to the target after splash/redirect.
- Likely cause: link location replaces the stack (no parent route), and the splash/redirect discards the initial location.
- Already listed under "iOS / signed-out" in PENDING; this is broader (signed-in too).

**B1 · Backend · Compliment accepted for ineligible and duplicate targets**
- Steps: open Tariq (same gender, `access.level: partial`, `reason: NOT_ELIGIBLE`) → Message → send. Then leave and reopen the profile and send again.
- Result: both sends answered success ("Compliment sent"). `GET /feed/users/:id` had said `messageAction: "compliment"` for him.
- Expected: `messageAction: "none"` (or a rejection) for same-gender / ineligible members; the swipe endpoint should refuse and a second compliment to the same member should be a 409/400.
- Side effect: two test compliments ("Test compliment from QA", "Second attempt") now sit on Tariq's account; they cannot be removed from the app.

**A2 · App · Partial/locked Marriage profile looks broken**
- Seen on Tariq (partial). The lock notice and blurred sections work, but:
  1. The hero shows red **"Main photo missing"** (an error style) instead of a locked-photo state.
  2. After "Never married" and "My Faith" there are ~400 px blank gaps (hidden/empty sections still take space).
  3. "Profession / Practice / Ethnicity" show "—" (reads as "no data" rather than "hidden").
  4. The card says **"Tariq's main photo has been verified"** while the photo is hidden.
  5. Section names are odd: "About me" holds marital status, lifestyle items sit under "My Faith".
- Expected: locked photo → blurred placeholder with a lock; no gaps; hidden fields masked; no verified-photo claim when the photo is withheld.
- Notes: this screen is a copy of Menu's Preview (`feed_marriage_preview.dart`); 3–5 may exist there too. The shared `profile_view` (parked in PENDING) would fix them in one place.

### Medium

**A3 · App · Report reasons are the wrong list for posts and comments**
- Report on a post offers: Fake profile, Harassment, Inappropriate content, Inappropriate photo, Spam, Underage, Already married, Something else. Backend's post/comment reasons are `inappropriate_content`, `harassment`, `spam`, …
- Fake profile / Underage / Already married / Inappropriate photo are member reasons. No description field.
- Fix: per-target reason lists (post, comment, member); optional description.

**A4 · App · No way to open your own Feed profile**
- Tapping your own avatar on a card does nothing useful (opens the post); Menu has no Feed profile entry.
- So your own Posts / Comments / **Likes** tab (Likes is private to you) cannot be reached.
- Fix: open own profile from the avatar and add a Menu row ("My Feed activity").

**A5 · App · "One compliment per member" guard resets when the page is reopened**
- The guard lives in the profile page's state. Leave and reopen Tariq → Message lets you send again (and the backend accepted it, B1).
- Fix: keep sent userIds for the session (or use a server flag when BE adds one).

**A6 · App · Offline behaviour is slow and quiet**
- Wi-Fi off: the comments list spins ~25–30 s before "No internet connection / Try again" appears (retry + backoff). "Try again" works after reconnect.
- Like while offline: the heart flips, then rolls back after several seconds; I did not catch an error message.
- Pull-to-refresh while offline: no visible error.
- Fix: fail faster for user-initiated reads (fewer/shorter retries), show a toast on rollback and on a failed refresh.

### Low (polish)

| # | Owner | Finding |
|---|---|---|
| A7 | App | Profile stat shows **"1 Likes"** (no singular); same for Posts/Comments |
| A8 | App | Topic label is red in the list and green on the post page (post page uses `kFeedReadMoreGreen`); confirm with design |
| A9 | App | The compose FAB covers the share/views row of the last visible card |
| A10 | App | Post page shows the top-comment preview inside the post card **and** again in the comment list |
| A11 | App | Compliment page: the profile behind it shows through; "Tariq M." overlaps the "Compliment" title |
| A12 | App | Delete confirmation uses the default Material dialog (pink tint), unlike the app's sheets |
| A13 | App | Feed name "Chat T." vs chat room "Chat TesterF" (chat shows the full name; the Feed rule is first name + last initial) |
| B2 | Backend | `GET /feed/users/:id` for a blocked member returns **403 `BLOCKED`**, while `/profiles/:id?source=feed` returns a `locked` profile. The Feed profile page therefore shows an error, never the locked screen, for blocked members. Decide which one is intended |
| B3 | Backend | Seeded members share the display name "Chat T." (Ayat, Khalil), which makes test results ambiguous |

---

## What passed

Verified on the device, in this build:

1. Sign-in persists; Feed tab loads (list, topic chips, real avatars, flags).
2. **Like / unlike** on a seeded post: 1 → 2 → 1, with the heart and count in step (**BE-1 fixed**).
3. Paging: scrolled ~25 swipes, posts kept loading with no visible duplicates or stalls.
4. Post page by tap: post, comment sort, **31 comments** loaded as you scroll, "View 3 more replies" expands to 6 replies, @mentions coloured.
5. Top-comment preview now shows **"6 Replies"** (**BE-3 fixed**).
6. Create post (text + topic "Converts / Reverts"): appears at top, topic correct, "just now".
7. **BE-2** confirmed with curl (create returns the real topic) — the app's "force the chosen topic" override is no longer needed (listed in PENDING).
8. Edit post: topic locked, Save only enabled after a change, "Edited" label appears, text updated.
9. Add comment: post's comment count updated on the list (0 → 1).
10. Delete post: confirm dialog, post removed from the list.
11. Feed search: "tea" returns matching posts; "zzqx" shows "No posts found — Nothing matches".
12. Member profile (Tariq): counters, Posts tab, Feed activity / Marriage switch, stats card.
13. **Partial Marriage profile** (Tariq): lock notice "Part of this profile is hidden / This profile isn't available for you", blurred locked sections with lock icons, bio and lifestyle still shown (see A2 for the problems).
14. **Message → chat** for the matched member (Khalil): opens the existing chat room with history.
15. **Message → Compliment page** for an unmatched member: opens, Submit enabled after typing, success toast, "already sent" toast on the second tap (see A5, B1).
16. Follow / unfollow from the post page (button flips, no error).
17. Post menu: own post = Share / Edit / Delete; other's post = Share / Mute / Block / Report; Report opens the reason sheet (not submitted).
18. Offline error + "Try again" recovery after reconnecting.
19. Warm-start deep link `/feed/u/<id>` opens the profile (but see A1).

## Not covered

- Report, Block and Mute were opened but **not submitted** (shared test data, side effects).
- Comment edit / delete of an existing comment and replying to a comment (new comment only was tested).
- Following from the profile page (only from the post page); followers count after follow.
- Topic chips (Random, Fun & Laughs…) and the "New" tab; pull-to-refresh with a connection.
- Share sheet output; iOS; rate-limit (429) message; 5000-character limit; locked (`PREMIUM_REQUIRED`) UI; the `chat` button for a member whose conversation doesn't exist yet.

## Test data left on the backend

- Two compliments on Tariq (cannot be removed from the app) — see B1.
- My test post and its comment were deleted. Like and follow toggles were put back as found.
- The phone's Wi-Fi was toggled and restored; "stay awake while charging" was turned on for the test (`settings put global stay_on_while_plugged_in 7`).
