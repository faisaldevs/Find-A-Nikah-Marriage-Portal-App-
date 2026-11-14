# Need from backend — Marriage tab, round 2 (follow-up questions)

**Audience:** the engineer / AI who owns the Find A Nikah backend.
**Written:** 2026-11-12 by the mobile (Flutter) side, **after** integrating your reply to `NEED_FROM_BACKEND_MARRIAGE.md` (round 1) and `MARRIAGE_MOBILE_IMPLEMENTATION_PLAN.md`.
**Status of round 1:** thank you — the app now reads every section from the card (no `GET /profiles/:userId` per card), uses `cursor` / `hasMore`, `maxDistanceMiles`, `matchedUser` + `conversationId`, `rewoundUserId`, and handles `409` on duplicate reports. We have **not yet verified it all against the live server**; this document lists only what is **still unknown or missing**. Nothing here blocks the app from working today, but each item either hides a feature, shows wrong text, or risks a bad edge case.

How to read it: each item has **Today** (what we know / do), **Need** (the answer or change), **Why** (what the app does with it). `P0` = blocks a feature from working correctly, `P1` = wrong or unclear behaviour in an edge case, `P2` = nice to have. Please answer in this file or in a reply with the same item numbers (§1, §2 …).

---

## P0 — blocks a feature

### §1. Ethnicity filter: what values does it accept?

- **Today:** your reply says `GET /profiles/cards?ethnicity=Bengali,Arab` (comma-separated, matches `profile.ethnicity`). In the app the user picks ethnicities from the **country list** (e.g. Bangladesh, Pakistan, Egypt) and we store **country codes** (`BD`, `PK`, `EG`). Card values for `ethnicity` are also shown with a **country flag**, which only works if the value is a country name. "Bengali" and "Arab" are not countries, so we can't tell what a card's `ethnicity` actually contains.
- **Need:**
  1. The **exact set of allowed values** for `profile.ethnicity` (is it country names like `"Bangladesh"`, demonyms like `"Bengali"`, or free text?). A list, an enum, or a link to the onboarding step that writes it.
  2. For the filter: do we send the **same strings** that appear on cards? Is matching **exact** or case-insensitive? Is it **any-of** (OR) when several are given?
  3. What does the filter do for profiles that have **no** ethnicity set — excluded or included?
- **Why:** the ethnicity filter is built in the app but **not sent** at all until we know the values; right now choosing ethnicities on the filter screen changes nothing. Wrong values would return an empty deck.

### §2. Distance filter: exact contract and the "no location" cases

- **Today:** the app sends `maxDistanceMiles=<n>` when the user picks a distance (not when they pick "everywhere"). Your reply also lists `distanceKm` and `maxDistanceKm` as accepted params, but `distanceKm` is also a **response field** name, so it is unclear whether `?distanceKm=50` means "maximum 50 km" or something else.
- **Need, please confirm:**
  1. `maxDistanceMiles` and `maxDistanceKm` are the only filter names we should use (and `distanceKm` as a filter is just an alias, or is it?).
  2. **Viewer has no saved location** (never completed onboarding step 11): is the distance filter ignored, or does the deck come back empty, or is it a `400`? We need to know so we can show "Add your location to filter by distance" instead of an empty screen.
  3. **A card owner has no saved location:** are they excluded when a distance filter is active, or included with `distanceKm: null`?
  4. `distanceKm` in the response: kilometres, straight line, rounded to how many decimals? Does it ever expose a precise position? (We show "12 km away"-style text; please confirm it is safe to show as is.)
- **Why:** without 2 and 3 a user with a distance filter can silently get an empty or incomplete deck, and we can't explain why.

### §3. Cards for deleted, deactivated or blocked members during a session

