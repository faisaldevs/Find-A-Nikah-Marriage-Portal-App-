# Need from backend: Google sign-in, push notifications, chat push

**Audience:** the engineer who owns the Find A Nikah backend.
**Written:** 2026-11-16 by the mobile (Flutter) side. Android and iOS.
**Firebase project:** `find-a-nikah` (project number `851419525846`). Cloud Messaging API (V1) enabled, legacy API off.
**Bundle / package id:** `com.findanikah.app` (Android and iOS).

This replaces nothing: it gathers every open backend dependency for **Google sign-in**, **push notifications** and **chat push** in one place and adds what the earlier docs did not cover. Related earlier docs: `PUSH_NOTIFICATIONS_BACKEND.md` (payload detail), `remaining/backend_asks.md` (B-02, B-08, B-16), `NEED_FROM_BACKEND_CHAT_ROUND3.md` §6, §8.

Priority: **P0** blocks release, **P1** blocks the feature, **P2** polish.

---

## 0. What the app does today (so you can test against it)

| Area | App behaviour |
|---|---|
| Google sign-in | `google_sign_in` v7 gets a **Google ID token**; the app calls `POST /v1/auth/social` with body `{ "provider": "google", "idToken": "<jwt>" }` and nothing else. The token audience is the Firebase project's **web client id** (`client_type: 3` in `google-services.json`). |
| Session | Response must give the same session shape as email login: access token, refresh token, user id, onboarding-complete flag. |
| Push token | After every sign-in and on every token refresh: `POST /v1/devices { "token": "<FCM token>", "platform": "android" \| "ios" }`. On sign-out (while still signed in): `DELETE /v1/devices/:token`. Failures are ignored by the app. |
| Chat push | App expects **data-only** FCM messages with `type: "message"` and draws the notification itself. |
| Other push | App expects normal notification messages with `data.type`. |
| Tap routing | `message` → chat room (opened from `senderId`, `senderName`, `senderPhoto`); `match` → Chat tab; `compliment` / `like` → Explore; any type with `postId` → that post; with `userId` → that Feed profile. |
| Socket | Socket.IO, websocket only, JWT in handshake `auth.token`. Chat push is only a fallback for when the app is not connected. |

---

## 1. Google sign-in

### 1.1 Verify the token — **P0 (security)**
Dev server currently accepts **any string** as `idToken` (B-16: `"x"` created a "Google Member" account). Before production, on `POST /v1/auth/social` and `POST /v1/auth/google` (same behaviour on both):

1. Verify the signature against Google's keys (`https://www.googleapis.com/oauth2/v3/certs`), cache the keys.
2. `iss` is `https://accounts.google.com` or `accounts.google.com`.
3. `aud` equals the project's **web client id** (find it in `android/app/google-services.json`, `client_type: 3`, or Firebase console → Authentication → Sign-in method → Google → Web client ID). **Also accept the iOS client id** (see 1.4) if you verify per platform. Tell us the exact list of accepted audiences.
4. `exp` not passed.
5. `email_verified` is `true`; reject otherwise.
6. Take identity (`sub`, `email`, `name`, `picture`) **only from the verified token**. The app sends no other fields and the server must ignore any it receives.
7. Return `401` (not `500`) for a bad or expired token, with a message the app can show.

### 1.2 Account linking and new users — **P1**
Please define and confirm:

- Google email matches an existing email/password account → link to it (sign in as that user) or reject? We recommend **link**, because the email is verified by Google.
- Key accounts by Google `sub`, not only by email, so an email change at Google does not create a duplicate.
- A brand-new Google user: create the account, return `onboardingComplete: false` so the app sends them into the profile wizard. Prefill name from the token if you store it.
- Password for a Google-only account: what does "forgot password" / login with that email and a password return? (we suggest a clear error: "This account uses Google sign-in".)
- Same email arriving from Apple later (see §5): same user or separate?

### 1.3 Cleanup — **P2**
Remove the test account "Google Member" created by the `"x"` token probe.

