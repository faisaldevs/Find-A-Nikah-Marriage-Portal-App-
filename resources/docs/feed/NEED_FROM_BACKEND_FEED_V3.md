# Need from backend — Feed, round 3 (found while testing on a device)

> **Status 2026-11-14:** answered by the backend (all BE-18…23). Our follow-up and the remaining ask (fingerprints) are in `REPLY_TO_BACKEND_V3.md`.

**Audience:** the engineer / AI who owns the Find A Nikah backend.
**Written:** 2026-11-14 by the mobile (Flutter) side, after a full device test of the Feed against your dev server (`https://…ngrok…/api/v1`) with the accounts from your last reply.
**Context:** all of round 2 works — thank you (counts, topic on create/edit, `topComment.replyCount`, `isMuted`, `messageAction`, `?source=feed`, thumbnails). This round lists only **what is still wrong or missing**. Items are **BE-18 …** (continuing the numbering). `P0` = wrong behaviour that users or data will hit; `P1` = blocks an app fix; `P2` = test-data / nice to have.

Please answer per **BE-n**, with copy-pasted example responses where asked.

---

## P0

### BE-18. A compliment is accepted for ineligible members, and sent twice to the same member

**What happened (dev server, signed in as `user@example.com`, male):**

1. `GET /v1/profiles/6af81c84b412a16c8cad5e62?source=feed` (Tariq, **male**) returns
   `access: { level: "partial", reason: "NOT_ELIGIBLE", unlockable: false, … }` — correct.
2. `GET /v1/feed/users/6af81c84b412a16c8cad5e62` returns `"messageAction": "compliment"` — **should not**, this member is not eligible for me.
3. The app then sends the compliment the same way Marriage does:
   `POST /v1/profiles/swipe` `{ "action": "complement", "targetUserId": "6af81c84b412a16c8cad5e62", "text": "Test compliment from QA" }`
   → **success** (the app showed "Compliment sent").
4. I left the profile and sent a **second** compliment, `"text": "Second attempt"`, to the same member → **success again**.

So both calls were accepted although (a) same-gender members are not eligible and (b) Marriage's own rule is "one compliment per profile; it already counts as a like".

**Need:**
1. `POST /v1/profiles/swipe` with `action: "complement"` (and `like`) must **reject** an ineligible target — same gender, blocked, not discoverable, self — with a 4xx and a stable `code` (e.g. `NOT_ELIGIBLE`, `BLOCKED`). Please tell us the codes.
2. A second `complement`/`like` to the same target must not create a second message: return `409` with a `code` (e.g. `ALREADY_LIKED`) — or an idempotent 200 that says `alreadySent: true`. Tell us which.
3. `GET /v1/feed/users/:userId` must return `messageAction: "none"` when `access.level` is `partial`/`locked` because of `NOT_ELIGIBLE` or `BLOCKED`. (Today it says `"compliment"` for a `NOT_ELIGIBLE` member.)
4. **Add** to `GET /v1/feed/users/:userId` a boolean `complimentSent` (true if the viewer already sent a compliment / like to this member) so the app can show "Compliment sent" after a restart. The app currently remembers this only until the page closes.
5. Please remove (or tell us how to remove) the two test messages now sitting on Tariq's account (`6af81c84b412a16c8cad5e62`), sent by `user@example.com` at about 15:34–15:35 local time on 2026-11-14.

**Why it matters:** members could message people they are not allowed to reach; duplicates spam the recipient.

---

## P1

### BE-19. Blocked member: Feed profile returns 403, Marriage profile returns `locked`

- `GET /v1/feed/users/6af81c85b412a16c8cad5e68` (Zayd, **blocked** by `user@example.com`) →
  `403 { "success": false, "message": "Access restricted", "code": "BLOCKED" }`
- `GET /v1/profiles/6af81c85b412a16c8cad5e68?source=feed` →
  `200` with `access: { level: "locked", reason: "BLOCKED", … }` and `fullName: "Member"`.

The two endpoints disagree. The Feed profile page loads the Feed profile first, so for a blocked member the app shows a plain error page and **never reaches the locked Marriage screen** you described.

**Need one rule, in writing:**
- **(a)** `GET /v1/feed/users/:id` for a blocked member also returns `200` with a minimal profile (`displayName: "Member"`, no photo, counters `0`, `isBlocked: true`, `messageAction: "none"`); the app then shows the locked screen. **Or**
- **(b)** it stays `403 BLOCKED` and the app shows "This profile isn't available" and does not offer a Marriage tab.

