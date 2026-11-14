# Marriage tab — pending list

**Feature:** `lib/features/marriage/` (first bottom-nav tab, the swipe deck)
**Created:** 2026-11-12, from a full review of the feature
**Backend asks (full detail, written for the backend team):** `resources/docs/outdated/NEED_FROM_BACKEND_MARRIAGE.md`
**Older notes:** `resources/docs/PENDING.md` ("Marriage tab" sections), `resources/docs/MARRIAGE_SCREEN_PROGRESS.md`

## Backend reply received 2026-11-12

Backend answered `NEED_FROM_BACKEND_MARRIAGE.md` (reply + `MARRIAGE_MOBILE_IMPLEMENTATION_PLAN.md`, dev server, their test script "53 passed"). **Their claims are not verified by us yet.** Every B item below is now marked `BACKEND SAYS FIXED — verify live`, then the app change is listed. Do not tick `[x]` until the app change is done *and* checked against the live server (E).

**Round 2 questions sent 2026-11-12:** `resources/docs/NEED_FROM_BACKEND_MARRIAGE_2.md` (§1 ethnicity values, §2 distance rules, §3 gone-target response, §4 duplicate swipes, §5 undo rules, §6 compliment visibility/length, §7 cursor, §8 report reasons, §9 code lists, §10 card data guarantees, §11 test accounts + dev URL, §12 rate limits, §13 leftovers). Answers go into the matching MRG items below; when one arrives, note it in that item's Resolution.

**2026-11-12, later:** backend re-sent the round-1 reply plus a drop-in Flutter architecture (`SwipeCardDto`, `MarriageBloc`, dialogs). **That did not answer any round-2 question** (§1–§13 still open). Only new hint: the cards endpoint seems to also accept `latitude` / `longitude` query params (relevant to round-2 §2: is distance computed from the saved location or from sent coordinates?). Their Flutter code is not adopted (different architecture; their BLoC rollback re-inserts at index 0 and has no undo-stack rollback).

**Do not copy the Dart in their plan.** (1) The app has its own `ProfileCardDto` (json_serializable) — add the new fields there. (2) Their `fromJson` invents values when a field is missing (`country ?? 'Bangladesh'`, `maritalStatus ?? 'never_married'`, `matchScore ?? 60`, `bornMuslim ?? true`, `haveChildren ?? false`, `fullName ?? 'Member'`). The app rule is: missing = `''` / `null` / hidden, never a made-up answer (a default `haveChildren: false` would show "Doesn't have children" for someone who never answered). Keep those fields nullable.

## How to use this file

- One row = one thing to close. IDs are stable (`MRG-001`…) — never renumber; add new ones at the end of their section.
- When something is solved: change `[ ]` to `[x]`, add the date and a one-line "how" in **Resolution**, move nothing.
- Sections: **A** done · **B** waiting on backend · **C** app-side, on hold (needs a decision) · **D** app-side, not started · **E** verification still owed.
- Backend items say **"When fixed, change in the app"** so nobody has to re-investigate.

Legend: `P0` broken/wasteful now · `P1` finish the feature · `P2` nice to have.

---

## A. Done (2026-11-12) — kept for the record

All in `lib/features/marriage/` + tests (`test/features/marriage/`). Not yet verified on a device (see E).

