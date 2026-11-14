> **Saved copy of the backend's reply (received 2026-11-14), verbatim.** Their claims are not verified by us yet — see `06_BACKEND_REPLY_REVIEW.md` for what to check and what is missing.

# Find A Nikah - Feed Tab (Community Posts) Mobile Implementation Plan & Backend Response

> **Audience:** Flutter / Mobile App Engineers (BLoC, DTOs, Repository, UI), Integrators  
> **Written:** 2026-11-14  
> **Backend Status:** Live & Fully Verified (Port `5001`, `http://localhost:5001/api/v1`)  
> **Automated Test Suite:** `src/scripts/test-feed-suite.js` (**75 Passed, 0 Failed**)  
> **Seeding Script:** `src/scripts/seed-feed.js` (Seeds topics, handles, posts, threads, deleted posts)

---

## 1. Executive Summary & Design Decisions

This document is the official implementation guide for the **Feed Tab (Community Posts)** in Find A Nikah, answering all points from `NEED_FROM_BACKEND_FEED.md`.

All phases (Phases 0 through 5) are built, tested, and live on the development server. The mobile team can proceed with phased rollouts (Phase 0 and Phase 1 first, followed by Phase 2, 3, 4, and 5) while developing against real endpoints with guaranteed contracts.

### Specific Decision Responses

| Decision | Question | Backend Decision & Contract |
| :--- | :--- | :--- |
| **§10: Edit Time Limit** | What is the edit window for posts and comments? | **15 minutes** from `createdAt`. After 15 minutes, the server rejects edits with `403` and code `EDIT_WINDOW_EXPIRED`. Topic cannot be changed on edit (only `body`). `editedAt` is recorded in UTC. |
| **§13: Locked Marriage Profile** | How is access determined and how is restricted data protected? | **Server-side data withholding.** The response for `GET /api/v1/profiles/:userId` contains an `access` object (`level: "full" \| "partial" \| "locked"`, `reason`, `unlockable`, `lockedSections`). When locked or partial, sensitive sections are removed/null on the server, and photos are omitted or pre-blurred. The mobile client never receives hidden data. Views from Feed count as a profile view with source `"feed"`. |
| **§5: "For You" Ranking** | How is "For you" ranked and is paging stable? | Ranked by engagement and freshness: `Score = (likeCount * 2 + commentCount * 3 + viewCount * 0.1)`. Cursor seeks descending on `_id` (`_id < cursor`) with engagement tie-breaking, ensuring stable pagination where items are never duplicated across page boundaries. Mode `new` is strictly reverse-chronological by `createdAt`. |
| **§19: Non-Matched Messaging** | Can a user message someone from Feed who isn't matched? | **No direct message for free unmatched members.** If matched: opens direct chat. If unmatched: opens the compliment / swipe sheet (`POST /api/v1/profiles/swipe { action: "complement", targetUserId, text }`). Gold / Premium users with `canMessageBeforeMatch` entitlement can open direct conversations. |
| **§22: Repeated Reports** | What happens to repeatedly reported posts? | When a post receives **5 unique member reports** (`reportCount >= 5`), the server flags `isAutoHidden: true` (quarantined pending moderator review). It immediately vanishes from all feed lists. Additionally, reporting a post instantly hides it from the reporter's feed. |
| **§14: Likes Privacy** | Are user likes public or private? | **Private.** `GET /api/v1/feed/users/:userId/likes` returns the user's liked posts only if the caller is viewing their own profile (`userId === callerId`). For other users, it returns an empty array with `{ success: true, message: "User likes are private" }`. |

---

## 2. Test Environment & Verification Accounts

- **Base URL:** `http://localhost:5001/api/v1`
- **Socket.IO Base URL:** `http://localhost:5001` *(transports: `["websocket"]`)*

### Test Accounts

| Account | Email | Password | User ID | Handle | Display Name | Role in Feed |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **User A** | `user@example.com` | `user1234` | `6af4469dac7e106dffb18fc4` | `@ayat_n4821` | `Chat T.` | Main test author & viewer |
| **User B** | `user1@example.com` | `user1234` | `6af44cb2ac7e106dffb19077` | `@khalil_k2210` | `Chat T.` | Partner author (owns chai post) |

