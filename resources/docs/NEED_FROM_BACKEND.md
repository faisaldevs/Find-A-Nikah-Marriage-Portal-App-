# Need from backend — Chat feature (complete list)

**Audience:** the AI / engineer who owns the Find A Nikah backend (Node / Express / Socket.IO / MongoDB).
**Written:** 2026-11-12 by the mobile (Flutter) side, after testing the chat end to end on the dev server with two real accounts (a phone and an emulator).
**Basis:** `MESSAGE_AND_CHAT_API_SPEC.md` plus **live behaviour** (every "Today" below was observed against the dev server, not assumed).

How to read this: each item has **Today** (what the server does now), **Need** (what to build or fix), and **Why / how the app uses it**. Items are ordered by priority. `P0` = blocks a visible feature or is a bug; `P1` = needed to finish the feature; `P2` = nice to have.

---

## 0. What already works (do not change)

Verified live; the app depends on these exactly as they are.

| Area | Endpoint / event | Notes |
|---|---|---|
| Auth | `POST /auth/login`, refresh | JWT in `Authorization` and in socket handshake `auth.token` |
| Matches | `GET /matches/my-matches` | rows include `matchId`, `partner`, `profile`, `canMessage`, `conversationId` |
| Conversations | `GET /conversations?page&limit&archived`, `POST /conversations/:userId`, `GET /conversations/:id` | `pagination.hasNext` present |
| Messages | `GET /conversations/:id/messages?limit&before`, `POST /conversations/:id/messages` (text + multipart `image`) | newest first, cursor works |
| Receipts (REST) | `PATCH /conversations/:id/delivered`, `PATCH /conversations/:id/seen` | `/seen` broadcasts `message:read` + `message:seen` |
| Receipts (socket) | `message:delivered {conversationId}`, `message:seen {conversationId}` | broadcast to sender (see §3 for problems) |
| Realtime | `message:new` | arrives instantly on the other device |
| Archive | `PATCH /conversations/:id/archive {archived}` , `GET /conversations?archived=true` | per-user |
| Delete for me | `DELETE /messages/:id` | blanks text, sets `deletedForMe` for caller only |
| Unread | `GET /messages/unread-count`, `unreadCount` per row | |
| Block | `POST/DELETE /blocks/:userId`, `GET /blocks` | row shape undocumented (§5) |
| Unmatch | `DELETE /matches/:id` | not yet tested by the app |
| Report | `POST /reports` | works with `reportedUserId` (§1) |
| Notifications | `GET /notifications` | returns `message_received` etc. (see §6) |

---

## 1. Bugs / spec mismatches (P0 — fix first)