- **Today:** the deck is fetched in pages of 20 and prefetched, so a card can be in the app for minutes. In that time its owner can delete the account, deactivate, or block the viewer. If the viewer then swipes that card, we don't know what the server answers; the app treats any error as "swipe failed", **puts the card back** and shows an error toast, so the user can be stuck on a card that will never work.
- **Need:** a **specific, documented response** for swiping (and for block / report) on a target that is gone or no longer allowed, e.g. `404` (or `410`) with a stable `code`/`message` such as `TARGET_UNAVAILABLE`. Please tell us what it actually returns today.
- **Why:** with a clear code we can silently drop that card and move to the next one instead of showing an error.

---

## P1 — unclear or wrong in edge cases

### §4. Repeated swipes on the same target (still unanswered from round 1 §4.5)

- **Today:** the app prevents it (one compliment per profile, no swipe after a compliment), but the cases can still happen across devices or after a crash/restart: pass then like, like then pass, two compliments, like on someone you already matched.
- **Need:** what does the server do for each? Idempotent `200` with the existing state, or `409`? Does a second `like` ever create a duplicate match or a duplicate first message?
- **Why:** so the app maps the answer to "ignore silently" instead of showing an error.

### §5. Undo rules

- **Today:** undo works with no target and returns `rewoundUserId` (+ `card`). Unknown to us:
- **Need:**
  1. Can the user undo **several times in a row** (pass A, pass B, undo, undo → both come back?) or only the single last pass?
  2. Is there a **limit** (per day / premium only)? If so, which status and `code` is returned, so we can show an upgrade prompt rather than a generic error?
  3. What is the response when there is **nothing to rewind** (currently `400 "No previous passed profile to rewind"`)? Please keep that message **stable** (or add a `code`).
  4. If the passed profile has since been **blocked / deleted**, what does undo return?
- **Why:** the Undo button's enabled state, the error copy and a possible premium upsell depend on it. The app currently keeps its own local history and uses `rewoundUserId` only to confirm which card returned.

### §6. Compliment to someone who has **not** liked you back

- **Today (from your reply):** a compliment to someone who already liked you matches and delivers the text as the first message. For a **non-mutual** compliment we know it counts as a like and the profile leaves the deck.
- **Need:**
  1. Does the compliment create a **conversation** visible to the receiver right away (e.g. as a message request), or is the text held until a match? If it is visible, is it in the normal `GET /conversations` list or somewhere else?
  2. Does it appear on the receiver's **"People who liked you"** with the text, as our earlier notes suggest?
  3. Is the compliment text **limited in length** (min/max)? The app currently has no limit; please give one so we can show a counter and avoid a `400` after typing a long message.
  4. Is the response for a non-mutual compliment still `conversationId` / `messageId` (we parse them)?
- **Why:** the app shows the sent text above the photo with a double tick; we want to describe correctly what happens next ("They'll see it when…") and enforce the length.

### §7. Cursor details

