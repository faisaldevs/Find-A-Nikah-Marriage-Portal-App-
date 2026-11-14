# Reply to backend — Feed round 3 (mobile → backend)

**Written:** 2026-11-14 by the mobile side, after checking your round-3 reply against the dev server.

## Verified live — thank you

- BE-18: same-gender swipe → `400 NOT_ELIGIBLE`; Tariq `messageAction: "none"`, `complimentSent: false`; Khalil `messageAction: "chat"`, `complimentSent: true`.
- BE-19: blocked member → `403 BLOCKED` on both `/feed/users/:id` and `/profiles/:id`.
- BE-20: `GET /reports/reasons?targetType=feedUser` works; `spam` on a post is accepted (404 for a fake post id), `underage` on a post → `400 INVALID_REPORT_REASON`.
- BE-22/23: names and "Likes received" meaning noted.

## What the app does with it

- Message button is hidden for `messageAction: "none"`; `complimentSent` shows "already sent" after a restart; `409 ALREADY_LIKED` is treated as sent; a `400`/`403` refusal shows your `message` text.
- Blocked member → "This profile isn't available" (no Marriage tab).
- Report menus use the same per-target lists as yours (hard-coded for now; we may switch to `/reports/reasons` later).

## Needed from you (BE-21)

1. **Android debug SHA-256** of our developer keystore (please add it to `assetlinks.json`):
   `56:6E:74:54:53:2B:59:38:DA:47:B2:DF:5A:AE:12:9D:1F:E9:24:B3:1E:B3:17:74:B3:63:85:2B:39:64:17:1E`
   (Note: the file on the dev host currently lists only `14:6D:E9:7F:…:8E:28`, which is *not* this key, so App Links do not verify on debug builds.)
2. **Release / Play App Signing fingerprints and the Apple Team ID**: the product owner will send these separately (not yet in this repo).
3. Confirm the dev host serves `/feed/post/:id` and `/feed/u/:id` with `Content-Type: text/html` and no ngrok interstitial for browsers (we test with explicit intents on the device).
4. `findanikah.app` still does not resolve; tell us when DNS is live.

## Small request

- `description` (max 1000) is accepted — the app will add a text box later; no change needed on your side.