### Test Data Seeded

- **Seeded Topics:** 5 topics (All things marriage, Random, Fun & Laughs, Converts / Reverts, Announcements).
- **Post with Comments & Inline Replies:** Post ID `6af7ff0d521b62dbecd134b9` ("Tea always wins at 3 AM") with top-level comment and 2 nested replies.
- **Deleted Post (for §6 testing):** Post ID `6af7ff0d521b62dbecd134bd` (returns `410 POST_DELETED`).

---

## 3. Core Conventions (§1, §2)

### §1. Response Envelope, Paging & Error Shape

Every endpoint follows the unified response envelope:

```json
{
  "statusCode": 200,
  "success": true,
  "message": "Feed posts",
  "data": {
    "items": [ ... ],
    "nextCursor": "6af7ff0d521b62dbecd134b9",
    "hasMore": true
  }
}
```

- **Paging:** `?cursor=<string>&limit=<int>` (default `limit: 20`, max `50`).
- **Dates:** ISO-8601 UTC strings (e.g. `"2026-11-14T08:00:00.000Z"`).
- **Errors:** Standardized error shape with stable `code`:
  ```json
  {
    "statusCode": 404,
    "success": false,
    "message": "Post not found",
    "code": "POST_NOT_FOUND",
    "errors": []
  }
  ```

### §2. Author Object (`FeedAuthor`)

Used identically in posts, comments, replies, and profile headers:

```json
{
  "userId": "6af4469dac7e106dffb18fc4",
  "displayName": "Ayat N.",
  "handle": "ayat_n4821",
  "photoUrl": "http://localhost:5001/uploads/photos/primary.jpg",
  "countryCode": "bd",
  "isVerified": true,
  "isMe": false
}
```

- `displayName`: Formatted as First Name + Last Initial (e.g. "Ayat N."). If account is deleted/deactivated, returns `"Deleted member"`.
- `handle`: Server-generated lowercase alphanumeric string (e.g. `ayat_n4821`).
- `photoUrl`: Primary approved public photo, or first profile image, or `null` (app renders placeholder). For deleted members, returns `null`.
- `countryCode`: Lowercase ISO 3166-1 alpha-2 string (e.g. `"bd"`, `"gb"`, `"us"`, `"pk"`).
- `isMe`: `true` if `userId` matches the authenticated caller; `false` otherwise.

---

## 4. Phase 0: Identity + Topics (§3, §4)

### 4.1. My Feed Identity
Retrieve the authenticated user's Feed author object and handle.

- **Method & Path:** `GET /api/v1/me/feed-author` *(also available at `GET /api/v1/feed/me`)*
- **Auth:** Required (`Bearer <token>`)
- **Real Server Response:**
```json
{
  "statusCode": 200,
  "data": {
    "userId": "6af4469dac7e106dffb18fc4",
    "displayName": "Chat T.",
    "handle": "ayat_n4821",
    "photoUrl": null,
    "countryCode": "bd",
    "isVerified": true,
    "isMe": true
  },
  "message": "Feed author profile",
  "success": true
}
```

### 4.2. List Topics
Retrieve all active Feed categories for filter chips and post creation.

- **Method & Path:** `GET /api/v1/feed/topics`
- **Auth:** Required
- **Real Server Response:**
```json
{
  "statusCode": 200,
  "data": [
    {
      "id": "6af7febc521b62dbecd134ab",
      "name": "All things marriage",
      "slug": "all-things-marriage",
      "description": "Discussions, advice, and journeys towards Nikah",
      "imageUrl": null,
      "sortOrder": 1,
      "canPost": true
    },
    {
      "id": "6af7febc521b62dbecd134ac",
      "name": "Random",
      "slug": "random",
      "description": "Everyday thoughts, reflections, and chit-chat",
      "imageUrl": null,
      "sortOrder": 2,
      "canPost": true
    },
    {
      "id": "6af7febc521b62dbecd134ad",
      "name": "Fun & Laughs",
      "slug": "fun-and-laughs",
      "description": "Light-hearted halal humor and banter",
      "imageUrl": null,
      "sortOrder": 3,
      "canPost": true
    },
    {
      "id": "6af7febc521b62dbecd134ae",
      "name": "Converts / Reverts",
      "slug": "converts-reverts",
      "description": "Support, stories, and guidance for new Muslims",
      "imageUrl": null,
      "sortOrder": 4,
      "canPost": true
    },
    {
      "id": "6af7febc521b62dbecd134af",
      "name": "Announcements",
      "slug": "announcements",
      "description": "Official team announcements and app updates",
      "imageUrl": null,
      "sortOrder": 5,
      "canPost": false
    }
  ],
  "message": "Feed topics",
  "success": true
}
```

