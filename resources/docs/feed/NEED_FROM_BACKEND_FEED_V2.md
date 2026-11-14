# Need from backend — Feed, round 2 (after integrating your reply)

**Audience:** the engineer / AI who owns the Find A Nikah backend.
**Written:** 2026-11-14 by the mobile (Flutter) side, **after** building the Feed against your live dev server and your `FEED_MOBILE_IMPLEMENTATION_PLAN.md`.

Thank you — the integration went smoothly. **Verified on a real phone against your dev server:** feed list (For you / New / topic), post by id, comments with nested replies and mentions, like/unlike (optimistic), create / edit / delete a post, add / delete a comment, member profile with counters and the Comments tab, and the Marriage profile with `access`. About 100 automated tests pass against payloads copied from your responses.

This file lists only what is **still unknown or wrong**. Items are numbered **BE-n**. `P0` = a visible bug or blocks a feature, `P1` = unclear in an edge case, `P2` = nice to have. Please answer in this file or by number.

---

## P0 — bugs we hit

### BE-1. Seeded counts disagree with real like records
- **Today:** a seeded post showed `likeCount: 8`. After we liked and then unliked it, the server answered `likeCount: 1` and then `0`. Another showed `12`; one unlike made it `0`. The seeded number is not backed by like records, so the first real like or unlike resets it.
- **Need:** make `likeCount` (and `commentCount`, `replyCount`, `viewCount`) always derived from, or kept in sync with, real records — in the **list, single post, comments, and the toggle responses**. If seeded numbers are meant for demos, seed the matching rows.
- **Why:** the app shows the count from the list and replaces it with the toggle response; a mismatch looks like the app is wrong.

### BE-2. Create and edit responses name the wrong topic
- **Today:** `POST /feed/posts` with `topicId` = *Random* returned a post whose `topic.name` was **"General"**. `GET /feed/posts` and `GET /feed/posts/:id` for the same post correctly say *Random*. `PATCH /feed/posts/:id` also returned "General".
- **Need:** return the real topic (`{id, name}`) from create and edit, same as reads. Also confirm the other fields in those responses match a read (`likedByMe`, `isMine`, counts).
- **Why:** the card is built from the response; we now override it locally, but the bug would bite other clients.

### BE-3. `topComment` in post lists has no `replyCount`
- **Today:** `topComment` is `{id, author, body, likeCount, createdAt}`. We show "N Replies" in the preview.
- **Need:** add `replyCount` (and `likedByMe`) to `topComment`, or confirm the shape is final so we hide it (we do now).

---

## P0 — blocks the locked-profile UI

### BE-4. A real locked / partial `GET /profiles/:userId` sample
- **Today:** we only saw `access.level: "full"`. We built the lock UI (notice + blurred placeholders for each `lockedSections`) from your description and tested the mapping on a made-up payload.
- **Need:** a **real copy-pasted response** for each: `partial` (e.g. `NOT_ELIGIBLE`), `locked` (e.g. `BLOCKED` or `PREMIUM_REQUIRED`), and one where **photos** are locked. In particular: what is `photos`/`profile.images` when locked — omitted, empty, or a **pre-blurred URL** (which field)? Which top-level keys remain (name? age? country?) so we know what the header can still show.
- **Also:** the exact list of `reason` values and of `lockedSections` names (we currently humanise unknown names).
- **Need a test account** whose view of another account is `partial` and one that is `locked` (same-gender and blocked are enough), plus their credentials.

### BE-5. How is a visit from Feed marked `source: "feed"`?
- You said Feed visits are recorded with source `feed`. The app calls plain `GET /profiles/:userId`. Is there a query param (`?source=feed`) or header we must send? Otherwise Explore's "Visited you" will not distinguish them.

---

## P1 — unclear behaviour

### BE-6. Deletes — still unanswered from round 1
1. Deleting a **post**: what happens to its comments, likes, reports? (We drop it from every list.)
2. Deleting a **top-level comment**: are its replies removed, or kept as orphans? (We remove them from the screen and lower the post count by 1 + replies — **please confirm that is what `commentCount` does**.)
3. Deleting a **reply**: confirm `replyCount` of the parent decreases.

