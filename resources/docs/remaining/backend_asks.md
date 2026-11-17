# Backend: what is done, what is still open

Updated 2026-11-15 after the backend's reply (B-01 … B-15 all answered and live on the dev server; endpoints spot-checked with the dev account). This file now only keeps what is **still open or newly found**. The full contract is in the backend's "Implementation Guide" (2026-11-15).

## Answered and used by the app already
| Item | Status in the app |
|---|---|
| B-01 forgot / reset password | built (device check pending) |
| B-03 delete account, reset deck | built (device check pending); "take a break" waits for a product decision |
| B-05 subscriptions | counters + plan name built; plans/paywall/purchases not built |
| B-06 favourites, compliments history | built (device check pending) |
| B-10 minimum 3 photos | see "Open" B-O4 |
| B-13 QA account cleanup | done (`qa.flow1114` no longer logs in) |
| B-04 `devCode` off in production | cannot be checked from a dev server — please confirm on staging/prod |

## Answered, but the app has not built it yet (not blocked by the backend)
- **B-02 Google/Apple sign-in** — needs SDKs + client IDs (your Firebase work).
- **B-07 settings** (`profileShareLink`, `profileVisibility`, `blockSocialChatRequests`, `blockPhoneContacts`, `language`, `goldBadgeVisible`, `POST /me/blocked-contacts`) — switches wait for your decision (`../PENDING.md`).
- **B-08 notifications** — list, unread count, read, read-all, FCM channels; waits for Firebase and the bell design.
- **B-09 liveness**, **B-11 support tickets**, **B-12 error codes** — to be checked against the app's face-check, Help and error toasts.

## Open questions for the backend (new)
1. **Social sign-in security.** The Google/Apple requests carry `idToken` / `identityToken` **and** `email`, `googleId`, `fullName`. Does the server verify the token signature and take the identity from the token, or does it trust the fields the client sends? If it trusts the fields, anyone can sign in as any email. Please confirm it verifies the token (Google JWKS / Apple JWKS, audience = our client IDs).
2. **Terms / Privacy domain.** The reply says `https://findanikah.app/terms` and `/privacy`; the product owner gave `https://findanikah.com/terms` and `/privacy-policy`, which the app uses now. Which domain is canonical, and do both stay up?
3. **Take a break.** `POST /me/pause {isPaused, durationDays}`: allowed values and maximum for `durationDays`? Is a paused member hidden from other members' decks and Explore? Does the member resume automatically at `pausedUntil`, and how does the app learn the state (field on `/profiles/me`)?
4. **Delete account.** After `DELETE /v1/me`: can the same email sign up again? What happens to open conversations and Feed posts of the deleted member (hidden for others)? Is there a way to restore within a grace period?
5. **Favourites.** Is a second `POST /favorites/:id` for the same member a 409 or an idempotent 200? (The app treats 409 as "already in your favourites".) Does the profile response carry an `isFavorited` flag so the button can show its state without calling `/favorites/check`?
6. **Password rule.** The server accepts 6+ characters; the app requires 8+ with a digit and a letter. Keep the app rule stricter, or align?
7. **Liveness.** Does `POST /profile/face-verification/verify` update `isFaceVerified` synchronously, and is dev auto-approval still on? (A new dev account was marked verified while the app saw no face.)
8. **Payments.** Product IDs for Play/App Store (`gold`? `plus`? `premium`?). The plan list returned "Premium" (999 BDT) while the examples show Plus and Gold. Which plans exist and what are their store product IDs?
9. **App links.** The reply lists only the production Android fingerprint `14:6D:…`. Please add our **debug** fingerprint `56:6E:74:54:53:2B:59:38:DA:47:B2:DF:5A:AE:12:9D:1F:E9:24:B3:1E:B3:17:74:B3:63:85:2B:39:64:17:1E` and tell us when `findanikah.app` resolves. (Apple Team ID: the product owner will send it.)
10. **B-O4 minimum photos.** Confirm the new delete endpoints (`DELETE /v1/profile/me/photos/:id`, `POST /v1/onboarding/profile/images/delete`) are the ones to use; the app still calls `DELETE /v1/onboarding/images?filename=`. Does the old route enforce the same minimum?

## Product-owner items (not backend)
- Firebase project files (owner will add), Android upload keystore (later), Apple Team ID.
- Architecture test rules — to discuss.

## B-16 · Social sign-in must verify the token (found 2026-11-15)
`POST /v1/auth/social` and `/v1/auth/google` on the dev server accept **any** string as `idToken` (`"x"` created a "Google Member" account and returned a session). Before production the server must verify the token. The app now sends a **Google ID token** whose audience is the Firebase project's **web client** (`find-a-nikah`, project number `851419525846`; the web client id is in `google-services.json`, `client_type: 3`). Please verify signature, `aud`, `exp` and `email_verified`, and tell us whether you want the Google ID token (current) or a Firebase Auth ID token instead. Also: a test account named "Google Member" was created by that probe — please remove it.