### 1.1 Typing indicator is never relayed — **P0**
- **Today:** with both users' sockets connected and joined to the same `conversation:join` room, `typing` / `stop_typing` emitted with `{conversationId}`, with `{conversationId, toUserId}` and with `{to}` produce **no event on the other socket and no ack**.
- **Need:** relay to the *other participant only*:
  `typing { conversationId, from }` and `stop_typing { conversationId, from }` (`from` = typing user's id). Verify membership and block status as already described in the spec. Please also emit an ack `{success:true}` so the client can detect failure.
- **App:** already emits (throttled 1 per 3 s, `stop_typing` on idle/send) and shows "typing…" in the header with a 6 s auto-expire. Nothing else to do client-side.

### 1.2 `POST /reports` body key does not match the spec — **P0**
- **Today:** the spec says `{ targetUserId, reason, description }`. The server returns `404 "Member not found"` for `targetUserId` (also for `userId`) and only accepts **`reportedUserId`**.
- **Need:** either update the spec to `reportedUserId`, or accept both keys. The app currently sends `reportedUserId`.
- Also document the allowed `reason` values. The app sends: `harassment`, `inappropriate_content`, `fake_profile`, `spam`, `other`. Return `400` with a clear message for an unknown reason. A duplicate open report returns `"You already have an open report about them"` (fine; the app shows the message).

### 1.3 Per-message socket receipts are not broadcast — **P0**
- **Today:** `message:delivered {messageId}` and `message:seen {messageId}` return an ack `{success:true}` but the **sender receives nothing**. Only the conversation-level forms (`{conversationId}`) and `PATCH /conversations/:id/seen` broadcast.
- **Need:** broadcast per-message receipts to the sender too.
- **Payload inconsistency (fix at the same time):**
  - `message:seen` carries `seenBy` (the reader). `message:delivered` carries `deliveredTo`, which is the **sender's** id (not the recipient who triggered it). Make both the same shape:
    ```json
    { "conversationId": "...", "messageIds": ["..."], "by": "<userId who triggered it>", "at": "<ISO>" }
    ```
  - Conversation-level receipts currently carry **no message ids**; include the ids that changed so the client does not have to guess by timestamp.
  - Receipts are emitted to **both** users; emit only to the **sender(s)** of the affected messages.
- **App workaround today:** uses conversation-level forms only, filters out its own echoes using `seenBy`/`deliveredTo`, and marks "all my messages up to the timestamp". It will keep working if you keep the current fields and add the new ones.

### 1.4 `message:sent` / `message:new` are sent to the wrong people, twice — **P1**
- **Today:** one REST send makes the sender **and** the receiver each receive both `message:sent` and `message:new` (4 events).
- **Need (per the spec):** `message:new` → the **receiver** only. `message:sent` → the **sender's other devices** only (exclude the sending device/socket).
- **App:** dedupes by `_id` so it is harmless, but it is wasted traffic and will matter for push and unread counts.

### 1.5 `PATCH /conversations/:id/archive` and Report give no feedback on failure — **P2 (app-side, FYI)**
No backend change; the app now shows server error messages as toasts. Please keep `message` strings human-readable (they are displayed verbatim).

---

## 2. Replies (quoted messages) — **P1, NEW**

- **Today:** `replyToId` is accepted without error and **silently ignored**. Verified: sent `{text, replyToId:"000000000000000000000000"}` → `201`, message stored with no `replyToId` / `replyTo` fields.
- **Need:**
  ```ts
  interface IMessage {
    // existing fields ...
    replyToId?: string | null;      // _id of the quoted message, same conversation
    replyTo?: {                     // POPULATED on every read so the client needs no 2nd call
      _id: string;
      senderId: string;
      messageType: "text" | "image";
      text?: string;                // first ~120 chars; "" for an image
      attachmentUrl?: string | null;// so the quote can show a thumbnail
      deletedForMe?: boolean;       // quoted message was deleted by the caller
    } | null;
  }
  ```
- Accept `replyToId` on all send paths: `POST /conversations/:id/messages` (JSON and multipart field), `POST /messages`, socket `message:send`.
- **Rules:** target must be in the **same conversation** (else `400 "Invalid reply target"`). If the target was deleted *for the caller*, still allow, return `replyTo.deletedForMe=true` and blank `text`. If the target was hard-deleted, keep `replyToId` and return `replyTo:null` (don't fail the send).
- Return `replyTo` populated in: send response, `GET .../messages`, `GET /messages/:id`, `message:new`, `message:sent`.
- **App:** swipe-to-reply UI and quote widget already exist; today the quote is dropped on send. Once this ships the app only passes `replyToId` and reads `replyTo`.

---

## 3. Presence / "last seen" — **P1**

- **Today:** `partner.lastActiveAt` is not refreshed by socket activity. The header shows "Last seen 1h ago" for someone who is online and chatting right now. There is no online/offline event.
- **Need (either):**
  1. Update `lastActiveAt` on socket connect, on disconnect, and on each message send/receive; **or**
  2. Emit `presence { userId, online: boolean, lastActiveAt }` to the user's matches/conversation partners on connect/disconnect, and include `online` in `partner` on `GET /conversations` and `GET /matches/my-matches`.
- **App:** `ChatPeer.isOnline` already exists and shows "Online" in green; it just never gets set.

---

## 4. Missing features (new endpoints) — **P1 unless noted**

All paths below are **proposals**; keep the same response envelope `{statusCode,data,message,success}` and auth.

Probed on 2026-11-12: every route below currently returns `404 Route ... not found`, except where noted.

### 4.1 Mute a conversation
- `PATCH /conversations/:id/mute` body `{ "muted": true, "until"?: "<ISO>" }` → `200`.
- Add `mutedBy: string[]` (or `mutedUntil` map) to Conversation; return `isMuted: boolean` for the caller in `GET /conversations`, `GET /conversations/:id`.
- Muted: no push/in-app notification for new messages; unread counter still increments.
- **App:** "Mute notifications" row in the chat menu is a placeholder ("coming soon").

### 4.2 Clear chat (delete all messages for me)
- `DELETE /conversations/:id/messages` → marks every message `deletedBy += caller`; `lastMessagePreview` for the caller becomes empty; `200`.
- Today the app would need N × `DELETE /messages/:id`.
- **App:** "Clear chat" row is a placeholder.

### 4.3 Unmatched list
- **Today:** `GET /matches?status=unmatched` returns `200` with an empty list (route exists; assumed to work, **no unmatched data to confirm the row shape**). `GET /matches/unmatched` is 404.
- **Need:** confirm `GET /matches?status=unmatched` returns the same row shape as `my-matches` (with `partner`, `profile`, `matchedAt`, `unmatchedAt`, `unmatchedBy`), paginated; document it.
- **App:** the "Unmatched" page is a static empty state; it will be wired to this.

### 4.4 Push notifications (FCM)
- **Today:** no device endpoints (`POST /devices`, `/devices/token` → 404). `GET /notifications` exists (in-app list: `type: "message_received"`, `title`, `body`, `data{conversationId}`, `isRead`) and `notification:new` socket event exists but is **undocumented**.
- **Need:**
  - `POST /devices` `{ token, platform: "android"|"ios" }` (idempotent upsert per user+token), `DELETE /devices/:token` (on logout).
  - Send an FCM push for a new message **only when the receiver has no connected socket** (and the thread isn't muted). Payload: `{ type: "message", conversationId, senderId, title, body }`, plus `notification` block for display.
  - Same for `match` and `like` events.
  - Document the `notification:new` socket payload and `GET /notifications` row types; add `PATCH /notifications/:id/read` and `PATCH /notifications/read-all` if missing.
- **App:** not built yet (waiting on this). Needs deep link target = `conversationId` → `/chat/room`.

### 4.5 Voice messages — **P2**
- `POST /conversations/:id/messages` multipart field `audio` (+ `durationSeconds`), `messageType: "audio"`, `attachmentUrl`, `durationSeconds` in the message.
- **App:** mic button is a placeholder.

### 4.6 Calls — **P2 (feature on hold in the app)**
- Needs a calling provider (LiveKit/Agora) token endpoint, call records (`POST /calls`, `messageType:"call"` with `{ outcome: "answered"|"missed"|"declined", durationSeconds, callerId }`), and incoming-call push. The app hides calls for now; nothing urgent.

### 4.7 Friends chats — **P2 (decision needed)**
- The "Friends" tab is a static empty state. Decide whether friend chats are a separate conversation `type` (`"friend"` vs `"marriage"`) or whether the tab should be removed. Until decided the app keeps it as an empty state.

---

## 5. Documentation / contract gaps — **P1**

1. **`GET /blocks` row shape is undocumented** (the list was empty when checked). The app reads the blocked member from any of `blocked` / `blockedUser` / `user` / `target` (object with `_id`, `fullName`, `photoUrl`) or `blockedId` / `targetUserId` (string). Please document the real shape so the app can drop the guessing. Page size default is 12.
2. **`GET /profiles/:userId` returns `404 "Profile not found"` for a matched partner** when called with `partner._id` (also with the conversation's partner id). The app therefore builds "View profile" from `my-matches` data only. If this endpoint is meant to work for matches/chat partners (to show the full profile, more photos, bio), fix access rules or document which id it expects (`profileId` vs `userId`).
3. `my-matches` `profile.faith` and `profile.sect` are **arrays** (`[]`, `["sunni"]`) while older docs show strings; `educationLevel` / `maritalStatus` are tokens (`undergraduate`, `never_married`). Please keep types stable and document them. `profile.city` is `null` for the test user.
4. Document the `notification:new` and `compliment:new` socket payloads.
5. Document rate limits (messages/min, image size cap and allowed MIME types, max text length — app assumes 5000 chars and enforces it client-side).

---

## 6. Behaviour to confirm / tests the backend should cover

The app has **not** exercised these (they break the test match); please confirm behaviour by test or description:

| Case | Expected (what the app assumes) |
|---|---|
| **Block** a partner | their messages stop arriving; both sides' `POST /conversations/:id/messages` → `403`; the conversation disappears from the blocker's list; `GET /blocks` lists them; unblock restores access without deleting history |
| **Unmatch** (`DELETE /matches/:id`) | conversation closed to new messages (`403 "This match has ended"`), `canMessage:false` on the match row, appears under `status=unmatched` for both |
| **Archived + new incoming message** | auto-restores for the receiver (spec says yes) and the app gets `message:new` |
| **Token expiry on the socket** | handshake with an expired JWT is rejected with a `connect_error` the client can recognise (the app then refreshes the token and reconnects) |
| **Reconnect gap** | messages sent while a client was offline appear in `GET .../messages` and `unread-count` is correct after reconnect |
| **Free plan limit** | if "5 active chats" is meant to be enforced, return a clear error on `POST /conversations/:userId` (e.g. `403 {code:"CHAT_LIMIT"}`) or expose `slot`; today the limit is client-side only |
| **`canMessageBeforeMatch`** | `POST /conversations/:userId` without match/entitlement → `403`; the app opens its "Gold" upsell on any 403 there |

---

## 7. Suggested order for the backend

1. §1.2 report key (5-minute fix) and §1.1 typing relay.
2. §1.3 / §1.4 receipt and message-event cleanup.
3. §2 replies.
4. §3 presence.
5. §5 documentation items (block row shape, profile-by-id).
6. §4.1 mute, §4.2 clear chat, §4.3 unmatched confirmation.
7. §4.4 push (largest item; unlocks notifications in the app).
8. §4.5–4.7 voice messages, calls, friends — later.

## 8. Test accounts on the dev server

`user@example.com` (male, id `6af4469dac7e106dffb18fc4`) and `user1@example.com` (female, id `6af44cb2ac7e106dffb19077`), password `user1234`, actively matched with one conversation. Both are throw-away test accounts. Please do not delete them without telling the mobile side.