- [x] **MRG-001 Crash with no photos.** `ProfileHero` used `photoUrls.first`. Now `firstOrNull ?? ''`; `ProfilePhoto` shows the placeholder for an empty url.
- [x] **MRG-002 Failed swipe not rolled back.** `MarriageFeedBloc._onSwiped`: on failure the card returns, the `swiped` entry is removed, toast shown. On the last card it no longer advances on failure. Also fixes Undo rewinding the wrong profile.
- [x] **MRG-003 Compliment could be sent repeatedly / mixed with ✕✓.** One per profile (`state.isComplimented`); box hidden, middle button toasts "already sent"; ✕/✓ after a compliment only advance (no 2nd API call).
- [x] **MRG-004 Failed compliment lost the text.** `complimentDrafts` in the state; restored into `ComplimentBox` and `ComplimentPage(initialText)`.
- [x] **MRG-005 Block was "coming soon".** Wired `POST /v1/blocks/{userId}` (confirm dialog → remove profile → next / reload).
- [x] **MRG-006 Report was "coming soon".** Wired `POST /v1/reports` (`reportedUserId`), reason list `kReportReasons`, stays on the profile.
- [x] **MRG-007 Match was only a toast.** Dialog "It's a match!" with "Send a message" → Chat tab (`RoutePaths.chat`).
- [x] **MRG-008 21 requests per deck (1 cards + 20 details).** First `kEagerDetailCount` (2) details with the page; the rest via `MarriageRepository.loadDetails` one or two cards ahead (`MarriageDetailsRequested`).
- [x] **MRG-009 Empty state had no way out.** "Change filters" button.
- [x] **MRG-010 Age "0".** Hero shows the name only when age is null.
- [x] **MRG-011 Copy typo** "Don’t wait , chat" → "Don’t wait, chat".
- [x] **MRG-012 Analyze infos** in the feature (5) fixed; feature is lint-clean.
- [x] **MRG-013 Stale docs.** `PENDING.md` "real /profiles/cards API" entry now says wired.
- [x] **MRG-014 Tests added** (bloc: rollback ×2, one-compliment, draft, block ×2, report, lazy details; repo: eager details, block/report endpoints).
- [x] **MRG-015 Backend request doc written** (`NEED_FROM_BACKEND_MARRIAGE.md`).
- [x] **MRG-016 Backend reply integrated (2026-11-12)** — see the "APP DONE" lines in section B. Tests: rich card with no detail call, old card stays empty, cursor, distance param, match payload, undo id, 409 report. `MRG-008` (lazy loading) is superseded by MRG-020.

---

## B. Waiting on backend

Each item = backend ask (§ in `NEED_FROM_BACKEND_MARRIAGE.md`) → what to change in the app once it ships.

### B1. Data on the deck

- [ ] **MRG-020 · P0 · Detail fields on the card payload** (backend §1)
  - Today: sections below the photo need `GET /profiles/{userId}` per profile (`marriageIntentions`, `aboutYou`, `religiousPractices`, `languages`, `personalityTraits`, `grewUpIn`, `faceVerification`).
  - When fixed, change in the app: read them from the card in `ProfileCardDto` / `ProfileCardMapper.toEntity`; delete `loadDetails`, `_detailOrNull`, `_cards`, `kEagerDetailCount`, `MarriageDetailsRequested`, `_prefetchDetails`, `_detailRequested` in the bloc; drop the 2 detail tests.
  - Resolution: **APP DONE 2026-11-12 (verify live):** card DTO + mapper read all sections from the card; lazy loader, `loadDetails`, `_cards`, `kEagerDetailCount`, `MarriageDetailsRequested` removed; no per-card requests. Mapper still accepts an optional `detail` as a fallback for old servers (can go once the live server is confirmed). `motherTongue` / `nationality` / `lifestyle` not parsed (unused; avoids type surprises). **BACKEND SAYS FIXED** (all detail fields on the card + `GET /profiles/batch?ids=`). App: add `marriageIntentions` (incl. `involveFamily`), `aboutYou`, `religiousPractices`, `languages`, `personalityTraits`, `grewUpIn`, `isFaceVerified`/`isAgeVerified`/`isIdVerified`/`isPremium` to `ProfileCardDto`, nullable; then remove the lazy loader listed above. Also gives `motherTongue`, `nationality`, `lifestyle` (unused so far). Verify a real card has them before deleting the fallback.

- [ ] **MRG-021 · P0 · Real pagination** (backend §2)
  - Today: no cursor/page; `hasMore` ignored; `nextCursor` always null, so the deck only reloads at the very end (visible stall on the last card). Open question: do swiped profiles leave the deck for good?
  - When fixed, change in the app: `MarriageCardsRepositoryImpl.fetchPage` returns the real `nextCursor`; the existing `_onMore` + `prefetchThreshold` then work; revisit `reachedEnd` and the "reload at end" path; keep `deckSize` in sync.
  - Resolution: **APP DONE (verify live):** `cursor` sent, `nextCursor` returned only while `hasMore`, `prefetchThreshold` 3, duplicate cards from a cursor page dropped. **BACKEND SAYS FIXED**: `nextCursor` (string|null) + `hasMore`; also `?excludeIds=`; swiped/blocked excluded in DB (confirms our assumption). App: send `cursor`, return `nextCursor` from `fetchPage`, raise `prefetchThreshold` 1 → 3, keep the reload-at-end path for `nextCursor == null`. Check: cursor is not tied to `limit`/filters (filter change must restart with no cursor — the bloc already does).