---

## 5. Phase 1: Read-Only Feed (§5, §6, §7)

### 5.1. Posts List
Retrieve paged posts filtered by mode or topic. Automatically excludes posts from blocked or muted members.

- **Method & Path:** `GET /api/v1/feed/posts`
- **Query Parameters:**
  - `mode`: `"forYou"` (default) or `"new"` (reverse-chronological).
  - `topicId`: (Optional) Topic ObjectId.
  - `cursor`: (Optional) Next cursor ID.
  - `limit`: (Optional) Integer 1 to 50 (default 20).
- **Real Server Response:**
```json
{
  "statusCode": 200,
  "data": {
    "items": [
      {
        "id": "6af7ff0d521b62dbecd134b9",
        "author": {
          "userId": "6af44cb2ac7e106dffb19077",
          "displayName": "Chat T.",
          "handle": "khalil_k2210",
          "photoUrl": null,
          "countryCode": "bd",
          "isVerified": false,
          "isMe": false
        },
        "topic": {
          "id": "6af7febc521b62dbecd134ad",
          "name": "Fun & Laughs"
        },
        "body": "Tea always wins at 3 AM. Agree or disagree?",
        "createdAt": "2026-11-14T06:26:21.848Z",
        "editedAt": null,
        "likeCount": 12,
        "commentCount": 3,
        "viewCount": 382,
        "likedByMe": true,
        "isMine": false,
        "topComment": {
          "id": "6af7ff0d521b62dbecd134c1",
          "author": {
            "userId": "6af4469dac7e106dffb18fc4",
            "displayName": "Chat T.",
            "handle": "ayat_n4821",
            "photoUrl": null,
            "countryCode": "bd",
            "isVerified": true,
            "isMe": true
          },
          "body": "Tea always wins. Especially with ginger and cardamom.",
          "likeCount": 4,
          "createdAt": "2026-11-14T06:26:21.879Z"
        }
      }
    ],
    "nextCursor": "6af7ff0d521b62dbecd134b9",
    "hasMore": false
  },
  "message": "Feed posts",
  "success": true
}
```

### 5.2. Get One Post by ID
- **Method & Path:** `GET /api/v1/feed/posts/:postId`
- **Error Codes:**
  - `404 POST_NOT_FOUND`: Post does not exist.
  - `410 POST_DELETED`: Post has been deleted.
  - `403 BLOCKED`: Either author or viewer has blocked the other.
- **Real Server Response:**
```json
{
  "statusCode": 200,
  "data": {
    "id": "6af7ff0d521b62dbecd134b9",
    "author": {
      "userId": "6af44cb2ac7e106dffb19077",
      "displayName": "Chat T.",
      "handle": "khalil_k2210",
      "photoUrl": null,
      "countryCode": "bd",
      "isVerified": false,
      "isMe": false
    },
    "topic": {
      "id": "6af7febc521b62dbecd134ad",
      "name": "Fun & Laughs"
    },
    "body": "Tea always wins at 3 AM. Agree or disagree?",
    "createdAt": "2026-11-14T06:26:21.848Z",
    "editedAt": null,
    "likeCount": 12,
    "commentCount": 3,
    "viewCount": 382,
    "likedByMe": true,
    "isMine": false,
    "topComment": null
  },
  "message": "Post details",
  "success": true
}
```

