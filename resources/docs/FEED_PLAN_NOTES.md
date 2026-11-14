# Feed — planning notes (saved 2026-11-14)

**Status:** discussion only. **No code changed, no backend doc written yet.**
This file records everything agreed/learned so far so work can resume after
code changes. Next step: answer the open decisions (§5), then write
`NEED_FROM_BACKEND_FEED.md`, `FEED_PROGRESS.md` and the `PENDING.md` entries.

## 1. Current state (verified 2026-11-14, device 08201FDD4005BA, app `com.findanikah.app`)

- `lib/features/feed/` has data / domain / presentation, but data is
  `DummyFeedDataSource` only. Nothing calls the network.
- Repository (`FeedRepository`): `fetchMe`, `fetchTopics`, `fetchPosts(filter)`,
  `fetchComments(postId, sort)`, `fetchProfile(handle)`, `fetchProfilePosts(handle)`,
  `createPost(topic, body, anonymous)`.
- Entities: `FeedAuthor` (name, handle = id, photoUrl, countryCode), `FeedPost`,
  `FeedComment` (1 level of replies, mention, edited, isPostAuthor), `FeedProfile`
  (author, countryName, joined, followers, following), `FeedTopic`, `FeedFilter`
  (forYou / newest / topic), `CommentSort` (mostPopular / mostRecent).
- Screens: `/feed` (chips: For you · New · topics e.g. Random, All things
  marriage), `/feed/post`, `/feed/compose`, `/feed/profile`, `/feed/profile/search`.
- Every action shows a "… — coming soon" toast: like post, like comment, comment,
  reply, share, follow, post options (report/hide/…), message author,
  notifications bell, "more comments".
- `APP_STATUS.md` §9 + its endpoint wish-list (≈ line 409) already list the
  intended endpoints: `/v1/feed/topics`, `/v1/feed/posts`, comments, likes,
  `/v1/feed/users/{handle}[/posts|/follow]`, `/v1/feed/search`, `/v1/me/feed-author`,
  `/v1/reports`.

## 2. Decisions made by the user

- Plan the **full** implementation, but **phased**: don't ask backend everything
  at once; don't break the app; keep flow working at every step.
- Keep a **tracker file** of done vs left (`resources/docs/FEED_PROGRESS.md`, to create).
- **No anonymous posts.** Every post is tied to the member (drop the anonymous
  toggle / `anonymous` param from the plan).
- Backend doc + a separate **mobile-gaps** section in the same file; ask backend
  to answer with `FEED_MOBILE_IMPLEMENTATION_PLAN.md` (same pattern as Marriage).
- Feed members **are the same users as Marriage** (one account).

## 3. Profile idea (under discussion)

User's proposal: one member profile shown from Feed, with the Feed view (posts,
comments, activity) and a button to open the Marriage profile; both share the
same base data, Feed adds activity data.

Claude's feedback / proposal:
- Fits the existing `profile_view` design in `PENDING.md` ("profile_view — shared
  member profile as its own feature", `/profile/:id`, embeddable `ProfileView`).
- **One profile page, segmented switch "Feed activity | Marriage profile".**
  Default tab depends on entry point: from Feed → Feed activity; from
  Marriage / Explore / Chat → Marriage profile.
- **Privacy gate on the Marriage tab** — otherwise tapping any commenter exposes
  their full marriage profile and bypasses discovery rules (blocks, filters,
  visibility). Options: (a) show only if the viewer could see them in discovery,
  (b) per-member opt-in setting, (c) always show.
- Feed profile by default shows: photo, display name, country, joined, followers,
  following, posts, comments. Age/city/details live behind the gate.
- `@handle` can be dropped: id = `userId`; handle is a backend-generated public
  display name — or keep a member-chosen handle (needs availability check +
  moderation).
- Name shown on posts: full / first + last initial / member's choice.
- Net effect: `GET /me/feed-author` becomes a derived view of the profile plus
  Feed counts; `profile_view` should move **ahead of** Feed Phase 4.

## 4. Proposed phases (each = its own backend ask; dummy stays behind a flag until the endpoint is verified live)

| Phase | Scope | Notes |
|---|---|---|
| 0 | Identity (`/me/feed-author` or profile-derived) + topics | gates everything else |
| 1 | Read-only: posts list (paged), post detail, comments list | replace dummy reads |
| 2 | Create post, like / unlike post | optimistic like |
| 3 | Comment, reply, like comment, edit/delete own | composer, "more comments" |
| 4 | Follow, author profile (+ `profile_view`), author posts, search | depends on §3 decision |
| 5 | Report / hide / block, share link, message author, notifications bell | reuse `/v1/reports`, chat deep link |

## 5. Open decisions (still need the user's answer)

1. Marriage tab on a Feed profile: always / only if viewer could see them in
   discovery / only if the member opts in?
2. Keep `@handle`? If yes: auto-generated or member-chosen?
3. Name on posts: full name / first + last initial / member's choice?
4. Segmented switch with default tab by entry point — yes/no?

## 6. Mobile-side gaps to fix/add (from reading code + device)

- No pagination: `fetchPosts` / `fetchComments` / `fetchProfilePosts` return a flat
  list; need cursor + `hasMore`, load-more, pull-to-refresh.
- Time is a display string (`postedAgo`, `joined`) and shows "1 days ago" —
  entities should carry `DateTime`; format in the UI (plural fix).
- Likes: no `likedByMe` field on post/comment, so no filled-heart state; add
  optimistic toggle with rollback.
- Add `isFollowing`, `isMine` (for edit/delete), `isHidden`, `editedAt` fields as
  the API allows.
- Comment composer is a toast; replies, mention picking, "more comments" paging,
  edit, delete are missing.
- Create post: drop anonymous toggle; add validation (length), error + retry,
  insert the new post at the top of the list on success.
- Post options sheet (report / hide / mute / block / copy link) has no actions;
  needs report reasons wired to `/v1/reports`.
- Share (post / comment / profile): needs a link scheme + deep link route.
- Message author: bridge to chat via the router/`extra`, not a feature import.
- Notifications bell: blocked on FCM / notifications feature.
- `FeedFilter` has For you / New / topic; the "Random" chip is a topic — confirm
  how backend models it.
- Caching: none yet (repo says network only); decide per ARCHITECTURE.md/guide 01
  cache table (page 1 of For you is the likely candidate).
- Empty / error / offline / shimmer states for each screen — verify what exists.
- View counts: define when the app reports a view (impression vs open) —
  needs an endpoint or backend-side counting.
- Real-time (new posts / comment counts) is **not** planned; if wanted, follow the
  Socket.IO rule (streams, never direct state writes).
- Tests: only dummy-based; add repository/bloc tests with the real DTOs.

## 7. Files to create when work resumes

- `resources/docs/NEED_FROM_BACKEND_FEED.md` (phase-by-phase asks, ends by asking
  for `FEED_MOBILE_IMPLEMENTATION_PLAN.md`).
- `resources/docs/FEED_PROGRESS.md` (per-endpoint: asked / answered / integrated /
  verified-on-device).
- Entry in `PENDING.md` linking to this file.
