# Full analysis of remaining task

**Date:** 2026-11-15 · **Build:** debug, dev flavor, dev backend (ngrok) · **Device:** Pixel-class Android 1080×2340, driven over adb + curl.
**Method:** fresh install (`pm clear`) → intro → welcome → login → forgot password → login → full wizard as a new female account → phone → photos → face → location → deck → Explore → Menu → Settings → Start again → Delete account → back to login. Findings from earlier passes (2026-11-14) that are still open are merged in. Per-feature rows live in the other files in this folder; this file is the single ordered list.

Severity: 🔴 release blocker · 🟠 must fix soon · 🟡 polish · ⚪ verify/decide. Owner: App · Backend · Product.

## A. Verified working on the device today (rows removed from the feature files)

Forgot password (email → code → new password → login; old password rejected) · intro carousel · welcome without language/help · Terms/Privacy open in browser · code screen closes keyboard · password-match rule · dev-only login prefill · female wizard to the deck · server accepts photos by API · Location (Country tab) · Marriage deck: Like ("Save"), Pass, Previous · Explore For you and My history (Liked, Complimented list the member; Favourited empty state) · Menu membership card (Basic plan, 10 likes, 1 compliment, 0 likes in filters) · Settings → Start again ("Your deck was refreshed") · Settings → Delete account (signed out, token → 401) · Sign-out/in.

## B. New findings from this pass

| ID | Sev | Owner | Finding |
|---|---|---|---|
| FA-AUTH-02 | 🟡 | App | Intro: "Continue" on page 1 skips pages 2–3 straight to welcome — confirm intended |
| FA-LOC-01 | 🟠 | App | Location → Country tab: list shows only ~10 countries; the search box is clipped under the tabs |
| FA-VER-01 | ⚪ | Backend | Server sets `isFaceVerified: true` after photo upload with no face check (also VER-01). Ask backend (B-09) whether this is dev-only |
| FA-HELP-01 | 🟡 | App | "?" help icons on sign-up/wizard headers still do nothing (owner: info page later, in PENDING) |
| FA-DECK-01 | 🟡 | Backend | Deck card for "Tariq Mutual" has no photo and "—" for Profession/Practice/Ethnicity; Explore "Currently available" shows female profiles to a female account (dummy data source) |
| FA-SET-01 | 🟡 | Product | "Block social chat requests from women" is ON by default for a new **female** account too (SET-06) |
| FA-XC-01 | 🟠 | App | Full test suite: 1 failing test, `layer_boundaries_test` (~60 real import violations). Owner wants to discuss rules before changing |

## Update 2026-11-15 (fix pass)

**Fixed and checked on the phone:** Feed and Menu bells hidden (back with the notifications screen); system Back goes to the first tab, then "Press back again to exit"; sign-up email shows a hint under the field; reset-password field height. **Retracted (my test errors, not bugs):** Favourite row covered by buttons (it is reachable after a full scroll; Favourite, toast and Favourited tab all work), no Reply in chat (swipe-to-reply exists), comment draft left behind (composer moves above the keyboard). Gender/Email/Phone/Language/Passcode/Chaperone/visibility/contacts rows show a "Coming soon" toast (not silent).

## C. Release blockers (🔴)

| ID | Item | Owner |
|---|---|---|
| AUTH-03 | Google / Apple sign-in not built (needs Firebase/client IDs, owner doing later) | App + Backend |
| SET-02 | Membership purchase, plans, paywall, restore not built | App + Product |
| XC-01 | Android release signed with debug key (owner creates keystore later) | App |
| XC-02 / FEED-L1 | Share links: domain `findanikah.app` not resolving, fingerprints, iOS entitlement | App + Backend |
| XC-03 | No push notifications / Firebase / crash reporting (owner adds Firebase) | App + Product |
| BE-01 | `devCode` must be off in production | Backend |
| VER-01 | Face check must be tested by hand with a real face; server auto-verified without a face | App + Backend |

## D. Unfinished features (not built or "coming soon")

- Take a break (needs durations + resume rule) · Safety & Advice content · Share profile (Marriage) · Favourite toggle/remove design · notifications bell (hidden) · Marriage Sort (hidden) · Settings rows Restore purchases, Passcode, Chaperone, Language (unexercised, likely unbuilt) · extra Settings switches (local only; pending list) · Feed: followers/following lists, People search tab, muted list, report text + reasons endpoint · l10n/RTL · accessibility audit · iOS pass · Terms/Privacy/Community screens in-app (links open web only).

## E. Bugs / polish still open from earlier passes

ONB-01 title cut off after keyboard · ONB-02 birth-date menus · ONB-03 height list · ONB-04 progress-bar model · ONB-07 button labels · VER-02 liveness loop with no exit · VER-03 camera rationale · PHO-01 picker Back submits · PHO-02 API allows deleting all photos (backend) · AUTH-05/06 overlay and toast clipping · SUP-02 invalid email gives no message · FEED-05…FEED-11 · XC-04…XC-13 · EXP-02/03 seed data and shimmer.

## F. Not tested (needs a second account/phone or side effects)