We prefer **(b)**: simpler, and a blocked member should disappear. Please confirm, and confirm the same for the case where the **other** member blocked me (do I get the same `BLOCKED` code, or a `404`, so as not to reveal the block?).

### BE-20. Report reasons: one list for every target, but they differ in meaning

`POST /v1/reports` with an unknown reason answers:
`400 INVALID_REPORT_REASON — "Reason must be one of: fake_profile, harassment, inappropriate_content, inappropriate_photo, spam, underage, already_married, other"`.

That is one list for post, comment and member. In the app a **post** report currently offers *Fake profile, Underage, Already married, Inappropriate photo* — which make no sense for a post.

**Need:**
1. Confirm which reasons are valid per `targetType` (`post`, `comment`, `feedUser`). Our proposal:
   - post / comment: `inappropriate_content`, `harassment`, `spam`, `other`
   - member (`feedUser`): `fake_profile`, `harassment`, `inappropriate_photo`, `spam`, `underage`, `already_married`, `other`
2. Reject a reason that does not fit the target (same `INVALID_REPORT_REASON`), **or** say that every reason is accepted for every target (then we only change the app's lists).
3. Optional, P2: `GET /v1/reports/reasons?targetType=post` returning the list and a display label, so the app does not hard-code it.
4. Confirm `description` (free text) length limit — we will add a text field.

### BE-21. Share links: `findanikah.app` does not resolve, and the Android fingerprint

We added the Android intent filter for `https://findanikah.app/feed/post/…` and `/feed/u/…` (autoVerify). Findings:

- `https://findanikah.app/` → **DNS: could not resolve host**. So `https://findanikah.app/.well-known/assetlinks.json` and the web fallback pages cannot be reached from a phone. (`/.well-known/assetlinks.json` and `/apple-app-site-association` do answer on the ngrok dev host.)
- The `assetlinks.json` on the dev host lists **one** `sha256_cert_fingerprints` value (`14:6D:E9:7F:…:8E:28`) for `com.findanikah.app`. App Links verify only for builds signed with a listed key. **Debug builds** and the **Play App Signing** key have different fingerprints.

**Need:**
1. Is `findanikah.app` ours and when will it point at the backend? Who owns DNS?
2. Which keystore is `14:6D:…` — debug, upload, or Play-signing? We need **all three** listed (debug for developers, release, and Play App Signing). Tell us if you want our fingerprints (we can send them).
3. The iOS file: which `appID` (Team ID + bundle id) is in `apple-app-site-association`? We need our Team ID and bundle id to match it.
4. Until the domain is live we test with the dev host; tell us if the same paths work there (`/feed/post/:id`, `/feed/u/:id`) so we can add the dev host to the Android filter for debug builds.

---

## P2

### BE-22. Seed data: members share one display name

Khalil (`@khalil_k2210`), Ayat (`@ayat_n4821`) and the test commenters all show as **"Chat T."**, so feed rows look identical in tests ("who posted this?"). Please give each seeded member a distinct first name + last initial (e.g. "Khalil K.", "Ayat N.", "Tariq M." already is).

### BE-23. (Question) Backend view of "Likes" count on the member profile

`GET /v1/feed/users/6af81c84b412a16c8cad5e62` says `likesCount: 1` for Tariq while his posts show 0–2 likes each. Is `likesCount` "likes **given** by the member" or "likes **received**"? The app labels it "Likes" under the profile stats. Please state which and we will label it accordingly.

---

## What the app sends (for your logs)

- Compliment: `POST /v1/profiles/swipe` body `{ "action": "complement", "targetUserId": "<id>", "text": "<text>" }` (the spelling `complement` is the API's).
- Feed profile: `GET /v1/feed/users/:userId`; Marriage side: `GET /v1/profiles/:userId?source=feed`.
- Report: `POST /v1/reports` — `{targetType: "post", postId, reason, description?}`, `{targetType: "comment", commentId, …}`, `{targetType: "feedUser", targetUserId, reportedUserId, …}`.

## Reply format

Answer per **BE-n** in this file or in `FEED_MOBILE_IMPLEMENTATION_PLAN_V3.md`. Copy-pasted example responses please for BE-18 (rejection + duplicate) and BE-19.
