# Chat — remaining backend requests (round 3)

**Audience:** the engineer / AI who owns the Find A Nikah backend (Node / Express / Socket.IO / MongoDB).
**Written:** 2026-11-14 by the mobile (Flutter) side, after auditing the chat code against rounds 1 and 2.
**Basis:** `NEED_FROM_BACKEND.md` (round 1), `NEED_FROM_BACKEND_CHAT_ROUND2.md` (round 2) and what the app does today. Items already shipped and verified are not repeated.

Format: **Today** (what the app sees), **Need**, **App**. `P0` = a visible bug, `P1` = needed to finish a feature, `P2` = later.

Test accounts as before: `user@example.com` (id `6af4469dac7e106dffb18fc4`), `user1@example.com` (id `6af44cb2ac7e106dffb19077`), password `user1234`.

---

## 0. Still open from round 2 (please confirm status)

The app has **not** re-tested these since round 2. Reply with "fixed" or "won't fix" per item.

| R2 § | Item | Why the app cares |
|---|---|---|
| 1 | `GET /matches/unmatched` returns ACTIVE matches | App uses `?status=unmatched`; both routes must agree. |
| 2 | Presence goes offline when one of two sockets drops | Header flickers Online / Last seen. |
| 3 | Blocked user still sees blocker's presence and thread | See §1 below, which replaces it. |
| 4 | `GET .../messages` returns deleted-for-me rows | After "Clear chat" a 50-row page can be mostly blank, so paging is wasted. **Please exclude them.** |
| 5 | Spec: `POST /reports` key, `GET /messages/unread-count` | Docs only. |

---

## 1. Tell the client when a chat can no longer take messages — **P0**

- **Today:** after an unmatch or a block the app only finds out when a send fails with `403 "You cannot message this member"`. The app now closes the composer after that first 403 and also when `my-matches` says `canMessage:false`, but for a **block** the blocked user has no other signal (`my-matches` is unaffected), and an unmatch is only seen after the next list poll (30 s).
- **Need:** on every conversation row (`GET /conversations`, `GET /conversations/:id`, and the `POST /conversations/:userId` response):
  ```json
  { "canMessage": false, "blockedBy": "them" }   // them | me | null
  ```
  - `canMessage:false` when the match ended **or** either side blocked.
  - `blockedBy:"them"` when the peer blocked the caller, `"me"` for the reverse, absent otherwise.
  - Keep the row in the list (the app disables the composer and shows "You can't message X").
  - For `blockedBy:"them"`: also return `isOnline:false` and `lastActiveAt:null` for that partner, and do not emit their `presence` events to the blocked user (R2 §3, ISS-019).
- **Realtime (P1):** emit `conversation:updated { conversationId, canMessage, blockedBy }` to both participants when an unmatch / block / unblock happens, so an open room closes or reopens at once.
- **App:** already reads `canMessage` (nullable; missing = open) and `blockedBy`. No release needed on our side when this ships.

## 2. Unmatch / block / unblock behaviour to confirm — **P1**

Round 1 §6 asked for these and they have not been confirmed. Please answer in writing or add tests:

| Case | What the app assumes |
|---|---|
| Unmatch (`DELETE /matches/:id`) | Both sides get `403 "This match has ended"` on send; `my-matches` row has `canMessage:false`; shows in `GET /matches?status=unmatched` for **both** users. |
| Block | Blocker's list drops the conversation (current behaviour is fine); blocked user's row stays with `canMessage:false` (§1); sends return `403`. |
| Unblock | Sending works again with history intact; if the match is still active, `canMessage:true` returns. |
| Re-match after unmatch | Same conversation is reused (history kept) or a new one is created — please say which. |

## 3. Delete for everyone — **P1**

(R2 §6, restated with the client contract. The app has the socket listener and DTO ready; the long-press option stays hidden until this ships.)

- `DELETE /messages/:id?scope=everyone` — sender only, within 1 hour (return `403 "Too late to delete for everyone"` after that). Without `scope`, behaviour stays "delete for me".
- Sets `deletedForEveryone:true`, blanks `text` and `attachmentUrl`.
- Socket `message:deleted { conversationId, messageId }` to **both** users.
- Return `deletedForEveryone:true` on the message in `GET .../messages` (the app hides it) and `replyTo.deletedForEveryone:true` on quotes of it.
- Update `lastMessagePreview` of the conversation if the deleted message was the last one.

## 4. Active-chat limit — **P1**

- **Today:** the 5-chat limit is enforced only by the app. A second device or a modified client can open more.
- **Need:** `POST /conversations/:userId` returns **`409`** with a human-readable `message` when the caller already has the maximum active (non-archived) chats, e.g. `"You can have 5 active chats. Archive one to start another."` Include `{ "code": "CHAT_LIMIT", "limit": 5 }` in the body. Gold users get 10 (the Gold sheet in the app already says so).
- Expose the limit: `GET /me` (or `GET /conversations` response) returns `chatSlots: { limit, used }` so the app stops hard-coding 5.
- **App:** a 409 shows the server's `message` as a toast; a 403 still opens the Gold sheet.