- Chat: sending text/voice/images, receipts, typing, calls, unmatch, block, report (needs a real match; no second device available).
- Feed with the new account: post/comment/like/follow/report/block/mute (covered earlier on the male account; not repeated).
- Menu: edit-profile fields, photo replace, Preview tab, Invite, Help tickets, Profiles I've blocked, Block contacts, privacy toggles' persistence.
- Marriage: compliment send from the deck, block/report, match dialog, out-of-profiles state, daily like limit, filters Apply.
- Offline behaviour, permission-denied states, deep links this build, iOS.

## G. Needs from backend

See `backend_asks.md` (B-01…B-15 questions still open) plus: face auto-verify question (FA-VER-01), minimum-photo enforcement (PHO-02), `devCode` off in prod (BE-01), share-link domain/fingerprints (FEED-L1), seed-data cleanup (EXP-02, FA-DECK-01).

## H. Test data / cleanup

- Throwaway `qa.reset1115@example.com` was **deleted through the app** (token now 401).
- `user@example.com` (Ayat) still has seeded Premium; Tariq has old test compliments (feed report B1).
- Phone settings restored: Do Not Disturb off, stay-awake 0.

---

## I. Second pass — two-account test (2026-11-15, later the same day)

Second account `user1@example.com` / `user1234` (= Khalil Khan, already matched with Ayat `user@example.com`). The phone was signed in as user1; Ayat's side was driven through the API (`curl`) so real-time behaviour could be seen.

### Verified working (add to section A)

- **Chat:** list with unread badge (6) → room opens with history; send text (shows Sent → **Seen** when Ayat marked it read); incoming text and **image** arrive in real time; image tap opens a full-screen viewer; long-press → Copy / Delete for me / **Delete for everyone** (message disappears); ⋮ menu → View profile, Mute (toast + muted icon; Unmute), Archive → appears in Archived chats → Restore; Unmatched and Friends tabs show their empty states.
- **Feed (as Khalil):** topic chips (New, Random, All things marriage), create post (topic chosen, appears at top "just now"), edit post ("Edited" label), delete post (confirm dialog), like a post, follow (button → Following), report a post (reason sheet has the 4 post reasons; the post leaves the feed), My posts (own Feed profile).
- **Marriage:** Filters → age slider → Apply (stays applied when reopened); Compliment from the deck (banner with the sent text).
- **Menu:** Edit → Languages saved (English, Bengali); Preview tab renders; Invite → share sheet; Settings → Profiles I've blocked (empty state); Help screen opens.

### New findings

| ID | Sev | Owner | Finding |
|---|---|---|---|
| P2-CHAT-02 | 🟡 | Backend | Seed messages are dated 12:27 / 12:28 "yesterday" and show after 10:51 ones while the phone clock is 12:05 — timestamps in the future or in another time zone. Check server time zone / seed |
| P2-CHAT-03 | ⚪ | App | **Not tested:** voice note, camera, photo library (skipped on purpose, personal photos), Clear chat, Unmatch, Block, Report from the room, calls, typing indicator, offline send/retry |
| P2-MNU-01 | 🟠 | App | **Help screen: all three rows say "Coming soon"** (My support tickets, Report someone, Contact support); the search box opens the website (`findanikah.com/how-it-works`) in a browser. Backend has support tickets (B-xx) |
| P2-MNU-02 | 🟠 | App | **Safety & Advice** chip does nothing (SET-04 confirmed) |
| P2-MNU-03 | 🟡 | App | **Share** chip shares only `https://findanikah.com`, not a link to the member's profile; **Invite** shares the same root with no referral code |
| P2-MNU-04 | 🟠 | App | Settings → **Gender, Email address, Phone number** rows show a chevron but do nothing; **Who can see my marriage profile** and **Block my phone contacts** also do nothing (no toast) |
| P2-MNU-05 | 🟡 | App | Menu header avatar (stock "flowers" photo) differs from the avatar in the bottom-nav Menu icon (a different photo) for the same account — two sources for the same picture |
| P2-MNU-06 | 🟡 | App | Not exercised: Restore purchases, Passcode, Chaperone rows, sharing-link toggle persistence, every other Edit-profile field, photo replace |
| P2-SEED-01 | 🟡 | Backend | `user1` (Khalil) has `gender: female` in Settings/Edit, a male name, `isOnboardingComplete: false`, and a deck full of same-gender profiles; Marriage lists "Tariq Mutual" (male) to him |
| P2-MAR-01 | 🟡 | App | After a successful Compliment the deck stays on the same card with a banner; confirm whether it should advance (compare with Like) |

### Test data left behind (dev backend)

- `user1`: Languages = English + Bengali; follows Tariq M.; liked Tariq's post; reported one of Tariq's posts; compliment "Salam QA compliment" to Tariq Mutual; messages to/from Ayat ("QA_hello from Khalil", "Reply from Ayat via API", an image); age filter 18–43; a comment draft/post on Tariq's thread (unconfirmed).
- The post created and edited by user1 was deleted. Phone settings restored again (Do Not Disturb off, stay-awake 0).