### 5.3. Comments List (Top-Level with Inlined First 3 Replies)
- **Method & Path:** `GET /api/v1/feed/posts/:postId/comments?sort=popular|recent&cursor=&limit=`
- **Real Server Response:**
```json
{
  "statusCode": 200,
  "data": {
    "items": [
      {
        "id": "6af7ff0d521b62dbecd134c1",
        "postId": "6af7ff0d521b62dbecd134b9",
        "parentId": null,
        "author": {
          "userId": "6af4469dac7e106dffb18fc4",
          "displayName": "Chat T.",
          "handle": "ayat_n4821",
          "photoUrl": null,
          "countryCode": "bd",
          "isVerified": true,
          "isMe": true
        },
        "body": "Tea always wins. Especially with ginger and cardamom.",
        "mention": null,
        "createdAt": "2026-11-14T06:26:21.879Z",
        "editedAt": null,
        "isPostAuthor": false,
        "likeCount": 4,
        "replyCount": 2,
        "likedByMe": false,
        "isMine": true,
        "replies": [
          {
            "id": "6af7ff0d521b62dbecd134c5",
            "postId": "6af7ff0d521b62dbecd134b9",
            "parentId": "6af7ff0d521b62dbecd134c1",
            "author": {
              "userId": "6af44cb2ac7e106dffb19077",
              "displayName": "Chat T.",
              "handle": "khalil_k2210",
              "photoUrl": null,
              "countryCode": "bd",
              "isVerified": false,
              "isMe": false
            },
            "body": "Cardamom is non-negotiable! The secret to good karak chai.",
            "mention": {
              "userId": "6af4469dac7e106dffb18fc4",
              "handle": "ayat_n4821"
            },
            "createdAt": "2026-11-14T06:26:21.890Z",
            "editedAt": null,
            "isPostAuthor": true,
            "likeCount": 2,
            "replyCount": 0,
            "likedByMe": false,
            "isMine": false,
            "replies": []
          }
        ]
      }
    ],
    "nextCursor": null,
    "hasMore": false
  },
  "message": "Comments",
  "success": true
}
```

### 5.4. Additional Replies to Comment
- **Method & Path:** `GET /api/v1/feed/comments/:commentId/replies?cursor=&limit=`
- **Real Server Response:**
```json
{
  "statusCode": 200,
  "data": {
    "items": [
      {
        "id": "6af7ff0d521b62dbecd134c8",
        "postId": "6af7ff0d521b62dbecd134b9",
        "parentId": "6af7ff0d521b62dbecd134c1",
        "author": {
          "userId": "6af4469dac7e106dffb18fc4",
          "displayName": "Chat T.",
          "handle": "ayat_n4821",
          "photoUrl": null,
          "countryCode": "bd",
          "isVerified": true,
          "isMe": true
        },
        "body": "Glad we agree on the important life questions.",
        "mention": {
          "userId": "6af44cb2ac7e106dffb19077",
          "handle": "khalil_k2210"
        },
        "createdAt": "2026-11-14T06:26:21.902Z",
        "editedAt": null,
        "isPostAuthor": false,
        "likeCount": 1,
        "replyCount": 0,
        "likedByMe": false,
        "isMine": true,
        "replies": []
      }
    ],
    "nextCursor": null,
    "hasMore": false
  },
  "message": "Replies",
  "success": true
}
```

---

## 6. Phase 2: Create, Like, Edit, Delete Posts (§8, §9, §10, §11)

### 6.1. Create a Post
- **Method & Path:** `POST /api/v1/feed/posts`
- **Body:**
  ```json
  {
    "topicId": "6af7febc521b62dbecd134ab",
    "body": "What are your recommended book titles for young couples?"
  }
  ```
- **Rules:**
  - `body`: 1 to 5000 characters, trimmed.
  - Rate limit: 30 posts per hour. If exceeded, returns `429 RATE_LIMITED`.
- **Response:** `201 Created` with post object.

### 6.2. Like / Unlike Post (Idempotent)
- **Like:** `PUT /api/v1/feed/posts/:postId/like` &rarr; `200 OK`
  ```json
  { "statusCode": 200, "data": { "liked": true, "likeCount": 13 }, "message": "Post liked", "success": true }
  ```
- **Unlike:** `DELETE /api/v1/feed/posts/:postId/like` &rarr; `200 OK`
  ```json
  { "statusCode": 200, "data": { "liked": false, "likeCount": 12 }, "message": "Post unliked", "success": true }
  ```