### 1.4 What we need handed over — **P0 for iOS**
- Confirm **which token** you verify. We assumed the **Google ID token** (decided with the product owner on 2026-11-16). If you would rather verify a **Firebase Auth ID token**, tell us now: it needs an app change.
- iOS needs an **iOS OAuth client** in the same Google Cloud / Firebase project. Today `GoogleService-Info.plist` has no `CLIENT_ID` / `REVERSED_CLIENT_ID`. Whoever owns the Firebase console: register the iOS app `com.findanikah.app`, enable Google sign-in, and re-download `GoogleService-Info.plist`. Send it to us.
- **Release SHA-1 and SHA-256** (upload key and **Play App Signing** key) added to the Android app in Firebase, then a fresh `google-services.json`. Without this Google sign-in fails in any Play build. Current file only lists debug-style fingerprints.
- Is the backend using the same Google Cloud project for its own checks? If it has a separate client id, tell us.

### 1.5 Sign-out behaviour — **P2**
Does `POST /v1/auth/logout` (or equivalent) revoke the refresh token for social users too? The app will also clear the Google account locally.

---

## 2. Device tokens (`/v1/devices`)

Already used by the app. Please confirm each:

1. `POST /v1/devices { token, platform }` where `platform` is `"android"` or `"ios"`. Which route is canonical? `APP_STATUS.md` once listed `POST /v1/me/devices`; the app calls **`/v1/devices`**. Keep `/v1/devices` working.
2. **Idempotent**: sending the same token twice for the same user is a `200`/`204`, not an error.
3. **Token moves between users** (logout then login on one phone): the token is reassigned to the new user and removed from the old one. Never delivered to two users.
4. A user can have **several devices** at once; push goes to all of them.
5. `DELETE /v1/devices/:token` works while signed in and is a success even if the token is already gone. Token goes in the URL path; FCM tokens contain `:` and `-` and `_`, so make sure the route accepts them.
6. Delete tokens that FCM reports as `UNREGISTERED` / `registration-token-not-registered` / `INVALID_ARGUMENT`.
7. Remove all of a user's tokens on account deletion and on "sign out everywhere".
8. Optional but useful: store `lastSeenAt` on the device row and prune tokens unused for ~60 days.

---

## 3. Sending push (FCM) — **P1**

### 3.1 Credentials
- Service-account key for `find-a-nikah` as a **server secret** (never in git). Send with the Firebase Admin SDK or `https://fcm.googleapis.com/v1/projects/find-a-nikah/messages:send`.
- Tell us where the secret lives and who rotates it.

### 3.2 Chat message: data-only, high priority
Same payload as `PUSH_NOTIFICATIONS_BACKEND.md` §2A. No `notification` block. Every `data` value is a **string**.

**Android**
```json
{
  "token": "<device token>",
  "android": { "priority": "high", "ttl": "2419200s" },
  "data": {
    "type": "message",
    "conversationId": "…", "senderId": "…",
    "senderName": "Amina", "senderPhoto": "/public/upload/….jpg",
    "title": "Amina", "body": "Salaam, how are you?"
  }
}
```

**iOS** needs a different shape, because iOS does not wake the app for a data-only message reliably and does not run our code to draw it. For iOS devices send an **alert push**:
```json
{
  "token": "<device token>",
  "notification": { "title": "Amina", "body": "Salaam, how are you?" },
  "apns": {
    "headers": { "apns-priority": "10", "apns-push-type": "alert" },
    "payload": { "aps": { "sound": "default", "thread-id": "<conversationId>", "mutable-content": 1 } }
  },
  "data": { "type": "message", "conversationId": "…", "senderId": "…", "senderName": "Amina", "senderPhoto": "/public/upload/….jpg" }
}
```
`thread-id` groups messages per conversation. Pick the shape by the device's `platform` field. **Question for you:** can the backend send per-platform shapes? If not, tell us and we will adapt.

- `body`: message text; photo → `"Photo"`; voice note → `"Voice message"`; **if the recipient turned off message preview (`messagePreview:false`), send `"New message"`**.
- Message types you add later (video, file, call line) need a body string too; list them.