### BE-7. Block, mute and the member's own state
1. We block from Feed with the existing `POST /v1/blocks/:userId`. Confirm that is right, and that after a block the member's posts/comments **disappear from every Feed response** (feed, search, comments, profile tabs) and that you vanish for them.
2. Unblock: which endpoint? (Feed has no UI, but Menu's blocked list exists.)
3. **`isMuted` is not in any response.** The profile menu shows "Mute / Unmute posts from X" but cannot know the state after reopening. Please add `isMuted` (and `isBlocked` if applicable) to `GET /feed/users/:userId`, or give a `GET /feed/mutes` list.
4. `POST /reports`: the post/comment/user shapes we send are in the appendix. We have **not** sent a live report (side effects). Please give us a safe way to test (a sandbox target, or a note that reports on the seeded "deleted post" are harmless) and confirm the exact field names (`postId`/`commentId`/`targetUserId`, plus `reportedUserId` for members as in Marriage).

### BE-8. "For you" paging — cannot verify with 5 posts
- Your notes say ranking uses an engagement score but paging seeks on `_id`; the sample returned `nextCursor` even with `hasMore: false`. With 5 posts we can't test it.
- **Need:** seed **≥ 60 posts** (mixed likes/comments/views) on the dev server, and tell us whether paging `For you` can ever repeat or skip a post. We stop on `hasMore` and ignore `nextCursor` when it is false.
- Also: comments paging with **> 20 top-level comments** and a comment with **> 3 replies** (to exercise `GET /comments/:id/replies`).

### BE-9. Share links
- App-side we share `https://findanikah.app/feed/post/:id` and `/feed/u/:userId`. For links to open the app we need **Android App Links** (`/.well-known/assetlinks.json`) and **iOS associated domains** (`apple-app-site-association`) on `findanikah.app` — is the domain live, and who owns those files? What does the page show for a post when the app isn't installed?

### BE-10. Views
- The app sends `POST /feed/posts/views` for posts that appear in the list (batched, once per post per session) and records one when a post is opened. A post's `viewCount` went 382 → 383 → 385 during our tests.
- Confirm: is a view **de-duplicated per member** (per day / ever)? Do impressions and opens count the same? Do own views of my own posts count?

### BE-11. Messaging from a Feed profile
- Your answer: matched → chat; unmatched → compliment sheet; entitled → direct chat. The profile response has `isMatch` + `matchId`, but not what the **Message button** should do for this viewer.
- **Need:** a single field on `GET /feed/users/:userId` (or the profile), e.g. `messageAction: "chat" | "compliment" | "upgrade" | "none"` plus `conversationId` when it is `chat`, so the app doesn't re-implement entitlement rules. Until then the button shows "coming soon".

### BE-12. Verified badge
- Feed authors return `isVerified: false` for an account whose profile has `faceVerification.isFaceVerified: true`. Which field means "show the blue tick" on Feed? Please make Feed and Marriage agree.

---

## P2 — nice to have

- **BE-13. Image sizes.** Author photos are full-size uploads used at 24–64 px. Can you give a thumbnail variant (`photoUrl` + `photoThumbUrl`, or a `?w=` parameter)? It will speed the list.
- **BE-14. People search.** `GET /feed/search?type=people` works; the app doesn't show people results yet. Should it (search tabs *Posts | People*)? Min query length and ranking?
- **BE-15. Followers / following lists.** Endpoints exist; the counts in the header will become tappable lists. Confirm `isFollowing` on each item so the list can show Follow buttons.
- **BE-16. Comment limits.** Rate limit for comments and replies (posts are 30/hour) and its `code`.
- **BE-17. Mentions.** `mention` is `{userId, handle}`; is it only set by `mentionUserId` on create, or does the server also parse `@handle` in the body?

---

## What the app sends (for your logs)

- Base: `API_BASE_URL` + `/v1/...` (the app uses the ngrok URL from its env file).
- Reports: `POST /v1/reports`
  - post: `{targetType:"post", postId, reason, description?}`
  - comment: `{targetType:"comment", commentId, reason, description?}`
  - member: `{targetType:"feedUser", targetUserId, reportedUserId, reason, description?}`
- Likes / follow / mute: `PUT` to set, `DELETE` to clear (idempotent), body-less.
- Paging: `?cursor=&limit=20`; we stop when `hasMore` is false.

## Reply format

Please answer in this file or in `FEED_MOBILE_IMPLEMENTATION_PLAN_V2.md`, per **BE-n**, with copy-pasted example responses for BE-1, BE-2, BE-4.
