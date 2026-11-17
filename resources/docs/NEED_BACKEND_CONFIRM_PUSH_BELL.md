# Backend: please confirm / fix (push, bell, mute, Google sign-in)

**Audience:** the backend engineer.
**Written:** 2026-11-16 by the mobile (Flutter) side, after building against your reply to
`NEED_FROM_BACKEND_GOOGLE_PUSH_CHAT.md` and testing on an Android phone against the dev server
(`https://d49f-…ngrok-free.app`).
**Priority:** P0 blocks release · P1 blocks the feature · P2 polish.

## A. What the app now does (so you can test)

| Item | App behaviour |
|---|---|
| Bell screen | Bell buttons on Marriage, Feed and Menu open a Notifications screen: `GET /v1/notifications?limit=20&cursor=`, pull to refresh, load more on scroll, swipe left = `DELETE /v1/notifications/:id`, tap = `POST /v1/notifications/:id/read` then opens the target, "Read all" = `POST /v1/notifications/read-all`. |
| Socket in background | The app **disconnects the socket when it goes to the background** and reconnects on return (rooms rejoined). So FCM fallback should fire for backgrounded users. Please confirm backend then sends the push. |
| Join / leave | `conversation:join` / `conversation:leave` were already sent when a chat room opens / closes. |
| Mute | `PATCH /v1/conversations/:id/mute` with `{ "muted": true|false }` (already in the app). No `until` / `durationHours` yet (no UI for it). |
| New push types | `profile_approved`, `profile_rejected`, `verification_approved`, `verification_rejected`, `support_reply` open the Menu tab. `like`, `match`, `compliment` as before. |
| Silent pushes | `conversation_read` and `message_deleted` (data-only, with `conversationId`) clear that chat's notification on the phone. |

## B. Found on the dev server (please fix)

| # | Pri | Finding | What we need |
|---|---|---|---|
| B1 | P1 | `POST /v1/notifications/:id/read` answers **404** `Route /api/v1/notifications/<id>/read not found` (message shown to the user). | Deploy the route (or tell us if it is `PATCH`). Same check for `POST /v1/notifications/read-all`, `DELETE /v1/notifications/:id`, `GET /v1/notifications/unread-count` (not called yet). |
| B2 | P1 | Row `type` values are **`match_created`** and **`message_received`**, not `match` / `message` as in your reply (§6 of the push doc and Q6). The app maps these two names to `match` / `message` for now. | Send the final list of `type` values for **bell rows** and for **push `data.type`**. They must be the same names, or tell us the mapping. |
| B3 | P1 | **Chat messages are still bell rows** (`message_received`, e.g. "Khalil Khan – QA_hello from Khalil"). Your plan §4.1 says chat bypasses `Notification.create`. | Confirm this is not deployed yet. The app will hide `message_received` rows once chat is removed from the list. |
| B4 | P1 | Rows have **no `actor`** object (name / photoUrl) and no `postId` / `conversationId`. Avatars are blank. | Add `actor { id, name, photoUrl }` as in §5.2 of your plan. |
| B5 | P1 | `userId` on a row is **the recipient's own id** (same value on every row, equals the signed-in member). The contract says `userId` is the person to open. | `userId` should be the **actor's** id (who matched / liked / commented), so a tap can open their profile. |
| B6 | P2 | Example photo URL in your plan is `http://localhost:5001/public/upload/...` (absolute, localhost). | Send a relative `/public/upload/...` path or a URL on the public host. The app keeps absolute URLs as they are. |
| B7 | P2 | Response envelope for the list: the app reads `data` as a list, or `data.notifications` / `data.items`, and the paging token from `data.nextCursor`. | Confirm the exact shape: list location, name of the next-page cursor, and whether `?page=` is also supported. |

## C. Not answered in your reply

| # | Pri | Question |
|---|---|---|
| C1 | P1 | **Unread badge**: the app does not show a bell badge yet. Confirm `GET /v1/notifications/unread-count` response shape (`data` number, or `data.unreadCount`?) and the socket events `notification:new` (full row) and `notification:badge` (`{unreadCount}`). |
| C2 | P1 | Does the push `data` carry the notification **`id`**, so a tap can mark that row read? |
| C3 | P2 | Does `POST /v1/auth/logout` revoke the refresh token for Google / Apple users? |
| C4 | P2 | Notification retention: how long are bell rows kept? |
| C5 | P1 | **Mute response** returns `{isMuted, until}` — we ignore it today. Is `until` / `durationHours` supported for "mute for 8 hours / 1 week"? Does `GET /v1/conversations` return `isMuted` (+ `until`) per conversation? |
| C6 | P1 | **Silent pushes**: for `message_deleted` we only have `conversationId` + `messageId`. Please confirm both are sent as strings. |
| C7 | P1 | **iOS**: is `aps.badge` the total unread chat count? Is `thread-id` the `conversationId`? |
| C8 | P1 | **Per-type switches** (`messageNotifications`, `messagePreview` exist). Will there be separate switches for likes / matches / Feed activity? |
| C9 | P2 | New Google user comes back with `onboardingStep: 4`. Which step is that in the wizard (Account type = 1?) so we can resume correctly? Please send the step table. |
| C10 | P1 | `USE_GOOGLE_SIGN_IN` (400) on password login and forgot-password: confirm the exact `code` string and that `message` is user-friendly text. The app shows `message` as-is. |
| C11 | P1 | Google error code: your doc says `INVALID_SOCIAL_TOKEN` in one place and `INVALID_TOKEN` in the sample code. Which one? |

## D. Apple Sign-in (still blocks iOS release)

Apple requires "Sign in with Apple" if the iOS app offers Google sign-in. Please send: Team ID,
Services ID (or confirm audience = bundle id `com.findanikah.app`), and whether a nonce is required.

## E. Needs the owner of the Firebase / Apple accounts (not backend code)

1. iOS OAuth client + fresh `GoogleService-Info.plist` (needs `CLIENT_ID` / `REVERSED_CLIENT_ID`).
2. Release and **Play App Signing** SHA-1 / SHA-256 in Firebase, fresh `google-services.json`.
3. APNs `.p8` key uploaded to Firebase → Cloud Messaging.

## F. Test requests (§3.6 of the original doc)

Dev push to a test token is promised within 2 business days. When ready, send us, for one Android and
one iOS phone: a chat message with the app closed / backgrounded / foreground; a `match` and a
`feed_comment`; a muted chat (expect nothing) and a preview-off recipient (expect "New message");
and a `conversation_read` + `message_deleted` silent push.

## G. App-side work that is not done yet

- Bell **badge** and live `notification:new` updates (waiting on C1).
- Mute duration picker (waiting on C5).
- Opening the exact chat room from a "message" bell row (waiting on B4/B5, needs the sender).
- Per-type notification switches in Settings (waiting on C8).
- Sign in with Apple (waiting on D).