- [ ] **MRG-022 · P0 · `heightCm` always null** (backend §3, ISS-001)
  - When fixed: nothing in the app (chip appears by itself). Verify with a card that has a height.
  - Resolution: **BACKEND SAYS FIXED** (onboarding step 4 now saves `heightCm`). Accounts created before the fix still have null — test with a new account. No app change.

- [ ] **MRG-023 · P1 · `distanceKm` / `location` always null** (backend §3)
  - Today: the hero distance line never shows.
  - When fixed: nothing for the line (already conditional). Verify unit (km) matches the label.
  - Resolution: **BACKEND SAYS FIXED** (location saved in onboarding step 11 / `PATCH /profiles/me`; `distanceKm` computed). Viewer needs a saved location too. No app change; verify unit is km.

- [ ] **MRG-024 · P1 · Distance filter not accepted by `/profiles/cards`** (backend §3)
  - Today: the filter screen's distance control does nothing (only country is sent).
  - When fixed: add the param to `MarriageCardsRepositoryImpl.filtersToQuery` (+ test); confirm km vs miles with the filter UI (`DiscoveryFilters.distanceMiles`).
  - Resolution: **APP DONE (verify live):** `maxDistanceMiles` sent in distance mode unless "everywhere". Still ask backend about the name `distanceKm` as a filter. **BACKEND SAYS FIXED**: params `distanceKm` / `maxDistanceKm` / `maxDistanceMiles`. **Ask:** is `distanceKm` as a *filter* the max distance? (same name as the response field). App: send `maxDistanceMiles` (`DiscoveryFilters.distanceMiles`) when mode is distance and not "everywhere", in `filtersToQuery` (+ test).

- [ ] **MRG-025 · P1 · Ethnicity filter param unknown** (backend §3)
  - Today: `DiscoveryFilters.ethnicities` is not sent.
  - When fixed: add to `filtersToQuery` (+ test).
  - Resolution: **BACKEND SAYS FIXED**: `?ethnicity=Bengali,Arab`. **Mismatch to clarify:** the app stores ethnicities as *country codes* and shows country names (`DiscoveryFilters.ethnicities`, `add_filters_page.dart`), and card `ethnicity` values are mapped to flags as country names — "Bengali"/"Arab" are not country names. Need the exact value set (names? demonyms?) before sending. Do not wire until answered.

- [ ] **MRG-026 · P1 · `involveFamily` answer missing** (backend §3)
  - Today: `ProfileCardMapper` hardcodes `involveFamily: ''`; the intentions card shows only 2 of 3 rows.
  - When fixed: add the field to `MarriageIntentionsDto` in `profile_card_dto.dart`, map it in the mapper (+ test "missing values come out empty" no longer asserts `''`).
  - Resolution: **APP DONE (verify live):** `involveFamily` parsed + labelled; intentions card shows 3 rows. Allowed values still not documented. **BACKEND SAYS FIXED** (`marriageIntentions.involveFamily`, string). Ask for the allowed values (codes → labels). App: add field in the DTO, map via `labelFromCode`, intentions card then shows 3 rows; update the mapper test.

- [ ] **MRG-027 · P1 · `isPremium` missing** (backend §3)
  - Today: the gold "Check if you match their filters" banner can never show (`MarriageProfile.isPremium` never set); also the crown badge in the hero.
  - When fixed: map it in the mapper. The button itself is MRG-040 (on hold).
  - Resolution: **APP DONE (verify live):** `isPremium` mapped. **BACKEND SAYS FIXED** (`isPremium` on cards). App: map into `MarriageProfile.isPremium` (crown badge + banner appear). The banner button is still MRG-040.

- [ ] **MRG-028 · P1 · `isAgeVerified` / `isIdVerified` missing** (backend §3)
  - Today: Age / ID rows of the "Verified profile" card never show.
  - When fixed: map them (entity fields exist).
  - Resolution: **APP DONE (verify live):** `isFaceVerified`/`isAgeVerified`/`isIdVerified` mapped. **BACKEND SAYS FIXED** (`isAgeVerified`, `isIdVerified`, `isFaceVerified`). App: map all three; `isPhotoVerified` currently comes from the detail call.

