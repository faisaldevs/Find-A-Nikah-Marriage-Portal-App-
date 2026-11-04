# Messaging — backend contract (from source pasted 2026-10-29)

Source: `chat.controllers.js`, `message.model.js`, `chat.routes.js`,
`socket/emit.js`, `socket/index.js`. Responses are wrapped
`{ statusCode, data, message }`. Conversation router mounts at
`/api/v1/conversations`, message router at `/api/v1/messages`.

## REST

| Endpoint | Request | `data` |
|---|---|---|
| `GET /conversations?page&limit&archived=true` | page-based | `{ conversations[], pagination }`. Row = raw conversation (`_id`, `participants[]` populated, `matchId`, `lastMessageAt`, `lastMessagePreview`, `lastMessageSender`, `unread{}`, `archivedBy[]`) **plus** `partner { _id, fullName, isVerified, lastActiveAt, gender, photoUrl }` and `unreadCount` |
| `POST /conversations/:userId` | — | raw conversation (participants are ids only, no partner). 200 existing / 201 new. 403 if no match and no `canMessageBeforeMatch` entitlement; 404 if blocked |
| `GET /conversations/:id/messages?limit(1-100, def 30)&before=<messageId>` | cursor | `{ messages[] newest-first, hasMore, nextCursor }` |
| `POST /conversations/:id/messages` | JSON/form `text` (`message`/`content` also), or multipart file field `image` | raw message, 201. 403 blocked / "This match has ended" |
| `PATCH /conversations/:id/read` | — | `{ marked }` |
| `PATCH /conversations/:id/archive` | `{ archived: bool }` | null |
| `GET /messages/unread-count` | — | `{ count }` |
| `DELETE /messages/:id` | — | null (hides for me only) |
| `GET /matches/my-matches?page&limit` (def 12) | page-based | `{ matches[], pagination, totalCount }`. Row: `_id`/`matchId`, `users[]`, `status` (`active` seen), `matchedAt`, `partner { _id, fullName, isVerified, lastActiveAt, gender }`, `profile { userId, profileId, fullName, photoUrl, images[], age, …card fields }`, `conversationId` + `conversation { _id, lastMessageAt, lastMessagePreview, lastMessageSender, unreadCount }`, `canMessage`, `isMatch`, `isFriend`. **Wired 2026-11-02** → Matches panel |

Notes on `my-matches` (sample 2026-11-02): the conversation is created
when the match is made (preview null until the first message); photo is
only on `profile`; `sect` repeats `faith` (known feed issue); the sample
match was between two male accounts (ISSUES ISS-012); meaning of
`isFriend` on a marriage match unknown.

Message: `_id`, `conversationId`, `senderId`, `receiverId`, `messageType`
(`text`/`image`), `text` (≤5000), `attachmentUrl` (relative path, needs
base URL), `isRead`, `readAt`, `deletedForMe` (text blanked), `createdAt`.
**No** `status` (delivered), `replyTo`, `call`, `slot`, `lastMessage` object.

## Socket

Handshake `auth: { token }`. Auto-joined to own user-id room (incoming
events need no join).

Server → Client: `message:new` (message; socket version adds
`sender{_id,fullName}`), `message:sent`, `message:read {conversationId,
readBy?}`, `typing` / `stop_typing {conversationId, from}`,
`compliment:new`, `compliment:sent`. No presence/online event, no
delivered event.

Client → Server: `message:send {conversationId | toUserId, text,
attachmentUrl?}` with ack `{ success, message }` (REST send is preferred),
`conversation:join|leave {conversationId}`, `message:read
{conversationId}`, `typing` / `stop_typing {conversationId, to|toUserId}`
(`to` = peer user id works without joining the room).

## Backend issues to raise

- [ ] Socket `message:send` skips the REST checks: no `canMessageBeforeMatch`
      entitlement, no "match ended" check → can bypass the paid gate.
- [ ] Socket `message:read` doesn't verify conversation membership.
- [ ] `typing` can target any user id.
- [ ] REST send/read only emit to the other user; sender's other devices
      aren't told.
- [ ] No unmatch/block/mute endpoints seen. (Matches: `my-matches`, added.)
- [ ] No 5-slot concept anywhere (see PENDING → Chat).

## Mismatches with the current app code (`features/messaging`)

- `ConversationDto` expects `id`, `peer`, `slot`, `lastMessage` object;
  backend sends `_id`, `partner`, no slot, only `lastMessagePreview` /
  `lastMessageSender` / `lastMessageAt`, plus `unreadCount`.
- `ChatMessageDto.status` (`sending/sent/delivered/seen/failed`): backend
  only has `isRead` → `seen`, else `sent`. No `delivered`.
- `replyTo`, `call` / `logCall`: no backend support.
- `openConversation` returns no peer info; reuse the `ChatPeer` at hand.
- `attachmentUrl` is a relative path; prefix base URL. Images are out of
  scope for the first pass (text only).
- 403 on `POST /conversations/:userId` (no match, no entitlement) → show
  `chat_gold_sheet.dart`.
- `PATCH /archive` + `?archived=true` back `chat_archived_page.dart`.
- `myId` must come from the auth session, replacing fixture `meId`.

## Open decisions (waiting on owner, 2026-10-29)

- [x] Slots: keep the 5 frontend slots, fill from the list in order;
      server `slot` later (2026-11-02, see PENDING → Chat).
- [x] Matches panel source: `GET /matches/my-matches` (2026-11-02).
- [ ] Go-ahead to implement messaging (REST + chat socket, text only, no
      cache, dummy source commented out not deleted); support after.
- [ ] Still unseen: rest of `socket/index.js` after `ticket:message`.