### 6.3. Edit My Post
- **Method & Path:** `PATCH /api/v1/feed/posts/:postId`
- **Body:** `{ "body": "Updated content text" }`
- **Rules:**
  - Author only (`403 NOT_ALLOWED` if not author).
  - 15-minute window (`403 EDIT_WINDOW_EXPIRED` if older).
  - Topic cannot be edited.
- **Response:** `200 OK` with updated post object (`editedAt: "<ISO Date>"`).

### 6.4. Delete My Post
- **Method & Path:** `DELETE /api/v1/feed/posts/:postId`
- **Rules:** Author only. Sets `isDeleted: true` and `deletedAt`.
- **Response:** `204 No Content`.

### 6.5. Record Views (Batched)
- **Method & Path:** `POST /api/v1/feed/posts/views`
- **Body:** `{ "postIds": ["6af7ff0d521b62dbecd134b9"] }`
- **Response:** `200 OK` `{ "statusCode": 200, "data": { "viewed": 1 }, "message": "Views recorded", "success": true }`

---

## 7. Phase 3: Comments & Replies (§12)

### 7.1. Create Comment / Reply
- **Method & Path:** `POST /api/v1/feed/posts/:postId/comments`
- **Body:**
  ```json
  {
    "body": "Assalamu alaykum!",
    "parentId": "6af7ff0d521b62dbecd134c1",      // Optional: parent comment ID for replies
    "mentionUserId": "6af4469dac7e106dffb18fc4"  // Optional: user being replied to
  }
  ```
- **Rules:** Max 2000 chars. Increments post `commentCount` and parent `replyCount`. Blocked members receive `403 BLOCKED`.
- **Response:** `201 Created` with comment object.

### 7.2. Edit / Delete Comment
- **Edit:** `PATCH /api/v1/feed/comments/:commentId` `{ "body": "..." }` &rarr; `200 OK` (15-min window, `EDIT_WINDOW_EXPIRED`).
- **Delete:** `DELETE /api/v1/feed/comments/:commentId` &rarr; `204 No Content`. Decrements post `commentCount` and parent `replyCount`.

### 7.3. Like / Unlike Comment
- `PUT /api/v1/feed/comments/:commentId/like` &rarr; `200 OK` `{ liked: true, likeCount: 5 }`.
- `DELETE /api/v1/feed/comments/:commentId/like` &rarr; `200 OK` `{ liked: false, likeCount: 4 }`.

---

## 8. Phase 4: Feed Profile, Follow, Search & Marriage Access (§13–§16)

### 8.1. Feed User Profile Header
- **Method & Path:** `GET /api/v1/feed/users/:userId`
- **Real Server Response:**
```json
{
  "statusCode": 200,
  "data": {
    "userId": "6af44cb2ac7e106dffb19077",
    "displayName": "Chat T.",
    "handle": "khalil_k2210",
    "photoUrl": null,
    "countryCode": "bd",
    "isVerified": false,
    "isMe": false,
    "countryName": "Bangladesh",
    "joinedAt": "2026-11-12T05:22:26.541Z",
    "followersCount": 1,
    "followingCount": 0,
    "postsCount": 2,
    "commentsCount": 1,
    "likesCount": 17,
    "isFollowing": true,
    "followsMe": false
  },
  "message": "Feed user profile",
  "success": true
}
```

### 8.2. Profile Activity Tabs
- **Posts Tab:** `GET /api/v1/feed/users/:userId/posts?cursor=&limit=` &rarr; Paged posts by this user.
- **Comments Tab:** `GET /api/v1/feed/users/:userId/comments?cursor=&limit=` &rarr; Paged comments by this user with post preview (`{ comment, post: { id, authorDisplayName, bodyPreview } }`).
- **Likes Tab:** `GET /api/v1/feed/users/:userId/likes?cursor=&limit=` &rarr; Paged liked posts (private; returns empty array if not owner).