- [ ] **MRG-029 · P2 · `city` / area not confirmed populated** (backend §3)
  - Today: mapper sets `area: ''`.
  - When fixed: map `city` into `area` (hero already joins area + country).
  - Resolution: **APP DONE (verify live):** `city` → `area`; backend still hasn't said whether it is populated. **NOT ADDRESSED** in the reply (`city` still only "optional"). Ask again whether `city` is populated; if yes map to `area`.

- [ ] **MRG-030 · P2 · `age` can be null** (backend §3)
  - App already copes (MRG-010). Backend: always derive from `dateOfBirth`.
  - Resolution: **BACKEND SAYS FIXED** (age computed from `dateOfBirth`, leap years handled). App already hides null age. No change.

### B2. Swipe behaviour (`POST /profiles/swipe`)

- [ ] **MRG-031 · P1 · Complement to someone who already liked me — does it match?** (backend §4.3)
  - Not tried. When answered: if yes, nothing to change (same `isMatch` path); add a test fixture; if no, decide whether to show "they liked you" copy.
  - Resolution: **BACKEND SAYS FIXED**: complement to someone who already liked you returns `isMatch: true`, creates the match and delivers the compliment as first message. No app change; verify with two accounts.

- [ ] **MRG-032 · P1 · Compliment → conversation visible to both?** (backend §4.4)
  - Response already carries `conversationId` / `messageId` (parsed? no — `SwipeResponseDataDto` only reads `isMatch`).
  - When confirmed: parse `conversationId`; extend `SwipeOutcome`; link the match dialog and the compliment strip straight to the chat room (see MRG-045).
  - Resolution: Parsed `conversationId` (see MRG-035); routing to the room still open (MRG-045). **PARTLY ANSWERED**: on a match the response has `matchId`, `conversationId`; compliment text becomes the first message. Still unclear: is the conversation visible to both **before** a match (non-mutual compliment)? App: parse `conversationId`/`messageId` in `SwipeResponseDataDto` (see MRG-035, MRG-045).

- [ ] **MRG-033 · P1 · Repeated swipes on the same target** (backend §4.5)
  - App prevents them now; need a deterministic server answer. When defined: map the code (409 / idempotent 200) so it is not shown as an error.
  - Resolution: **NOT ANSWERED** (duplicate swipe on the same target: 409 or idempotent?). Ask again. App prevents duplicates meanwhile.

- [ ] **MRG-034 · P1 · Undo should return the restored profile** (backend §4.6)
  - Today the app trusts its local list (`_onUndo` finds the previous profile by index). When fixed: use the returned id; handle "undo limited / premium" error code with an upgrade prompt.
  - Resolution: **APP DONE (verify live):** `rewoundUserId` decides which card comes back; local fallback kept. Returned `card` is not used (our deck still holds it). **BACKEND SAYS FIXED**: undo returns `action`, `rewoundUserId`, `userId`, and the full `card`. **Not answered:** undo limits / premium gating. App: use `rewoundUserId` to find the card (insert the returned `card` at the *previous index*, not at 0 as their sample does — our deck keeps the already-swiped cards behind the index); keep local fallback.

- [ ] **MRG-035 · P1 · Match payload lacks name/photo/ids** (backend §4.7)
  - When fixed: show the other person's photo in the match dialog; use `matchId`/`conversationId` to open chat.
  - Resolution: **APP DONE (verify live):** match dialog shows their photo + name; `conversationId` parsed into `SwipeOutcome`. Dialog still opens the Chat *tab* (MRG-045). **BACKEND SAYS FIXED**: `matchedUser {_id, userId, fullName, photoUrl, age, gender}`, `matchId`, `conversationId`. App: extend `SwipeOutcome` (+ `SwipeResponseDataDto`), show their photo/name in the match dialog (`photoUrl` may be server-relative → `resolveImageUrl`).

- [ ] **MRG-036 · P2 · `complement` with empty text → 500** (backend §4.2)
  - App never sends empty text. Backend should return 400. No app change.
  - Resolution: **BACKEND SAYS FIXED** (empty text → 400 "Compliment text is required"). No app change.

