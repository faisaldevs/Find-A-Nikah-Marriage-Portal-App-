# Chat — remaining backend requests (round 2)

Written 2026-11-12 after re-testing the chat feature end to end on two real
devices against the dev server. Everything from round 1 that is not listed
here was verified working (typing relay, receipts, replies, presence, mute,
clear chat, enriched `/blocks`, `POST/DELETE /devices`, `GET /profiles/:id`).

Test accounts: male `user@example.com` (id `6af4469dac7e106dffb18fc4`),
female `user1@example.com` (id `6af44cb2ac7e106dffb19077`), password
`user1234`, conversation `6af5623746ff650a1912952a`.

Items are in priority order. "ISS-n" refers to `resources/docs/ISSUES.md`.

---

## 1. `GET /matches/unmatched` returns ACTIVE matches (bug)

- **Actual:** with one active match and no unmatched ones,
  `GET /api/v1/matches/unmatched` returns the active match.
  `GET /api/v1/matches?status=unmatched` correctly returns `[]`.
- **Expected:** `/matches/unmatched` returns only matches the caller has
  ended (same row shape as `my-matches`), or the route is removed.
- **App today:** uses `?status=unmatched`, so no user impact, but the two
  routes must agree.

## 2. Presence: goes offline while another socket is still connected (bug)

- **Actual:** `presence { userId, online:false }` is emitted when any one
  socket of the user disconnects, even if the same user still has another
  connected socket (e.g. a flaky mobile socket + a stable one). The header
  flickers Online / Last seen.
- **Expected:** keep a per-user socket count. Emit `online:true` on the 0→1
  transition and `online:false` (with `lastActiveAt`) only on 1→0, ideally
  after a short grace period (~5–10 s) so a reconnect doesn't flicker.

## 3. Blocked user still sees the blocker's presence and the thread (ISS-019)

- **Actual:** after A blocks B, B still sees A as "Online" and keeps the
  conversation in their list. B only learns on send:
  `403 "You cannot message this member"`.
- **Expected (please decide, both are fine for the app):**
  1. Do not send A's `presence` events / `partner.isOnline` /
     `lastActiveAt` to B (return `isOnline:false`, `lastActiveAt:null`), and
  2. Either remove the conversation from B's `GET /conversations`, or add
     `canMessage:false` (+ `blockedBy:"them"`) on the row so the app can
     disable the composer instead of failing on send.

## 4. Deleted-for-me messages are still returned by `GET .../messages`

- **Actual:** messages the caller deleted come back with
  `deletedForMe:true`, `text:""` and `deletedBy:[caller]`. After "Clear chat"
  a 50-item page can be mostly blanks, so `hasMore` / paging is wasted.
- **Expected:** exclude messages where `deletedBy` contains the caller from
  the list (still keep them for `replyTo` population, where
  `replyTo.deletedForMe:true` is already correct).

## 5. Spec fixes (no code change needed if the doc is updated)

- `POST /reports` body key is `reportedUserId`; spec says `targetUserId`.
  Please update the spec, or accept both.
- `GET /conversations/unread-count` does not exist (returns
  `404 Conversation not found`, the id is parsed as `unread-count`); the
  working route is `GET /messages/unread-count`. Please document the latter.

## 6. New: "Delete for everyone"

The long-press menu only offers "Delete for me". Please add:
`DELETE /messages/:id?scope=everyone` (sender only, within e.g. 1 hour):

- Sets `deletedForEveryone:true`, blanks `text` / `attachmentUrl`.
- Emits `message:deleted { conversationId, messageId }` to both users.
- Quoted copies (`replyTo`) return `{ deletedForEveryone:true }`.

## 7. New: voice messages

Still "coming soon" in the app. Spec proposed in round 1: multipart field
`audio` + `durationSeconds`, `messageType:"audio"`, `attachmentUrl`; allowed
types `audio/aac`, `audio/mpeg`, `audio/ogg`, max ~2 MB / 120 s.

## 8. New: Friends conversations

The "Friends" tab is a static empty state. Decide whether friends chats are
`conversation.type:"friend"` on the same endpoints (preferred) or a separate
API, and add a filter `GET /conversations?type=marriage|friend`.

## 9. Push notifications (needs a backend answer before the app work)

`POST /devices` / `DELETE /devices/:token` work. Before the app integrates
Firebase, please confirm:

- Payload shape for a new message (`notification` + `data`: `type:"message"`,
  `conversationId`, `senderId`) so the app can deep-link into the thread.
- Muted conversations (`isMuted:true`) send no push but still count toward
  the unread badge.
- Which Firebase project / `google-services.json` + APNs key the dev
  build should use (the app has no Firebase config yet).

## 10. Smaller notes

- Message rows: please include `status` (`sent|delivered|seen`) as well as
  `isDelivered` / `isSeen`; the app derives it today.
- `notification:new` and `compliment:new` socket events exist but their
  payloads are undocumented; the app does not consume them yet.
- Slots (max 5 active chats) are enforced only on the client. If the limit
  is real, return a `409` with a clear message from
  `POST /conversations/:userId` when the caller already has 5 active.