### 8.3. Follow / Unfollow (Idempotent)
- `PUT /api/v1/feed/users/:userId/follow` &rarr; `{ following: true, followersCount: 2 }`. (Cannot follow self &rarr; `400 CANNOT_FOLLOW_SELF`; blocked &rarr; `403 BLOCKED`). Does NOT create a Marriage like.
- `DELETE /api/v1/feed/users/:userId/follow` &rarr; `{ following: false, followersCount: 1 }`.

### 8.4. Followers & Following Lists
- `GET /api/v1/feed/users/:userId/followers?cursor=&limit=` &rarr; `{ items: [AuthorObject], nextCursor, hasMore }`.
- `GET /api/v1/feed/users/:userId/following?cursor=&limit=` &rarr; `{ items: [AuthorObject], nextCursor, hasMore }`.

### 8.5. Feed Search
- **Search Posts:** `GET /api/v1/feed/search?q=advice&type=posts` &rarr; `{ items: [PostObject] }`.
- **Search People:** `GET /api/v1/feed/search?q=khalil&type=people` &rarr; `{ items: [AuthorObject] }`.
- **Search within User's Feed:** `GET /api/v1/feed/users/:userId/search?q=cardamom&type=comments`.

### 8.6. Marriage Profile Access Model (§13)
When opening a member's Marriage Profile from Feed or Deck, the server calculates viewer access and withholds locked sections:

- **Method & Path:** `GET /api/v1/profiles/:userId`
- **Payload Shape:**
```json
{
  "statusCode": 200,
  "data": {
    "userId": "6af44cb2ac7e106dffb19077",
    "fullName": "Chat TesterF",
    "access": {
      "level": "full",
      "reason": null,
      "unlockable": false,
      "lockedSections": []
    },
    "images": [ ... ],
    "marriageIntentions": { ... }
  }
}
```
- If access is restricted (e.g. same gender, not eligible):
  ```json
  "access": {
    "level": "partial",
    "reason": "NOT_ELIGIBLE",
    "unlockable": false,
    "lockedSections": ["marriageIntentions", "partnerPreference"]
  }
  ```
  The server **removes** `marriageIntentions` and `partnerPreference` from the payload, preventing client-side data leaks.

---

## 9. Phase 5: Safety, Mute, Reports & Universal Links (§17–§19)

### 9.1. Mute / Unmute Member Posts
- `PUT /api/v1/feed/users/:userId/mute` &rarr; `200 OK` `{ muted: true }`. Hides this member's posts from caller's feed without notifying them.
- `DELETE /api/v1/feed/users/:userId/mute` &rarr; `200 OK` `{ muted: false }`.

### 9.2. Report Content (Posts, Comments, Users)
- **Method & Path:** `POST /api/v1/reports`
- **Body:**
  ```json
  {
    "targetType": "post",                           // "post" | "comment" | "feedUser" | "user"
    "postId": "6af7ff0d521b62dbecd134b9",           // or commentId / targetUserId
    "reason": "inappropriate_content",
    "description": "Unsuitable discussion topic"
  }
  ```
- **Allowed Reasons:**
  `fake_profile`, `harassment`, `inappropriate_content`, `inappropriate_photo`, `spam`, `underage`, `already_married`, `other`.
- **Response:** `201 Created` (or `409 DUPLICATE_REPORT` if open report exists). Auto-quarantines post after 5 unique member reports.

### 9.3. Universal / Share Link Formats (§18)
- **Post Link:** `https://findanikah.app/feed/post/:postId`
- **Profile Link:** `https://findanikah.app/feed/u/:userId`
- Deep linking: Route directly in-app using the entity ID via `GET /feed/posts/:postId` or `GET /feed/users/:userId`. If app is not installed, web route displays App Store / Play Store download banner.

---

## 10. Complete Error Code Dictionary