### 3.3 Other notifications
Normal notification messages with a `data.type`. Android also needs `android.notification.channel_id`; iOS needs the `apns` block (sound, optional `badge`).

| `type` | When | Extra `data` | Android channel | App opens |
|---|---|---|---|---|
| `message` | new chat message | `conversationId`, `senderId`, `senderName`, `senderPhoto` | `channel_chat` (app-drawn) | chat |
| `match` | new match | `userId` | `channel_matches` | Chat tab |
| `compliment` | compliment received | `userId` | `channel_matches` | Explore |
| `like` | someone liked you | `userId` | `channel_matches` | Explore |
| `feed_comment` / `feed_like` / `feed_reply` | Feed activity | `postId` | `channel_activity` | that post |
| `feed_follow` | new follower | `userId` | `channel_activity` | Feed profile |

Please list **every other `type`** you will send (call, request, unmatch, gold, verification result, etc.). Unknown types still show but only open the app.

### 3.4 Rules (confirm each)
1. **Muted conversation** (`isMuted:true`): no push; unread count still increments.
2. **Recipient has the room open on a connected socket**: no push.
3. **Recipient online on the socket but in another screen**: send or not? Please state. The app already shows its own in-app alert from the socket for this case, so we prefer **no push when the user has an active socket**, and push only if no socket is connected.
4. **Settings respected**: `messageNotifications:false` → no chat push at all. Per-type switches if you add them.
5. **Blocked / unmatched / paused / deleted** users send no push to the other side.
6. **Collapse**: add `android.collapse_key` / `apns-collapse-id` for `match` and activity types so repeated ones replace each other. Chat is not collapsed (the app stacks the last 6 per conversation).
7. **Rate limit**: cap per user per minute and say what it is.
8. **TTL**: chat `2419200s` (4 weeks), other types shorter (1–2 days) so a stale "someone liked you" does not arrive a week late. Tell us what you use.
9. **No private data** in the payload beyond what the notification shows (no email, phone, location).
10. **Badge count (iOS)**: send `aps.badge` = total unread chat count, or tell us you will not.

### 3.5 iOS prerequisites — **P0 for iOS push**
- **APNs Auth Key (.p8)** from the Apple Developer account, uploaded to Firebase console → Project settings → Cloud Messaging → Apple app configuration (with Key ID and Team ID). Without this no iOS push is delivered. Who owns the Apple Developer account?
- Tell us whether you want **sandbox and production** handled (Firebase handles both with one .p8 key).

### 3.6 Test deliverables — **P1**
Please send, to a test token we give you:
1. A data-only Android chat message to a phone with the app **closed**, then **in the background**, then **in the foreground**.
2. An iOS alert push in all three states.
3. A notification message of type `match` and one of type `feed_comment` on each platform.
4. A message for a **muted** conversation and one for a user with **preview off**, to confirm 3.4.

---

## 4. Chat messaging: what push needs from the chat backend

Socket and REST already work. For push to be correct we also need:

1. **`messagePreview` and `messageNotifications`** returned by `GET /v1/me/settings` and honoured when building the push (the app already reads and writes both).
2. **Unread count** per conversation and total, consistent with push (muted chats still count).
3. **`isMuted`** on the conversation, writable by the app (`PATCH`/`POST` mute endpoint). Today mute is local-only in the app; the push rule 3.4.1 needs the server to know. Please provide the endpoint and fields (duration? until-date?).
4. **Presence**: define "has the room open". Which socket event marks a user as viewing a room (`conversation:join`?) and does leaving the app screen call `conversation:leave`? Also what happens when the app goes to the background but the socket stays up for a few seconds (we suggest the server treats a backgrounded socket as offline after N seconds, or the app disconnects on pause; tell us which).
5. **Message types and bodies** for push text: `text`, `image`, `audio` and any others.
6. **Delete for everyone** (`message:deleted`): do you remove an already-sent push? FCM cannot retract, so we suggest sending a silent data message `{type:"message_deleted", conversationId, messageId}` that the app uses to clear the local notification. Tell us if you will do this.
7. **Seen sync**: when the user reads a chat on another device, send a silent data push `{type:"conversation_read", conversationId}` so the other device clears the notification. Optional, P2.
8. **Receipts / status settings** (`readReceipts`, `showOnlineStatus`, `allowMessagesFrom`) from `NEED_FROM_BACKEND_CHAT_ROUND3.md` §8 are still open; they affect what the push may reveal.
9. **Calls**: there is no real calling backend yet. If incoming-call push is planned, tell us the type name and payload; iOS will need **VoIP push (PushKit)** and Android a high-priority data message. Out of scope for this round unless you say otherwise.

