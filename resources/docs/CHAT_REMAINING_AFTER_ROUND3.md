# Chat — what is left after round 3 (2026-11-14)

Round 3 backend answer: `resources/what_backend_gave_me_for_chat_round_3.txt`.
Everything it covered that the app can do alone is now built (see "Done"). This
file lists what still needs the backend (**A**), what is still app work (**B**),
and what has to be checked on a device (**C**).

## Done in the app this round
- `conversation:updated` socket event: an open room closes / reopens at once;
  `blockedBy:"me"` has its own "You blocked X" bar.
- Delete for everyone: long-press on an own, sent message < 1 h old →
  `DELETE /messages/:id?scope=everyone`; the server's message is toasted when
  the window has passed; `message:deleted` and `deletedForEveryone` hide it;
  quotes of it read "Message deleted".
- `chatSlots.limit` drives the slot count (5 free, 10 Gold) on the Chat tab and
  in the repository; 409 shows the server's message.
- `lastMessageType` → list rows read "Photo" / "Voice message".
- Voice messages: tap mic → record (AAC/m4a, ≤ 120 s, ≥ 1 s) → send as
  multipart `audio` + `durationSeconds`; bubble with play / pause / progress
  (`just_audio`), one plays at a time; retry on failure; quotes and previews
  say "Voice message". New deps: `record`, `just_audio`, `path_provider`;
  `RECORD_AUDIO` / `NSMicrophoneUsageDescription` added.
- Earlier this session: closed-chat composer (`canMessage` / `blockedBy` / 403),
  `Failure.base`, 409 toast, `message:deleted`.

## A. Still needed from the backend (send as round 4)
| # | Need | Why |
|---|---|---|
| A1 | **Firebase project + `google-services.json` / `GoogleService-Info.plist` + APNs key**, and confirmation that the server has FCM credentials | Push cannot start without it. Round 3 gave the payload but not the config. |
| A2 | **Rate limits and caps:** messages per minute (error code, `Retry-After`), image max size and allowed MIME | Only audio limits were given. The app wants to show a proper "slow down" message and pre-check images. |
| A3 | **Payloads of `notification:new` and `compliment:new`** | Listed as "published" but missing from the event table. |
| A4 | **Friends:** how a friendship is created (request / accept?), the `type` field on the conversation row, the requests list endpoint | Only the `?type=` filter was decided. Tab stays an empty state. |
| A5 | **Does a closed (unmatched / blocked) or empty conversation count toward `chatSlots.used` / the 409?** | If yes, the user can hit 409 with free slots showing. Say what counts, or exclude closed ones. |
| A6 | **Pagination shape of `GET /conversations`:** the spec example has `{page, limit, totalCount, totalPages}` and no `hasNext` | The app pages on `hasNext`; without it only the first 50 chats load. Please confirm `hasNext` is returned (as in round 1). |
| A7 | **Audio `attachmentUrl`:** example is `http://localhost:5001/uploads/…` while images use `/public/upload/…` | Need a relative path or the public base URL, not `localhost`, or playback breaks on devices. |
| A8 | **Settings contract:** response envelope of `GET/PATCH /me/settings`; what `allowMessagesFrom:"matches"` returns to a non-match (status / message); whether `readReceipts:false` also hides the *other* person's ticks from this user | Needed to wire the Settings screen without guessing. |
| A9 | **Deploy status:** is round 3 live on the dev (ngrok) server the app uses? | The doc quotes `localhost:5001`. App needs it live to verify. |

## B. Still app work
| # | Work | Blocked on |
|---|---|---|
| B1 | **Push notifications:** Firebase init, token register on login / `DELETE /devices/:token` on logout, foreground / background handling, deep link `data.conversationId` → `/chat/room`, notification permission prompt | A1 |
| B2 | **Settings → server:** map `notifications` → `messageNotifications`, `chatMessagePreview` → `messagePreview`; add Read receipts, Show online status, Allow messages from toggles (needs Figma for the new rows); replace `DummyMenuDataSource` settings | A8 (+ design) |
| B3 | **Conversation search:** search box on the Chat tab (`GET /conversations?q=`), in-thread search (`?q=`) | Figma design for the search UI |
| B4 | **Friends tab:** list / requests / chat | A4 |
| B5 | **Offline cache** (Drift): conversation list + last messages, cache-then-network | none (app) |
| B6 | List "•••" menu (mute / archive from the list) | design |
| B7 | Narrow socket token refresh to `connect_error` with `data.code == "TOKEN_EXPIRED"` (now refreshes on any connect error) | none (small) |
| B8 | Use `message.status` from the server instead of deriving from `isDelivered` / `isSeen` | none (small) |
| B9 | Calls (on hold) | provider choice |
| B10 | Swipe / waveform polish for voice notes, hold-to-record gesture | design |

## C. Check on a device / simulator (nothing below was run on a device)
1. `cd ios && pod install` (new plugins: record, just_audio), then run on iOS and Android.
2. Voice: first tap on mic asks for microphone permission; denied → toast; send → plays on the other phone; > 120 s auto-stops; < 1 s is discarded; failed upload → "Not sent" → tap retries.
3. Delete for everyone: appears only on own, sent messages < 1 h; the peer's copy disappears live; after 1 h the server message is toasted.
4. Block / unblock / unmatch from the other phone: the open room swaps the composer for the bar without leaving and back.
5. Gold account: Chat tab shows `(n/10)`.
6. Re-run the round 2 items that were "fixed" (presence flicker, blocked presence, deleted-for-me paging) against the live server.
