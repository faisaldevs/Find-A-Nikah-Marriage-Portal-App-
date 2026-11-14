# Chat — what the mobile app needs from the backend

Written 2026-11-12 against `MESSAGE_AND_CHAT_API_SPEC.md` and live testing on
the dev server. Items are in priority order. "ISS-n" refers to
`resources/docs/ISSUES.md` in the app repo.

---

## 1. Replies (quoted messages) — NEW endpoint field

The app already has swipe-to-reply UI; today the quote is dropped because the
message has no place to store it.

**Message schema — add**

```ts
interface IMessage {
  // ...existing fields...
  replyToId?: string | null;        // _id of the quoted message (same conversation)
  replyTo?: {                       // populated on read, so the client needs no 2nd call
    _id: string;
    senderId: string;
    messageType: "text" | "image";
    text?: string;                  // first ~120 chars; "" if the quoted message is an image
    attachmentUrl?: string | null;  // for an image, so the quote can show a thumbnail
    deletedForMe?: boolean;         // quoted message was deleted by the caller
  } | null;
}
```

**Send — accept `replyToId`** on all three send paths:

- `POST /api/v1/conversations/:id/messages` — JSON `{ "text": "...", "replyToId": "<messageId>" }`
  (also as a multipart field for image messages)
- `POST /api/v1/messages` — `{ "conversationId", "text", "replyToId" }`
- Socket `message:send` — `{ conversationId, text, replyToId }`

**Rules**

- `replyToId` must be a message in the **same conversation** (else `400`
  `"Invalid reply target"`).
- If the target was deleted by the caller (`deletedBy` contains caller), still
  allow it; return `replyTo.deletedForMe = true` with blank `text`.
- Return `replyTo` populated in: send response, `GET .../messages`,
  `GET /messages/:id`, `message:new`, `message:sent`.
- Do not fail the whole send if the target message was hard-deleted: store
  `replyToId`, return `replyTo: null`.

**App side (already done / ready):** `ChatMessage.replyTo` and the quote
widget exist; once this ships the app only needs to pass `replyToId` and read
`replyTo`.

---

## 2. Typing indicator is not relayed — ISS-010 (bug)

Verified with two sockets in the same room: `typing` / `stop_typing` with
`{conversationId}` (also with `toUserId`, and with `to`) get **no event and no
ack** on the other side.

Expected (spec §4.6): the other participant receives
`typing { conversationId, from }` and `stop_typing { conversationId, from }`.

---

## 3. Receipts — ISS-011 (bug) and consistency

- `message:delivered { messageId }` and `message:seen { messageId }` return
  `{ success: true }` but are **never broadcast** to the sender. Only the
  conversation-level forms (`{ conversationId }`) and
  `PATCH /conversations/:id/seen` broadcast.
- Payloads disagree: `message:seen` has `seenBy` (the reader) but
  `message:delivered` has `deliveredTo` (the **sender**, not the recipient).
  Please send the same shape for both:
  `{ conversationId, messageIds: [...], by: <userId who triggered it>, at }`.
- Receipts are emitted to **both** users; send them only to the sender.
- Conversation-level receipts carry no `messageId`; including the ids that
  changed removes the need to guess by timestamp.

## 4. Duplicate / mis-addressed message events — ISS-012

One REST send makes the sender **and** the receiver each get both
`message:sent` and `message:new`. Per the spec: `message:new` → receiver only;
`message:sent` → the sender's *other* devices only.

---

## 5. Presence / "last seen" — ISS-015

`partner.lastActiveAt` is not refreshed by socket activity, so the header says
"Last seen 1h ago" for someone chatting right now. Please either update
`lastActiveAt` on socket connect/disconnect and on message send, **or** emit
`presence { userId, online: boolean, lastActiveAt }` to a user's matches.

---

## 6. Missing endpoints

| Feature | Proposed | Notes |
|---|---|---|
| Mute a thread | `PATCH /conversations/:id/mute` `{ "muted": true, "until"?: ISO }` ; `mutedBy[]` on the conversation; `isMuted` in the list/detail response | Muted threads: no push, unread badge still counts |
| Clear chat | `DELETE /conversations/:id/messages` → marks every message `deletedBy += caller` | One call instead of N × `DELETE /messages/:id` |
| Unmatched list | `GET /matches?status=unmatched` (or `/matches/unmatched`) → same row shape as `my-matches` | Backs the "Unmatched" screen; today it's a static empty state |
| Friends chats | decide whether "Friends" is a separate conversation type (`type: "friend"`) or hidden | The tab is a static empty state |
| Voice messages | multipart field `audio` + `durationSeconds`, `messageType: "audio"`, `attachmentUrl` | Mic button is "coming soon" |
| Push (FCM) | `POST /devices` `{ token, platform }`, `DELETE /devices/:token`; send push for new message when the receiver has no socket | Needed before notifications |
| Call records | `POST /calls`, `GET /conversations/:id/calls`, `messageType: "call"` with `{ outcome, durationSeconds, callerId }` | Calls are on hold in the app |
| Block list row shape | Document the `GET /blocks` row: which field holds the blocked user's `_id`, `fullName`, `photoUrl` | App reads `blocked` / `blockedUser` / `user` / `target` tolerantly — please confirm |

## 7. Smaller asks

- `GET /conversations` rows: include `matchId` always (the app needs it for
  Unmatch) — currently present, please keep it.
- `GET /profiles/:userId` returned `404 Profile not found` for a matched
  partner (the id is the `partner._id`). The app now builds "View profile"
  from `my-matches`, but if this endpoint is meant to work for matches please
  check access rules.
- Slots: the app limits to 5 active chats on the client only. If it should be
  enforced, add `slot` (0–4) or a limit error on `POST /conversations/:userId`.
- Socket events `notification:new` and `compliment:new` exist but the app does
  not consume them yet; please document their payloads.

- `POST /reports`: the spec says `targetUserId`, the server only accepts
  `reportedUserId` (404 "Member not found" otherwise). Please fix the spec or
  accept both.
