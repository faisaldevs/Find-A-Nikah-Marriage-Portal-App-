# Need from backend — Marriage tab (swipe deck, profile, block / report)

**Audience:** the engineer / AI who owns the Find A Nikah backend (Node / Express / MongoDB).
**Written:** 2026-11-12 by the mobile (Flutter) side, after a full review of the Marriage feature.
**Basis:** the endpoints the app calls today plus what was observed on the dev server. Anything not seen live is marked **(unverified)** and phrased as a question.

Companion to `NEED_FROM_BACKEND.md` (chat). Same format: each item has **Today**, **Need**, and **Why / how the app uses it**. `P0` = a visible feature is broken or wasteful, `P1` = needed to finish the feature, `P2` = nice to have.

---

## 0. What the Marriage tab is, in one paragraph

The first tab shows **one profile at a time** (a swipe deck). The user sees a big photo, name/age, a few facts, then scrolls down for the rest of the profile (About me, Faith, Future plans, Interests, Personality, Education, Languages, Bio, verification badges). Four buttons: ✕ pass, ↶ undo, ✉ compliment (a like with a first message), ✓ like. The page footer has Block and Report. A like that the other person already made becomes a **match** and the app offers to open chat.

Endpoints the app uses (all `/v1`):

| Purpose | Call | Status |
|---|---|---|
| Deck | `GET /profiles/cards?limit&minAge&maxAge&country` | works, see §1–§3 |
| Full profile | `GET /profiles/{userId}` (a `profileId` is 404) | works, see §1 |
| Pass / like / undo | `POST /profiles/swipe {action: pass\|like\|undo, targetUserId}` | works, see §4 |
| Compliment | `POST /profiles/swipe {action: "complement", targetUserId, text}` | works, see §4 |
| Block | `POST /blocks/{userId}` | newly wired in the app (§5) |
| Report | `POST /reports {reportedUserId, reason, description?}` | newly wired in the app (§5) |

### Works today — please do not change

- `GET /profiles/cards` returns `{data: {cards, totalReturned, limit, hasMore, viewerGender, targetGender, targetReligion}}`; opposite gender and same religion are applied server-side.
- `minAge` / `maxAge` and `country` (a country **name**, e.g. `Bangladesh`) filter correctly.
- Swiped profiles leave the deck (the app relies on this: after the last card it re-fetches and expects only unseen people).
- `pass` / `like` swipes return `isMatch`. `undo` works with no target and rewinds the last **pass**.
- Image paths are server-relative (`/public/upload/…`); the app prefixes the base URL.

---

## 1. Card payload is too thin → 1 + N requests per deck — **P0**

- **Today:** `GET /profiles/cards` returns the basics only (name, age, country, photos, interests, `aboutMe`, `maritalStatus`, `educationLevel`, `professionTitle`, `faith`, `ethnicity`, `sharedInterests`, `matchScore`, …). The sections below the photo need a **second call per profile**: `GET /profiles/{userId}`.
- These fields exist **only** on the detail call, and the profile screen needs all of them:
  - `marriageIntentions` (`getToknowDuration`, `marriageTimeline`)
  - `aboutYou` (`haveChildren`, `relocateAbroad`)
  - `religiousPractices`, `languages`, `personalityTraits`, `grewUpIn`
  - `faceVerification.isFaceVerified` (drives the "photo verified" badge)
- **Need (pick one):**
  1. **Preferred:** include those fields on each card (they are small), or
  2. a query flag such as `?include=details` on `/profiles/cards`, or
  3. a batch endpoint `GET /profiles?ids=a,b,c` returning detail objects.
- **Why:** the app was making **21 requests per deck** (1 cards + 20 details). It now loads only the first 2 details with the page and fetches the rest one or two cards ahead of the user, which is fine for now but still means a second round-trip on every swipe and a brief "empty sections" flash if the user is fast. Deck size is 20 today.

## 2. No real pagination — **P0**