| HTTP Status | Error Code | Trigger Condition | Mobile App Action |
| :---: | :--- | :--- | :--- |
| **404** | `POST_NOT_FOUND` | Post ID does not exist in DB | Show toast, remove card from feed |
| **410** | `POST_DELETED` | Post was deleted by author | Show "This post was deleted", drop from list |
| **404** | `COMMENT_NOT_FOUND` | Comment ID does not exist | Show toast, refresh comments |
| **404** | `TOPIC_NOT_FOUND` | Invalid topic ID provided | Refresh topic chips |
| **403** | `BLOCKED` | Either user blocked the other | Hide card, block interaction |
| **403** | `NOT_ALLOWED` | User attempted to edit/delete another user's content | Restrict menu options |
| **403** | `EDIT_WINDOW_EXPIRED`| Edit attempted after 15 minutes | Show "Edits are only allowed within 15 minutes" |
| **429** | `RATE_LIMITED` | Exceeded 30 posts per hour | Show "You are posting too fast. Please wait." |
| **400** | `VALIDATION_FAILED` | Empty body or exceeded max length (5000 post / 2000 comment) | Highlight input field |
| **400** | `CANNOT_FOLLOW_SELF`| User attempted to follow their own account | Hide follow button for self |
| **409** | `DUPLICATE_REPORT` | User already has an open report on this target | Show toast "You already reported this" |

---

## 11. Flutter / Dart DTO Reference Examples

```dart
class FeedAuthorDto {
  final String userId;
  final String displayName;
  final String handle;
  final String? photoUrl;
  final String countryCode;
  final bool isVerified;
  final bool isMe;

  FeedAuthorDto({
    required this.userId,
    required this.displayName,
    required this.handle,
    this.photoUrl,
    required this.countryCode,
    required this.isVerified,
    required this.isMe,
  });

  factory FeedAuthorDto.fromJson(Map<String, dynamic> json) => FeedAuthorDto(
    userId: json['userId'],
    displayName: json['displayName'],
    handle: json['handle'],
    photoUrl: json['photoUrl'],
    countryCode: json['countryCode'] ?? 'bd',
    isVerified: json['isVerified'] ?? false,
    isMe: json['isMe'] ?? false,
  );
}

class FeedPostDto {
  final String id;
  final FeedAuthorDto author;
  final String topicId;
  final String topicName;
  final String body;
  final DateTime createdAt;
  final DateTime? editedAt;
  final int likeCount;
  final int commentCount;
  final int viewCount;
  final bool likedByMe;
  final bool isMine;
  final Map<String, dynamic>? topComment;

  FeedPostDto({
    required this.id,
    required this.author,
    required this.topicId,
    required this.topicName,
    required this.body,
    required this.createdAt,
    this.editedAt,
    required this.likeCount,
    required this.commentCount,
    required this.viewCount,
    required this.likedByMe,
    required this.isMine,
    this.topComment,
  });

  factory FeedPostDto.fromJson(Map<String, dynamic> json) => FeedPostDto(
    id: json['id'],
    author: FeedAuthorDto.fromJson(json['author']),
    topicId: json['topic']['id'],
    topicName: json['topic']['name'],
    body: json['body'],
    createdAt: DateTime.parse(json['createdAt']),
    editedAt: json['editedAt'] != null ? DateTime.parse(json['editedAt']) : null,
    likeCount: json['likeCount'] ?? 0,
    commentCount: json['commentCount'] ?? 0,
    viewCount: json['viewCount'] ?? 0,
    likedByMe: json['likedByMe'] ?? false,
    isMine: json['isMine'] ?? false,
    topComment: json['topComment'],
  );
}
```