---

## 5. Apple sign-in — **P2 (UI hidden until done)**

App side is not built; the client enum and the `provider: "apple"` request path exist. Backend must:

1. Accept `POST /v1/auth/social { "provider": "apple", "idToken": "<identity token>" }` (the app will send Apple's `identityToken` here). If you want the `authorizationCode` or the user's name as well (Apple only returns name on the first sign-in), tell us the extra fields.
2. Verify against Apple's keys (`https://appleid.apple.com/auth/keys`): `iss = https://appleid.apple.com`, `aud` = our bundle id or Services ID (tell us which), `exp`, and a nonce if you require one.
3. Handle **private relay emails** (`@privaterelay.appleid.com`) and users who hide their email: key the account by Apple `sub`.
4. Apple requires apps with Google sign-in to offer Apple sign-in on iOS: **App Store blocker** if the app ships to iOS with Google login only. Please confirm Team ID and Services ID, and whether account deletion revokes the Apple token (Apple requires revocation on account delete).

---

## 6. In-app notifications (the bell) — **P1**

The bell buttons on Marriage, Feed and Menu are "Coming soon" because these do not exist for the app yet. Needed (names are suggestions; send us the real contract):

| Method | Path | Purpose |
|---|---|---|
| GET | `/v1/notifications?cursor=&limit=` | list, newest first, cursor pagination |
| GET | `/v1/notifications/unread-count` | number for the bell badge |
| POST | `/v1/notifications/:id/read` | mark one read |
| POST | `/v1/notifications/read-all` | mark all read |
| DELETE | `/v1/notifications/:id` | optional |

Notification row fields: `id`, `type` (same values as §3.3), `title`, `body`, `createdAt`, `isRead`, `actor` (`id`, `name`, `photoUrl`), and the deep-link keys (`userId`, `postId`, `conversationId`).

- Socket event **`notification:new`** with the same row, so the badge updates live. Please publish the exact payload (also `compliment:new`, listed as open in `NEED_FROM_BACKEND_CHAT_ROUND3.md`).
- **Chat messages are not notifications rows**: they have their own unread counter. Confirm.
- Push `data` should carry the notification `id` so a tap can mark that row read.
- Retention (how long rows are kept).

---

## 7. Open questions (answer these first)

1. **Google**: Google ID token with audience = web client id. Confirm this is what you verify and list accepted audiences. (§1.1, §1.4)
2. Link-by-email or reject for an existing email/password account? (§1.2)
3. Who creates the iOS OAuth client and re-exports `GoogleService-Info.plist`, and who adds the release / Play App Signing SHA-1/SHA-256? (§1.4)
4. Who owns the Apple Developer account for the APNs key (and Sign in with Apple)? (§3.5, §5)
5. Can you send **per-platform** payloads (data-only Android, alert iOS)? (§3.2)
6. List of all `data.type` values at launch, including calls. (§3.3, §4.9)
7. Is there a socket-based "viewing this room" signal, and what is the rule when the app is backgrounded? (§3.4, §4.4)
8. Mute endpoint and fields. (§4.3)
9. Rate limit, TTLs, where the service-account secret lives and who rotates it. (§3.1, §3.4)
10. Bell endpoints and `notification:new` payload. (§6)
11. Dates: when can we have the dev environment sending a real push to a test token (§3.6)?

---

## 8. Mobile side, for reference (no action for backend)

We are fixing these in the app: iOS Google client id and URL scheme, iOS push entitlements and background mode, iOS local notification setup, Google sign-out on logout, clearing a chat's notification when the chat opens, and the bell UI. None of them changes the contract above except where marked.