- **Today:** the only knob is `limit`. `page`, `offset`, `skip`, `cursor` are ignored. The response has `hasMore`, but there is no way to ask for the next batch other than calling the same endpoint again.
- **Question (please confirm):** do already-swiped profiles leave the deck for good? The app assumes **yes** (it re-calls `/profiles/cards` at the end of the deck and shows the empty state if nothing comes back). If that is wrong, people would be shown again.
- **Need:** either
  - document that "call again" is the paging mechanism and that seen / swiped / blocked profiles are excluded, **or**
  - add a `cursor` (opaque) param and return `nextCursor`, so the app can prefetch the next page before the user reaches the end.
- **Why:** with `hasMore: true` the user currently reaches the last card and waits for a reload. The app already prefetches when 1 card is left, but only if it has a cursor to ask with.

## 3. Missing data on cards / profiles — **P0 / P1**

| Field | Today | Impact in the app |
|---|---|---|
| `heightCm` | always `null` on cards (ISS-001: onboarding step 4 does not save it; `PATCH /profiles/me {heightCm}` does) | "Height" chip is hidden on every profile |
| `distanceKm` | always `null`; `location` is `null` for everyone | the distance line under the name never shows |
| Distance filter | not accepted by `/profiles/cards` (no location stored) | the app's "distance" filter has **no effect**; it only sends the country |
| Ethnicity filter | param name/format unknown **(unverified)** | the app's ethnicity filter has **no effect**; it is not sent |
| Involve-family answer | not in any payload | "When would you involve family?" row of the marriage-intentions card is always empty |
| `isPremium` | not in any payload | the gold "Check if you match their filters" banner can never appear |
| `isAgeVerified`, `isIdVerified` | not in any payload (only `faceVerification.isFaceVerified` on detail) | the Age / ID rows of the "Verified profile" card never show |
| `city` / area | `city` is on the card DTO but not confirmed populated | the hero shows country only |
| `age` | can be `null` | app now hides the age instead of showing "0"; please make sure `dateOfBirth` always yields an `age` |

- **Need:** (a) fix ISS-001 so onboarding saves height; (b) store the member's location and return `distanceKm` relative to the viewer; (c) accept a distance filter on `/profiles/cards` and tell us the param name and unit (the old placeholder used `maxDistanceMiles`; kilometres would match `distanceKm`); (d) tell us the ethnicity filter param; (e) add `involveFamily` to `marriageIntentions` (and to the onboarding step that collects it, if that step exists); (f) expose `isPremium`, `isAgeVerified`, `isIdVerified`.
- **Why:** each missing field is a section or filter that is built in the UI but permanently blank or inert.

## 4. Swipe endpoint — behaviour to confirm / tighten — **P1**

`POST /profiles/swipe` is used for four actions.

1. **Spelling:** the compliment action must be `"complement"`; `"compliment"` returns 400. Fine to keep, but please **document it** in the spec (the app comments call this out as a trap).
2. **Empty text:** `{action: "complement", text: ""}` returns **500**. Should be **400** with a message. (The app trims and never sends empty text, so this is only robustness.)
3. **Match on complement — question:** if the target had already liked the viewer, does a `complement` create a match and return `isMatch: true`? Not tried yet. The app handles `isMatch` the same way for `like` and `complement`.
4. **Conversation on complement:** the response already carries `conversationId` / `messageId`. Confirm that (a) the compliment text is delivered as the **first message** in that conversation, and (b) the conversation is visible to **both** users in `GET /conversations` right away (even before a match?), or only after a match. The app will link to chat from this.
5. **Duplicate / repeated swipes — question:** what happens on a second swipe for the same target (pass then like, like then pass, two complements)? The app now prevents these, but the server should answer deterministically (e.g. `409`, or idempotent `200`) rather than creating duplicate rows or messages.
6. **Undo:**
   - Today: rewinds the last **pass** only; a like returns `400 "No previous passed profile to rewind"`.
   - Need: please return the **restored profile's `userId`** (or the full card) in the response so the app does not have to guess which card came back.
   - Question: is undo limited (premium only, N per day)? If yes, return a clear error code so the app can show an upgrade prompt.
