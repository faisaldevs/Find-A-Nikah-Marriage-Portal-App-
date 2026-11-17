# Push notifications — what the backend must send

**Audience:** the engineer who owns the Find A Nikah backend.
**Written:** 2026-11-15 by the mobile (Flutter) side. Android first; iOS is deferred.
**Firebase project:** `find-a-nikah` (project number `851419525846`), Cloud Messaging API (V1) is enabled, the legacy API is off.

The app already registers its FCM token: `POST /v1/devices { token, platform: "android" }` after every sign-in and on token refresh, and `DELETE /v1/devices/:token` on sign-out. Everything below is about **what you send**.

## 1. Credentials

- Create a **service account key** for `find-a-nikah` (Firebase console → Project settings → Service accounts → Generate new private key) and keep it as a **server secret**. It is not in the app and must never be committed.
- Send with the **Firebase Admin SDK** (`admin.messaging().send(...)`) or the HTTP v1 endpoint `https://fcm.googleapis.com/v1/projects/find-a-nikah/messages:send`. The legacy server-key API no longer exists.
- Send to the **FCM registration token** the app registered (not a Firebase installation id).

## 2. Two kinds of message

### A. Chat messages: data-only, high priority (WhatsApp-style)

Send **no `notification` block**. The app draws the notification itself, so it can stack messages per conversation and open the right chat.

```json
{
  "token": "<device token>",
  "android": { "priority": "high" },
  "data": {
    "type": "message",
    "conversationId": "6af5…",
    "senderId": "6af4…",
    "senderName": "Amina",
    "senderPhoto": "/public/upload/….jpg",
    "title": "Amina",
    "body": "Salaam, how are you?"
  }
}
```

- **Every value in `data` must be a string** (FCM does not allow nested JSON or numbers).
- `body`: the message text. A photo is `"Photo"`, a voice note `"Voice message"`. **If the user turned off "message preview", send `"New message"` instead of the text.**
- `senderName`: the name the chat shows (the app opens the chat from this, without another request).

### B. Everything else: a normal notification message

Matches, compliments, likes, comments. Android shows these itself, even when the app is closed.

```json
{
  "token": "<device token>",
  "android": {
    "priority": "high",
    "notification": { "channel_id": "channel_matches" }
  },
  "notification": { "title": "It's a match!", "body": "You and Khalil liked each other." },
  "data": { "type": "match", "userId": "6af4…" }
}
```

## 3. `data.type` values and what the app opens

| `type` | Used for | Extra `data` keys | App opens |
|---|---|---|---|
| `message` | new chat message (data-only, §2A) | `conversationId`, `senderId`, `senderName`, `senderPhoto` | that chat |
| `match` | new match | `userId` | Chat tab |
| `compliment` | compliment received | `userId` | Explore |
| `like` | someone liked you | `userId` | Explore |
| `feed_comment`, `feed_like`, `feed_reply` | Feed activity | `postId` | that post |
| `feed_follow` | new follower | `userId` | their Feed profile |

Please tell us every other `type` you plan to send; unknown types still show the notification and just open the app.

## 4. Android channels

The app creates these channels; use these ids as `android.notification.channel_id` in notification messages (data-only chat messages are drawn by the app on `channel_chat`):

| `channel_id` | Name shown to the user | Use |
|---|---|---|
| `channel_chat` | Messages | chat |
| `channel_matches` | Matches and compliments | `match`, `compliment`, `like` |
| `channel_activity` | Activity | Feed and everything else (the default) |

## 5. Rules (please confirm each)

1. **Muted conversation** (`isMuted: true`): no push; the unread count still increases.
2. **Do not push** a user who has that conversation open on a connected socket in that room.
3. **Token moves between users** (logout/login on one phone): the token is reassigned to the new user, not duplicated, and the old user stops receiving it.
4. **Invalid tokens**: on `UNREGISTERED` / `registration-token-not-registered`, delete the token from the device table.
5. **Account deleted or signed out everywhere**: remove that user's device tokens.
6. **Do not put private data in the payload** beyond what is shown in the notification (no email, phone, location).
7. Please **tell us the time-to-live and priority** you use for chat so we can test delayed delivery: we recommend `ttl: 2419200s` (4 weeks) for chat and `android.priority: "high"`.

## 6. How to test (so we can agree it works)

- **Notification message:** Firebase console → Messaging → New campaign → Notification → Send test message → paste the device token (we can print it from a debug build).
- **Data-only chat message:** the console cannot send these. Use a one-off script with the Admin SDK and the payload in §2A. Please send us one to the test token of a phone with the app **closed** and one with the app **in the background**; we need to confirm both are drawn.

## 7. Open questions

1. Which `type` values will exist at launch? (§3)
2. Is there a limit per user per minute (to avoid a flood of notifications)? Chat messages from one conversation should replace each other rather than stack indefinitely; the app keeps the last 6.
3. Where does the service-account secret live (env var, secret manager)? Who rotates it?