- **Today:** we send `cursor` back as given and drop it when `hasMore` is false. We restart with **no** cursor whenever the user changes filters.
- **Need:**
  1. Is a cursor **tied to the filters/limit** it was issued with (so a stale cursor + new filters is an error or gives odd results)? Does it **expire**?
  2. **Maximum `limit`** the server accepts (we send 20).
  3. **Deck order:** by match score, last active, random? Is the order **stable** between calls? (If ordering is random per call, a reload at the end of the deck can show people in a different order — fine, but we want to know.)
  4. Can a cursor page contain a profile **already returned** earlier in the session (the app now de-duplicates, but we'd like to know whether that is expected)?
- **Why:** correctness of prefetching and of the "restart on filter change" behaviour.

### §8. Reports: full list of reasons and limits

- **Today:** the app offers 5 reasons: `harassment`, `inappropriate_content`, `fake_profile`, `spam`, `other` (your reply confirmed `inappropriate_content` and says the others are allowed). Duplicate → `409` (handled).
- **Need:** the **complete** allowed list (any extras such as `underage`, `scam`, `impersonation`?), the allowed length of `description`, and the error shape for an unknown reason (`400` with a readable `message`?).
- **Why:** to match the list exactly and show copy for any additional reasons.

### §9. Display values (codes → text)

- **Today:** the profile shows values like `after_getting_to_know`, `3-4_months`, `never_married`, `actively_practising`, `undergraduate`. The app turns a code into text with a generic rule (underscores → spaces, first letter upper-case), which gives e.g. "After getting to know" and "3-4 months". That is acceptable only if the codes are readable.
- **Need:** the **full list of allowed codes** for: `marriageIntentions.involveFamily` (new), `getToknowDuration`, `marriageTimeline`, `maritalStatus`, `educationLevel`, `religiousPractices`, `faith`, `lifestyle` (if you want us to show it), and `ethnicity` (see §1). If any code is not self-explanatory, please give the intended display text.
- **Why:** so the intentions card and chips read correctly; a code we've never seen would show as awkward text.

### §10. Data guarantees on cards

- **Need, please confirm:**
  1. **Every card has at least one photo.** If a member can have zero photos, tell us — the app now shows a placeholder, but profiles with no photo in a marriage deck are probably not wanted.
  2. `images` / `primaryPhoto` / `matchedUser.photoUrl` are always **server-relative** (`/public/upload/…`), or can they be absolute URLs (CDN)? The app handles both; we want to know if the image base URL can ever change.
  3. `city` — is it populated for most members? (The app now shows "City, Country" in the hero when present.)
  4. `grewUpIn` and `ethnicity` entries: **country names** (e.g. `"Bangladesh"`)? We look up their flags by name, so a code like `"BD"` would show no flag.
  5. `isPremium` means the **card owner** is premium (not the viewer)? (We show a crown on their photo and a "Check if you match their filters" banner.)
  6. Please make `matchScore`, `completeness` and `age` always present numbers, or tell us when they can be missing (we hide anything missing and never invent defaults).
- **Why:** each one is a place where the UI would otherwise silently show the wrong thing or nothing.

---

## P2 — useful, not urgent

### §11. Test data on the dev server

- **Need:** a dev account set (or a seed script) with these profiles so we can verify the whole screen: (a) a fully filled member (every section, 5+ photos, premium, all verification flags), (b) a minimal member (name, 1 photo, nothing else), (c) a member with **no photos** (if possible), (d) a member with no height, no location, (e) two accounts that already like each other (to test match + compliment-match), (f) a member who will be blocked by the viewer.
- **Also please confirm** that the ngrok URL in the app's dev config (`https://…ngrok-free.app/api`) points at the **updated** server (your reply mentions `localhost:5001`). If it doesn't, the new card fields won't appear in the app.
- **Why:** we have not been able to run the new flow end to end; this is what unblocks the remaining checks in our pending list.

### §12. Errors and rate limits

- **Need:** confirm that every `4xx` response has a JSON `message` we can show, and tell us whether swiping has a **rate limit** (`429`) — the app sends swipes one at a time in order but can send them quickly (several per second when the user taps fast). If there is a limit, return `Retry-After` so we can back off.
- **Why:** to avoid showing an error toast for ordinary fast swiping.

### §13. Still open from round 1 (no answer received)

- **ISS-011:** `PATCH /profiles/me` still ignores unknown keys with `200` (not mentioned as fixed). Please reject unknown keys with `400`, or confirm it's intentional.
- **Block (`POST /blocks/{userId}`)** — the app uses the **path** form; please confirm it is supported long-term and what the **response body** is (we ignore it today).
- **Parked features** (no deadline, listed so the API can be designed with them in mind): favourites / shortlist, a shareable profile link, deck sorting, the notifications bell, and an endpoint that tells a viewer whether they match a premium member's filters ("which ones fail").

---

## Summary of what we need, in order

1. §1 ethnicity values, §2 distance rules, §3 "target gone" response — these decide whether two filters and swipe errors work.
2. §11 test accounts + the dev URL — lets us verify everything above.
3. §4–§8 behaviour answers (duplicate swipes, undo, compliment visibility, cursor, report reasons).
4. §9–§10 code lists and data guarantees.
5. §12, §13.