- [ ] **MRG-037 · P2 · Document the `"complement"` spelling** (backend §4.1)
  - No app change.
  - Resolution: **BACKEND SAYS FIXED**: both `"compliment"` and `"complement"` accepted. App keeps `"complement"` (works either way); optionally switch to `"compliment"` and update the enum comment in `swipe.dart`.

### B3. Block / report guarantees

- [ ] **MRG-038 · P1 · Block hides both ways + works for non-matched profiles + idempotent** (backend §5)
  - Verify on device with two accounts: blocker never sees the blocked in the deck and vice-versa; blocking twice does not error.
  - When confirmed: nothing to change, or handle the error codes found.
  - Resolution: **BACKEND SAYS FIXED**: both-way deck exclusion, works without a match, idempotent 200, body `targetUserId` or `:userId`. App already uses `POST /blocks/{userId}`. Verify with two accounts (E, MRG-073).

- [ ] **MRG-039 · P1 · Report: spec says `targetUserId`, server wants `reportedUserId`; document reasons; stable code for duplicate report** (backend §5, chat doc §1.2)
  - App already sends `reportedUserId` and the 5 reasons. When duplicate becomes a 409: show it as info, not error (`showFailureToast` path in `marriage_page.dart`).
  - Resolution: **APP DONE (verify live):** 409 → info toast "Already reported"; after a report the user is asked "Block them too?". **BACKEND SAYS FIXED**: accepts `reportedUserId` / `targetUserId` / `userId`; duplicate → `409`. **Full reason list not given** (only "includes `inappropriate_content`"; plan lists harassment, fake_profile, spam, other). App: handle `409` as an info toast (today it shows the generic error toast — still to do in `marriage_page.dart`); after a report, offer "Block them too?" (their suggestion).

- [ ] **MRG-040a · P2 · `GET /blocks` row shape undocumented** (chat doc §5, shared with messaging)
  - Affects the blocked list, not this tab. Tracked here because a blocked profile must also vanish from the deck.
  - Resolution: **BACKEND SAYS FIXED**: `GET /blocks` returns `blockedUserId` populated (aliases `blockedUser`, `user`, `target`). Messaging feature can drop its guessing (separate task, chat side).

### B4. Other backend

- [ ] **MRG-041 · P1 · Same-gender "match"** (backend §6, ISS-012)
  - When answered: if friendships share `my-matches`, filter by `type` when showing the Marriage match dialog.
  - Resolution: **BACKEND SAYS FIXED**: `my-matches` rows carry `type` / `matchType` = `marriage` | `friend`. App: Chat tab (messaging) can filter; Marriage match dialog needs nothing.

- [ ] **MRG-042 · P1 · Nested `PATCH /profiles/me` wipes sibling keys** (backend §7, ISS-010 / ISS-011)
  - Empties sections on other people's cards. App rule: always send whole nested objects. When fixed: nothing to change.
  - Resolution: **BACKEND SAYS FIXED** (deep merge of `marriageIntentions`, `aboutYou`, `interests`, `lifestyle`, `location`). Keep the "send whole nested object" rule until verified; then relax. Update `ISSUES.md` ISS-010 / ISS-011 after verifying (ISS-011 unknown-keys-ignored is **not** mentioned as fixed).

- [ ] **MRG-043 · P2 · Backend support for parked features** (backend §8): favourites, share link, sort param, notifications, "match their filters" check. See C.
  - Resolution: **NOT ANSWERED**: favourites, share link, sort, notifications, "match their filters" check — parked, nothing in the reply.

---

## C. App-side, on hold (owner said "skip" / "hold" on 2026-11-12 — to discuss)

- [ ] **MRG-044 · Share profile** — toast "Share profile — coming soon" (`profile_scroll.dart`). Kept as is for now. Needs a deep link to share (backend §8) or a text-only share via a new dependency (`share_plus`).
- [ ] **MRG-040 · "Check if you match their filters"** (premium banner) — toast only. Needs MRG-027 + a backend check endpoint.
- [ ] **MRG-046 · Favourite** — toast only; footer uses the **share** icon, reference uses a star (☆). Needs decision: local shortlist vs API.
- [ ] **MRG-047 · Sort ⇅** (top bar) — toast only. No design/API.
- [ ] **MRG-048 · Notifications 🔔** (top bar) — toast only. No design/API.
- [ ] **MRG-049 · `/profile/:id` shared profile screen** — the profile widgets still live in `features/marriage/presentation/widgets/`; Explore etc. can't open the same layout. Plan: `resources/docs/PENDING.md` → "profile_view" section (`profileBuilder` slot on `MarriagePage`, move widgets to their own feature, Marriage passes member id only).