ey Decisions & Architectural Answers
§10: Edit Time Limit:
15 minutes from post/comment creation.
After 15 minutes, requests return 403 with { code: "EDIT_WINDOW_EXPIRED", message: "Posts cannot be edited after 15 minutes" }.
Topics cannot be changed on edit (only body). editedAt is recorded in UTC.
§13: Locked Marriage Profile Access & Data Withholding:
Server-side data withholding: GET /api/v1/profiles/:userId returns an access object: { "level": "full" | "partial" | "locked", "reason": null | "NOT_ELIGIBLE" | "BLOCKED" | "NOT_IN_FILTERS" | "HIDDEN" | "PREMIUM_REQUIRED", "unlockable": false, "lockedSections": ["marriageIntentions", "partnerPreference"] }.
Sensitive locked fields and photos are withheld on the server (omitted/null or blurred). The app never receives real hidden data. Profile visits from Feed are recorded with source "feed".
§5: "For You" Ranking & Stable Paging:
Ranked by freshness and engagement: Score = (likeCount * 2 + commentCount * 3 + viewCount * 0.1).
Reverse seek on _id < cursor guarantees stable cursor pagination without duplicate items across page boundaries. Mode new is strictly reverse-chronological by createdAt.
§19: Non-Matched Messaging Rule:
Tapping "Message" on a non-matched author does not open a free direct chat.
For free members: opens the compliment / swipe sheet (POST /api/v1/profiles/swipe { action: "complement", targetUserId, text }).
Gold/Premium members with canMessageBeforeMatch entitlement can open direct conversations.
§22: Content Moderation & Repeated Reports:
When a post receives 5 unique member reports (reportCount >= 5), it is automatically quarantined (isAutoHidden: true) and vanishes from all feeds pending moderator review.
Reporting a post immediately hides it from the reporter's feed.
§14: Likes Privacy:
User likes are private. GET /api/v1/feed/users/:userId/likes returns liked posts only when the caller views their own profile (userId === callerId). For other users, it returns an empty array.
Verified Endpoint Summary by Phase
Phase	Purpose	Method & Path	Status
0	Feed Identity	GET /api/v1/me/feed-author (and GET /feed/me)	✅ Live
0	Topics	GET /api/v1/feed/topics	✅ Live
1	Posts Feed	GET /api/v1/feed/posts?mode=forYou|new&topicId=&cursor=&limit=	✅ Live
1	Post by ID	GET /api/v1/feed/posts/:postId (404 POST_NOT_FOUND, 410 POST_DELETED)	✅ Live
1	Comments	GET /api/v1/feed/posts/:postId/comments?sort=popular|recent	✅ Live
1	Replies	GET /api/v1/feed/comments/:commentId/replies?cursor=&limit=	✅ Live
2	Create Post	POST /api/v1/feed/posts { topicId, body } (rate limit: 30/hr)	✅ Live
2	Like / Unlike	PUT / DELETE /api/v1/feed/posts/:postId/like (idempotent)	✅ Live
2	Edit / Delete	PATCH / DELETE /api/v1/feed/posts/:postId (15-min window / 204)	✅ Live
2	Views	POST /api/v1/feed/posts/views { postIds: [...] }	✅ Live
3	Write Comment	POST /api/v1/feed/posts/:postId/comments { body, parentId?, mentionUserId? }	✅ Live
3	Edit / Delete	PATCH / DELETE /api/v1/feed/comments/:commentId	✅ Live
3	Comment Likes	PUT / DELETE /api/v1/feed/comments/:commentId/like	✅ Live
4	Feed Profile	GET /api/v1/feed/users/:userId	✅ Live
4	User Tabs	GET /api/v1/feed/users/:userId/posts, /comments, /likes	✅ Live
4	Follow	PUT / DELETE /api/v1/feed/users/:userId/follow, /followers, /following	✅ Live
4	Search	GET /api/v1/feed/search?q=&type=posts|people, /users/:userId/search	✅ Live
4	Marriage Access	GET /api/v1/profiles/:userId (with access object & withheld locked data)	✅ Live
5	Mute Member	PUT / DELETE /api/v1/feed/users/:userId/mute	✅ Live
5	Report Post	POST /api/v1/reports { targetType: "post", postId, reason, description }	✅ Live
Verification & Test Accounts
Base URL: http://localhost:5001/api/v1
User A (Viewer): user@example.com / user1234 (_id: 6af4469dac7e106dffb18fc4, handle: @ayat_n4821, Display: Chat T.)
User B (Author): user1@example.com / user1234 (_id: 6af44cb2ac7e106dffb19077, handle: @khalil_k2210, Display: Chat T.)
Seeded Active Post with Nested Replies: ID 6af7ff0d521b62dbecd134b9
Seeded Deleted Post (for 410 checks): ID 6af7ff0d521b62dbecd134bd

All automated test suites pass with 100% success rate:

Feed Tab Suite: test-feed-suite.js → 75 Passed, 0 Failed
Chat & Receipts Suite: test-round3-chat.js → 37 Passed, 0 Failed
Marriage Deck Suite: test-marriage-tab.js → 55 Passed, 0 Failed

