# Support tickets — backend contract

Status: **not started**. UI today is two `showComingSoon` stubs in
`lib/features/menu/presentation/view/help_page.dart` ("My support tickets",
"Contact support"). No `socket_io_client` in `pubspec.yaml`. Tracked in
`PENDING.md` → "Support tickets".

Contract below is from the backend source pasted on 2026-10-29
(`support.controllers.js`, `supportTicket.model.js`, `support.routes.js`,
`socket/index.js`). The socket file was cut off after `ticket:message`, so
`ticket:status` and `ticket:typing` handler bodies were not seen.

All REST responses are wrapped: `{ statusCode, data, message }`. All routes
need the JWT.

## REST (use these for every mutation — CLAUDE.md rule)

| Endpoint | Notes |
|---|---|
| `POST /api/v1/support/tickets` | body `{ subject, category?, priority?, text\|message, attachments? }`. 201 → full ticket. Default category `general`, priority `medium` |
| `GET /api/v1/support/tickets?page&limit&status` | `data: { tickets[], pagination, totalCount }`, sorted by `lastMessageAt` desc. Page-based, **not** cursor |
| `GET /api/v1/support/tickets/:id` | full ticket incl. embedded `messages[]` (no separate message-history endpoint) |
| `POST /api/v1/support/tickets/:id/messages` | body `{ text\|message, attachments? }`. 201 → `{ ticketId, ticketNumber, message, status }` |
| `PATCH /api/v1/support/tickets/:id/status` | body `{ status }`. A user may only send `closed` (403 otherwise) |
| `GET /api/v1/support/admin/tickets` | staff only — the app never calls it |

Ticket fields: `_id`, `ticketNumber` (`TIC-<6><4>`), `userId`, `subject`
(≤200), `category`, `priority`, `status`, `assignedTo`, `messages[]`,
`lastMessageAt`, `lastMessagePreview` (≤150), `createdAt`, `updatedAt`.
Message fields: `_id`, `senderId`, `senderRole` (`user`/`support`/`admin`),
`senderName`, `text` (≤5000), `attachments[{ url, storageKey }]`,
`createdAt`.

## Socket (push only)

Handshake: `auth: { token }` (or `Authorization: Bearer`). User is
auto-joined to room = own user id on connect, so `ticket:created`, user-room
`ticket:message` and `ticket:status_changed` arrive without any join.

| Direction | Event | Payload |
|---|---|---|
| Server → Client | `ticket:created` | ticket object (also fired for REST-created tickets) |
| Server → Client | `ticket:message` | `{ ticketId, ticketNumber, message, status }` |
| Server → Client | `ticket:status_changed` | `{ ticketId, status }` |
| Client → Server | `ticket:join` / `ticket:leave` | `{ ticketId }`, ack `{ success, ticketId }`; room `ticket:<id>` needed only while the thread is open |
| Client → Server | `ticket:typing` | `{ ticketId, isTyping }` (handler not seen) |

Ignore the `support:*` aliases and the socket-side `ticket:create` /
`ticket:message` / `ticket:status` senders — REST does the same.

## Backend issues to raise

- [ ] **Attachments don't match the schema.** Schema stores
      `[{ url, storageKey }]`; docs/controller accept `string[]`. Strings
      will fail Mongoose casting. No upload endpoint for ticket
      attachments exists either.
- [ ] **Attachment-only message fails.** Controller allows empty text with
      attachments, but message `text` is `required` in the schema.
- [ ] **Status values.** REST sets `waiting_for_user` when support replies;
      the socket spec said `in_progress`. Need the real
      `SUPPORT_TICKET_STATUSES` / `_CATEGORIES` / `_PRIORITIES` constants
      (not pasted) for dropdowns and chips.
- [ ] A **closed** ticket still accepts new messages (no guard).
- [ ] **Duplicate delivery:** a message to the ticket room *and* the user
      room reaches a client in both twice → client dedupes by message
      `_id`. A user's own reply isn't echoed to their other devices (only
      the ticket room), another reason to join the room while open.
- [ ] `ticketNumber` = last 6 digits of epoch ms + 4 random digits:
      collision on the unique index → 500. Rare.

## Plan when unblocked

New feature `lib/features/support/` (presentation first; `data/` for the
Retrofit data source — the API exists now). Socket handlers feed a
repository stream, never bloc state (CLAUDE.md, guide 01 Gotchas #4). Needs
`socket_io_client`; share the single connection with messaging and close it
in `SessionScopeManager.closeConnections`.