7. **Match payload:** please also return the matched member's `fullName` and `photo` (or `matchId` + `conversationId`) so the "It's a match" dialog and the jump to chat do not need an extra call.

## 5. Block and Report from a profile — **P1**

The app now offers **Block** and **Report** at the bottom of every profile.

### Block — `POST /blocks/{userId}`

- **Need, please confirm all of these:**
  - the blocked member **never appears again** in `GET /profiles/cards` for the blocker, **and the blocker never appears in the blocked member's deck** (both directions);
  - blocking someone you **matched** with removes the match / hides the conversation for the blocker (this was observed to work for chat);
  - blocking a profile you have **not** matched with, and that is in your deck, succeeds (no "not in your conversations" style error);
  - blocking someone twice is a **200 / idempotent** (or a clear 409), not a 500.
- Still open from the chat doc §5: document the `GET /blocks` row shape (the app guesses between `blocked` / `blockedUser` / `user` / `target`).

### Report — `POST /reports`

- **Today:** accepts `reportedUserId` (not `targetUserId` as in the spec; see chat doc §1.2). The app sends `{reportedUserId, reason, description?}`.
- **Need:**
  - fix/update the spec so it says `reportedUserId` (or accept both);
  - document the allowed `reason` values and return `400` with a readable message for others. The app sends: `harassment`, `inappropriate_content`, `fake_profile`, `spam`, `other`;
  - confirm that a report **alone** does not hide the profile (the app keeps showing the profile after a report and tells the user to block if they want it gone);
  - a duplicate open report currently answers `"You already have an open report about them"`. Fine; please make it a stable **status code** (409?) as well as text so the app can show it as info instead of an error.
- **Why:** these are safety features. A failed or ignored block on a marriage app is a trust problem, so we want the server behaviour pinned down.

## 6. Matches and gender — **P1** (already ISS-012)

- **Today:** `GET /matches/my-matches` returned a match between two **male** accounts. The deck itself is opposite-gender only, so this probably came from a Feed friendship (`isFriend: true`).
- **Need:** answer whether same-gender matches can come from swiping. If friendships and marriage matches share the endpoint, add a `type` (`marriage` | `friend`) so the Marriage match dialog and the Chat tab can tell them apart.

## 7. Nested `PATCH /profiles/me` wipes data — **P1** (ISS-010, not Marriage-only)

Listed because it **changes what Marriage cards show**: a partial update of `marriageIntentions`, `interests` or `aboutYou` silently deletes the other keys, which empties sections on other people's cards. See `ISSUES.md` ISS-010 / ISS-011.

## 8. Nice to have / parked — **P2**

Not blocking. The app has the UI but the owner has deferred these, so there is **no deadline**; they are listed so the API can be designed with them in mind.

- **Favourite / shortlist** a profile (list, add, remove).
- **Share profile:** a stable public link or deep link per member (the share action currently does nothing).
- **Sort** the deck (e.g. nearest, newest, most active); would be a `sort` param on `/profiles/cards`.
- **Notifications** bell on the Marriage top bar: unread count and list (chat doc §6 covers message notifications).
- **"Check if you match their filters"** (premium): an endpoint that says whether the viewer fits the target's saved filters, and which ones fail.

---

## 9. Suggested order

1. §1 (details on cards) and §2 (pagination answer) — biggest performance and UX win.
2. §5 (block / report behaviour) — safety.
3. §3 (height, distance, involve-family, verification flags) — unblocks UI that already exists.
4. §4 (swipe edge cases and response fields).
5. §6, §7, then §8.

## 10. What the app already did on its side (FYI, no action)

- Loads only the first 2 profile details with the deck and the rest lazily (workaround for §1).
- One compliment per profile; ✕ / ✓ after a compliment do not call the API again.
- A failed swipe is rolled back (the card returns and the swipe is forgotten), so a failed call never corrupts Undo.
- A failed compliment keeps the typed text for a retry.
- Profiles without photos no longer crash the screen; a missing age is hidden.
- Block (with confirmation) and Report (with a reason list) are wired to the endpoints above.
