# Issues

Bugs and wrong data found while testing the app. Newest first. Each issue
has an owner (**Backend** or **App**), a status, and how it was found.
When an issue is fixed, set its status to **Fixed** with the date, or
delete it.

Scoped feature work that hasn't started belongs in `PENDING.md`, not here.

| ID | Issue | Owner | Severity | Status |
|---|---|---|---|---|
| [ISS-012](#iss-012--a-match-between-two-male-accounts) | A match between two male accounts | Backend | Medium | Question |
| [ISS-010](#iss-010--patch-profilesme-wipes-the-rest-of-some-nested-groups) | `PATCH /profiles/me` wipes the rest of some nested groups | Backend | High | Open |
| [ISS-011](#iss-011--patch-profilesme-silently-ignores-unknown-fields) | `PATCH /profiles/me` silently ignores unknown fields | Backend | Low | Open |
| [ISS-001](#iss-001--height-is-not-saved) | Height is not saved | Backend | High | Open |
| [ISS-002](#iss-002--nationality-grew-up-in-and-ethnicity-are-not-saved) | Nationality, grew up in and ethnicity are not saved | Backend | High | Open (known since audit #33) |
| [ISS-003](#iss-003--unverified-accounts-show-as-face-verified) | Unverified accounts show as face verified | Backend | High | Open |
| [ISS-004](#iss-004--the-app-never-tells-the-server-onboarding-is-finished) | The app never tells the server onboarding is finished | App | Medium | Open, unblocked |
| [ISS-005](#iss-005--no-screen-asks-for-languages) | No screen asks for languages | App + design | Medium | Open, needs decision |
| [ISS-006](#iss-006--a-full-profile-scores-only-35-completeness-and-stays-pending) | A full profile scores only 35% completeness and stays `pending` | Backend | Medium | Question |
| [ISS-007](#iss-007--prays-5-times-a-day-is-saved-as-prays-on-time) | "Prays 5 times a day" is saved as "Prays on time" | Backend + App | Low | Open |
| [ISS-008](#iss-008--height-options-are-invisible-to-screen-readers) | Height options are invisible to screen readers | App | Low | Open |
| [ISS-009](#iss-009--profile-response-has-duplicate-label-named-keys) | Profile response has duplicate label-named keys | Backend | Low | Open |

---

## How these were found (2026-10-31)

A new account was created on the phone (Pixel 5) against the dev backend
and taken through the whole onboarding flow: sign-up, profile wizard
(steps 4–7), phone code, 3 photos, location. Face verification was skipped
by turning the `faceVerification` flag off for that run only (since turned
back on). The saved data was then read back with `GET /v1/profiles/me`
and in Menu → Edit profile → Preview, which marks empty fields in red in
debug builds.

Test account: `qa.profile.1031@example.com`, user id
`6ae5c5adcfd25d09c8dd2c30`, female, 28, Bangladesh, dentist. The password
is kept out of the repo.

---

## ISS-010 — `PATCH /profiles/me` wipes the rest of some nested groups

**Owner:** Backend · **Severity:** High · **Status:** Open (found
2026-10-31 on the test account; the data was restored straight after)

- **Steps:** `PATCH /v1/profiles/me` with only part of a nested object,
  e.g. `{"marriageIntentions": {"getToknowDuration": "3-4_months"}}`.
- **Actual:** the behaviour depends on the group:

  | Group | Partial PATCH | Result |
  |---|---|---|
  | `lifestyle` | `{smoking}` only | Merged: the other keys are kept |
  | `marriageIntentions` | `{getToknowDuration}` only | **Replaced:** `marriageTimeline` deleted |
  | `interests` | `{sports}` only | **Replaced:** cultural, food & drinks, fashion and activities emptied |
  | `aboutYou` | not tested | Unknown |

- **Impact:** an edit screen that sends only the changed key silently
  deletes the member's other answers.
- **App rule until fixed:** always send the whole nested object (built
  from the current profile plus the change).
- **Ask backend:** make nested updates consistent (merge), or document
  that each nested object must be sent whole.

## ISS-012 — A match between two male accounts

**Owner:** Backend · **Severity:** Medium · **Status:** Question

- **Found:** 2026-11-02, sample `GET /v1/matches/my-matches` response
  pasted by the owner.
- **Actual:** the only match has `users` "Dev Team v2 Tested" and "QA
  Tester", both `gender: "male"`, with `isMatch: true` and
  `isFriend: true`, `status: "active"`.
- **Ask backend:** can two people of the same gender match? If `isFriend`
  covers Feed friendships, say whether `my-matches` should return only
  marriage matches (opposite gender), or add a filter. The Chat tab's
  Matches panel shows every row it gets today.

## ISS-011 — `PATCH /profiles/me` silently ignores unknown fields

**Owner:** Backend · **Severity:** Low · **Status:** Open

- **Actual:** `{"notAField": 1}` returns 200 "Profile updated
  successfully" and changes nothing. A misspelled key (e.g. `heightCM`)
  would look saved but be lost. Invalid *values* are rejected properly
  (`{"maritalStatus": "not_a_real_status"}` → 400 "… is not valid").
- **Ask backend:** reject unknown keys with a 400.
- **App rule:** build PATCH bodies from one typed patch class, never from
  hand-written maps.

## ISS-001 — Height is not saved

**Owner:** Backend · **Severity:** High · **Status:** Open

- **Update 2026-10-31:** `PATCH /v1/profiles/me {"heightCm": 160}` saves
  it (and raised completeness 35 → 45), so only the onboarding step-4
  endpoint drops it. Fix step 4. The app could also PATCH it right after
  step 4 as a stopgap. The test account now has 160 cm set this way.

- **Steps:** Onboarding → Height → pick 160 cm → Continue (saves step 4).
- **Expected:** `profile.heightCm = 160`.
- **Actual:** `GET /v1/profiles/me` returns `heightCm: null`. Preview shows
  "Height missing". Other accounts show the same: "Dev Team v2 Tested" and
  the Marriage cards (already noted in `PENDING.md`) all have no height.
- **App side checked:** the Height page saves the value into the draft
  before submitting (`height_page.dart` `_continue`), and the step-4
  request sends it as `heightCm` (`onboarding_step_request.dart`).
- **Not yet proven:** the actual request body wasn't captured, because the
  temporary API logging has been removed. To confirm, log one step-4
  request, or ask the backend whether step 4 accepts `heightCm`.
- **Impact:** height is empty on every profile and card.

## ISS-002 — Nationality, grew up in and ethnicity are not saved

**Owner:** Backend · **Severity:** High · **Status:** Open (first reported
as audit #33; still happening on 2026-10-31)

- **Update 2026-10-31:** `PATCH /v1/profiles/me` with the same three lists
  saves them, so only the onboarding step-4 endpoint drops them. The test
  account now has `["Bangladesh"]` in all three, set this way.

- **Steps:** Onboarding → Nationality, Where did you grow up, Ethnicity →
  pick Bangladesh on each → continue to the end of Basics (step 4).
- **Expected:** `nationality`, `grewUpIn` and `ethnicity` each contain
  `"Bangladesh"`.
- **Actual:** all three come back as `[]`. Preview shows "Nationality
  missing", "Grew up in missing" and "Ethnicity missing".
- **App side:** all three are sent as lists of full country names in the
  step-4 request (`onboarding_step_request.dart`).
- **Impact:** the Ethnicity field on the profile card is empty, and the AI
  bio can't use where the person grew up.

## ISS-003 — Unverified accounts show as face verified

**Owner:** Backend · **Severity:** High · **Status:** Open

- **Steps:** finish onboarding without submitting face verification.
- **Expected:** `profile.faceVerification.isFaceVerified = false`.
- **Actual:** the server returns `isFaceVerified: true` straight away,
  while `user.isVerified` is false/null. No face images were ever sent for
  this account.
- **What the user sees:** Menu and Edit profile → Preview show the blue
  verified badge next to the name and a "Verified profile — main photo has
  been verified" card. The app reads the badge from
  `profile.faceVerification.isFaceVerified`
  (`menu_repository_impl.dart:63`).
- **Impact:** anyone can look verified without verifying, which undermines
  the trust signal.
- **Ask backend:** default `isFaceVerified` to `false` and set it only after
  a successful `/v1/profile/face-verification`. Also confirm which field
  is the single source of truth (`isFaceVerified` or `user.isVerified`).

## ISS-004 — The app never tells the server onboarding is finished

**Owner:** App · **Severity:** Medium · **Status:** Open, unblocked

- **Actual:** when Location is saved (step 11, server step 12), the app
  treats onboarding as finished on the device only. It never calls
  `POST /v1/onboarding/complete`, so the server keeps
  `isOnboardingComplete: false` and completeness `0`.
- **Checked 2026-10-31:** calling `POST /v1/onboarding/complete` on the
  test account returned 200. After that, status showed
  `isCompleted: true`, `currentStep: 27`, completeness 35. The endpoint
  works now.
- **Fix:** revert the client-side workaround. The exact list is in
  `PENDING.md`, under "Revert client-side 'step 12 = onboarding complete'
  once the API is fixed".
- **Impact:** until this is fixed, every new account is incomplete on the
  server. That probably keeps it out of other users' feeds (see ISS-006).

## ISS-005 — No screen asks for languages

**Owner:** App + design · **Severity:** Medium · **Status:** Open, needs
decision

- **Actual:** the Language chips on Basic information are commented out
  (`basic_information_page.dart:233`). They were removed to match Figma,
  which has no language field there. `draft.languages` stays empty, so
  step 4 always sends `languages: []`, and Preview shows "Languages
  missing".
- **Decision needed:** where languages should be collected. Options are
  bringing the field back on Basic information, adding a separate wizard
  page (needs a design), or collecting it only in Edit profile later.

## ISS-006 — A full profile scores only 35% completeness and stays `pending`

**Owner:** Backend · **Severity:** Medium · **Status:** Question

- **Actual:** after every wizard section, 3 photos and location, the test
  account has completeness `35` and `profileStatus: "pending"`.
  Completeness was `0` until `/v1/onboarding/complete` was called.
- **Why it matters:** in Explore testing, accounts with completeness 35
  that aren't verified were left out of `just-joined`, `second-look` and
  `passed` (see the Explore section of `PENDING.md`). New members may be
  invisible to everyone else.
- **Ask backend:**
  - How is completeness calculated? Which fields are still missing?
  - What moves `profileStatus` from `pending` to active, and who does it?
  - Which completeness or status level makes a profile show up in feeds?

## ISS-007 — "Prays 5 times a day" is saved as "Prays on time"

**Owner:** Backend + App · **Severity:** Low · **Status:** Open

- **Steps:** Onboarding → Faith → pick "Prays 5 times a day".
- **Actual:** saved as `prays_on_time`, so the profile shows "Prays on
  time". Both labels map to the same token on purpose
  (`onboarding_option_tokens.dart:76-77`), because the backend has no
  separate value for it.
- **Fix:** the backend adds a token for "Prays 5 times a day" (e.g.
  `prays_five_times`), or the app drops one of the two labels.

## ISS-008 — Height options are invisible to screen readers

**Owner:** App · **Severity:** Low · **Status:** Open

- **Actual:** the rows on the Height page (`122cm • 4' 0"` …) don't appear
  in the accessibility tree. Only the title and Continue do. Every other
  wizard page exposes its options. TalkBack users can't pick a height, and
  UI automation has to tap by screen position.
- **Fix:** give each row a semantic label (e.g. wrap it in `Semantics` or
  use a widget that provides one), like the other option lists.

## ISS-009 — Profile response has duplicate label-named keys

**Owner:** Backend · **Severity:** Low · **Status:** Open

- **Actual:** `GET /v1/profiles/me` returns both the normal keys and extra
  keys named like display labels, at both `data` and `data.profile`
  level: `ethnicity` / `Ethnicity`, `nationality` / `Nationality`,
  `grewUpIn` / `"Grew up in"` (with spaces).
- **Ask backend:** remove the label-named duplicates. Keys with spaces and
  capitals are easy to misuse, and they make it unclear which field is
  the real one.

## ISS-010 — Chat socket: `typing` / `stop_typing` are never relayed

**Owner:** Backend · **Severity:** Medium · **Status:** Open

- **Actual (checked 2026-11-11, two accounts, both sockets in the room):**
  A emits `typing` with `{conversationId}`, with `{conversationId,
  toUserId}` and with `{to}`. B never receives a `typing` event, and no
  error or ack comes back. The app's typing bubble therefore never shows.
- **Ask backend:** relay `typing` / `stop_typing` to the other participant
  as `{ conversationId, from }` (spec §4.6), or say what the handler needs.

## ISS-011 — Chat socket: per-message `message:delivered` / `message:seen` aren't broadcast

**Owner:** Backend · **Severity:** Medium · **Status:** Open

- **Actual:** `message:delivered {messageId}` and `message:seen
  {messageId}` get `{success:true}` acks but the sender receives nothing,
  so the ticks don't change. The conversation-level forms
  (`{conversationId}`) and `PATCH /conversations/:id/seen` do broadcast.
- **App does for now:** uses the conversation-level forms only.
- **Related quirks:** the receipt goes to *both* users, and the payloads
  disagree on meaning: `message:seen` has `seenBy` (the reader) while
  `message:delivered` has `deliveredTo` (the sender, i.e. not the
  recipient). The app filters on these. Receipts carry no `messageId` at
  conversation level, so the app marks every own message up to the
  timestamp. Ask: send `messageId`s (or a `deliveredBy`) and only to the
  sender.

## ISS-012 — Chat socket: message events go to both participants, twice

**Owner:** Backend · **Severity:** Low · **Status:** Open

- **Actual:** a REST send makes the *sender and the receiver* each get
  `message:sent` and `message:new` for the same message (four events).
  The spec says `message:sent` is only for the sender's other devices.
- **App does for now:** dedupes by message `_id` and decides mine/theirs
  from `senderId`, so it is harmless, but it is extra traffic.

## ISS-013 — First chat request after an idle period fails on the emulator

**Owner:** Unclear (emulator network, possibly app) · **Severity:** Medium ·
**Status:** Needs a check on a real device

- **Seen (2026-11-12, Android emulator, dev ngrok server):** the first send
  after ~45 s idle hangs, then shows "No internet connection" / "Not sent";
  tapping the failed bubble re-sends it fine. Delete-for-me took ~10 s to
  show. An Archive tap and a Report did nothing visible. The same requests
  worked on the physical Pixel 5.
- **Probable cause: the emulator, not the app.** At the time `ping 8.8.8.8`
  from the emulator had 66 % loss, DNS lookups failed, and it had both a
  Wi-Fi and an LTE network flipping the default route (status bar went
  Wi-Fi → 5G → Wi-Fi "?"). Android destroyed the app's TCP sockets at the
  same moments.
- **Still worth a look:** `RetryInterceptor` never retries a POST/PATCH (by
  design), so one dropped connection surfaces as "Not sent" / a silent no-op.
  Confirm on a real phone with a network switch (Wi-Fi ↔ mobile) before
  changing anything. Also, a failed Archive / Report showed no error toast
  that I could catch.

## ISS-014 — Chat list row ticks never update

**Owner:** App · **Severity:** Low · **Status:** Open

- **Actual:** the row's last-message tick stays a single grey ✓ ("sent") even
  when the other side has the message Delivered / Seen (checked on the phone:
  the male's room had it Seen, the row still showed ✓).
- **Why:** the row's `lastMessage` is rebuilt from the list preview /
  `_bumpPreview` with the default status, and receipts only update the open
  thread's messages.

## ISS-015 — "Last seen" is wrong while the peer is online

**Owner:** Backend + App · **Severity:** Low · **Status:** Open

- **Actual:** the chat header says "Last seen 1h ago" for a peer who is
  connected on the socket and chatting right now (`lastActiveAt` isn't
  refreshed by socket activity, and there is no presence event).
- **Ask backend:** touch `lastActiveAt` on socket connect / message, or send a
  presence event so the app can show "Online".

## ISS-016 — Archived chat's partner shows up again under "Matches"

**Owner:** App · **Severity:** Low · **Status:** Open (needs a decision)

- **Seen (2026-11-12, physical phone):** after Archive, the slot is freed and
  the partner appears in the Matches panel ("Matches (1)") as if they had
  never been chatted with; restoring moves them back to "Matches (0)".
  Picking them from Matches would open the archived thread.
- **Decide:** should archived partners be hidden from the panel until
  restored?

## ISS-017 — Report: wrong request key, and no visible result

**Owner:** App (fixed) + Backend doc · **Severity:** Medium · **Status:** Fixed in app

- Reports failed with "Member not found": the live `POST /v1/reports` wants
  `reportedUserId`, but `MESSAGE_AND_CHAT_API_SPEC.md` says `targetUserId`
  (a request with `targetUserId` returns 404). The app now sends
  `reportedUserId`. **Ask backend:** fix the spec, or accept both.
- Failures now show their message as a toast; success shows "Thanks, we'll
  review this report".