## D. App-side, not started (can be done any time)

- [ ] **MRG-045 · Match / compliment → open the exact chat room** (today: Chat tab). Needs `conversationId` (MRG-032) and the chat peer; routing needs a `core/` seam because features can't import each other (peer travels as go_router `extra`, see `RoutePaths.chatRoom`).
- [ ] **MRG-050 · Pull-to-refresh on the deck.** Skipped on purpose: it would fight the profile scroll and could reset the deck by accident. Decide the gesture (e.g. a refresh icon in the empty/last-card state only).
- [ ] **MRG-051 · Report reasons duplicated** — `kReportReasons` (marriage domain) and `_reportReasons` in `chat_room_page.dart`. Move to `core/` when a third place needs it.
- [ ] **MRG-052 · Report with a description** — API accepts `description`; the sheet only sends the reason.
- [ ] **MRG-053 · Dead code from the old feed** — `MarriageRemoteDataSource` (+ `.g`), `MarriageRepositoryImpl`, `DummyMarriageDataSource`, `marriage_profile_dto` (+ `.g`), `test/features/marriage/data/marriage_data_test.dart`. Project rule is comment out, don't delete → decide before removing. (`MarriageRepositoryImpl` was updated for the new interface only so it still compiles.)
- [ ] **MRG-054 · ~60 lines of commented-out layout code** in `view/marriage_page.dart` and `widgets/profile_scroll.dart` (kept per the comment-out rule). Prune when the layout is final.
- [ ] **MRG-055 · No widget tests** for the page, hero, compliment box, block/report dialogs. Bloc + repo are covered.
- [ ] **MRG-056 · Filter change resets the deck** to profile 0 and drops swipe/compliment state (by design for now). Revisit if users change filters often.
- [ ] **MRG-057 · Details flash in** for fast swipers (cards past the 2nd load their sections after the photo). Goes away with MRG-020.
- [ ] **MRG-058 · Unblock** — no way to undo a block from the Marriage tab (the blocked list lives in chat). Fine unless a "Blocked members" screen outside chat is added.
- [ ] **MRG-059 · Compliment send failure on the Compliment page** — text is kept (MRG-004) but the page has already closed; consider keeping the page open until the server answers.
- [ ] **MRG-060 · Pixel-match leftovers** from `MARRIAGE_SCREEN_PROGRESS.md` / `PENDING.md`: bio wrap, card internals. Re-check against Figma 1157:5788 / 1157:6375.

## E. Verification still owed (nothing above was run on a device)

- [ ] **MRG-070** Run the app on a device/emulator with the real API: swipe ✕/✓, undo after a pass, undo after a like (toast), last card → reload / empty state.
- [ ] **MRG-071** Turn the network off mid-swipe: card must come back with the error toast, then ✕ works again.
- [ ] **MRG-072** Compliment: send, try again (blocked), fail once (text restored), match on complement.
- [ ] **MRG-073** Block with two accounts (see MRG-038); Report with each reason.
- [ ] **MRG-074** Profile with no photos (create one) — placeholder, no crash.
- [ ] **MRG-075** Fast swiping: sections of cards 3+ fill in; no repeated detail calls (check logs).
- [ ] **MRG-076** Match dialog "Send a message" lands on the Chat tab.
- [ ] **MRG-077** `PENDING.md` still mentions a **TEMP-VERIFY** design size in `main.dart`; `lib/main.dart` was not found by grep on 2026-11-12 — confirm it is gone and delete that note.
- [ ] **MRG-078** Two unrelated tests fail on this branch with or without the marriage changes: `test/architecture/layer_boundaries_test.dart` (looks for a `packages/` folder) and one in `test/router/app_redirect_test.dart` ("new user … → get started"). Not Marriage, but they hide regressions in `flutter test`.

---

## Summary counts (update when closing items)

| Section | Total | Closed |
|---|---|---|
| A Done | 16 | 16 |
| B Backend | 24 | 0 |
| C On hold | 6 | 0 |
| D Not started | 12 | 0 |
| E Verification | 9 | 0 |