## 5. Voice messages — **P2**

(R2 §7 restated.) `POST /conversations/:id/messages` multipart: field `audio` + `durationSeconds`; `messageType:"audio"`, `attachmentUrl`, `durationSeconds` on the message and in `replyTo`. Allowed MIME `audio/aac`, `audio/mpeg`, `audio/mp4`, `audio/ogg`; max ~2 MB / 120 s; `400` with a clear message otherwise. The app mic button is a placeholder until then.

## 6. Push notifications — **P1** (largest item)

The app has **no Firebase config yet**. To start we need, from the backend side:

1. The **Firebase project** (or confirmation that we create one) and the dev `google-services.json` / `GoogleService-Info.plist`, plus the APNs key uploaded for iOS.
2. Confirmed payload for a new message (data keys are used for deep links):
   ```json
   { "notification": { "title": "Amina", "body": "Salaam…" },
     "data": { "type": "message", "conversationId": "…", "senderId": "…" } }
   ```
   For a photo, body = `"Photo"`. No message text if the user turned off "message preview" (see §8).
3. Muted conversations (`isMuted:true`): **no push**, unread count still increments.
4. No push to a user who currently has the conversation open on a connected socket in that room.
5. `POST /devices { token, platform }` / `DELETE /devices/:token` already work — confirm that a token moving to a different user (logout / login on one phone) is reassigned, not duplicated.
6. Push types we will also need later (same `data.type` scheme): `match`, `compliment`, `feed_comment`. Please list the ones that will exist.

## 7. Friends conversations — **P2** (decision needed)

(R2 §8.) Decide: `conversation.type:"friend"` on the same endpoints (preferred) with `GET /conversations?type=marriage|friend`, or a separate API. Tell us how a friendship is created (feed follow? request/accept?) so the tab can show "Requests". Until decided the tab stays an empty state. Friend chats must **not** count toward the marriage chat limit (§4).

## 8. Chat settings the app already shows but cannot save — **P2**

The Menu → Settings screen has toggles that live in memory only. Need `GET/PATCH /me/settings` with at least:
`messageNotifications: boolean`, `messagePreview: boolean`, `readReceipts: boolean`, `showOnlineStatus: boolean`, `allowMessagesFrom: "matches" | "everyone"`.
- `readReceipts:false` → the server must not broadcast `seen` to the sender (and the user also does not see theirs).
- `showOnlineStatus:false` → `isOnline:false` / `lastActiveAt:null` for everyone else, no `presence` events.

## 9. Message rows and list: small contract additions — **P2**

1. Message rows: add `status: "sent" | "delivered" | "seen"` next to `isDelivered` / `isSeen` (R2 §10). The app derives it today; both can stay.
2. `GET /conversations` rows: add `lastMessageType: "text" | "image" | "audio"` so the list can show a photo / mic icon instead of parsing the preview text (today the app writes `"Photo"` itself only for its own sends).
3. `lastMessageSender` should always be a user id string (it is today); please keep it stable.
4. `GET /conversations/:id` should accept being called right after `POST /conversations/:userId` for a brand-new, empty conversation without a `404`.

## 10. Searching chats — **P2**

For the conversation search box (not built yet): `GET /conversations?q=<text>` matching partner name, plus optional `GET /conversations/:id/messages?q=<text>` for in-thread search. If search is not wanted on the server, say so and the app will filter the loaded list locally by name only.

## 11. Socket contract: document what we rely on — **P1**

Please publish (in `MESSAGE_AND_CHAT_API_SPEC.md`) the exact payloads for: `presence`, `typing` / `stop_typing`, `message:delivered` / `message:seen` (`messageIds`, `by`, `at`), `message:new`, `message:sent`, `message:deleted` (§3), `conversation:updated` (§1), `notification:new`, `compliment:new`. Also:
- Handshake with an expired JWT → `connect_error` with a recognisable `data.code` such as `TOKEN_EXPIRED` (the app currently refreshes on **any** connect error).
- Rate limits: messages per minute (error code and `Retry-After`), image size / MIME cap, text length (the app enforces 5000).
- After a reconnect, `GET .../messages` and `GET /messages/unread-count` must include everything sent while the client was offline.

---

## Suggested order

1. §1 `canMessage` / `blockedBy` on conversation rows and R2 §4 (deleted-for-me rows) — small, fixes visible bugs.
2. §2 confirmations, §11 socket docs.
3. §4 chat limit (409).
4. §3 delete for everyone.
5. §6 push (unblocks the whole notifications feature).
6. §8 settings, §9 contract additions.
7. §5 voice, §7 friends, §10 search.

## What the app changed in this round (FYI, nothing for you to do)

- The composer is replaced by a "can't message" bar when the match ended or the peer blocked the user (from `canMessage` / `blockedBy`, an ended match in `my-matches`, or a `403` on send; re-opening the room retries).
- `ForbiddenFailure` / `ConflictFailure` are now detected even when the server wraps them with a message (the Gold sheet previously only opened for a bare 403).
- 409 on opening a chat shows a toast with the server's message.
- `message:deleted` socket event and `deletedForEveryone` are parsed and hide the message.
