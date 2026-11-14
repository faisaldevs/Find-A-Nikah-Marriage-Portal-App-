# Feed — current state

Updated 2026-11-14, after integrating the live API. What was checked on the
phone: [07_VERIFICATION_LOG.md](07_VERIFICATION_LOG.md).

## Summary

The Feed runs on the **real API** (`/v1/feed/...`, plus `/v1/me/feed-author`,
`/v1/profiles/:userId`, `/v1/reports`, `/v1/blocks/:id`). The dummy data source
was retired (kept in `resources/outdated_code/`). Notifications, saved posts,
groups, media, moderation tooling and anonymous posts are out of v1.

## Screens

| Route | Screen | Notes |
|---|---|---|
| `/feed` | Feed list, topic chips, top-bar search, compose button | cursor paging, pull-to-refresh, optimistic like, views batched |
| `/feed/post/:postId` | Post + comments | opened **by id** (card may pass the post as `extra`); pops a `PostPageResult` so the list follows; composer with reply / edit modes; own-comment menu |
| `/feed/compose` | New post, or edit (extra = the post) | text only; read-only topics hidden; 5000-char limit; edit keeps the topic |
| `/feed/profile/:userId` | Member profile | **Feed activity** (Posts · Comments · Likes on your own) and **Marriage profile** (real data + `access` lock UI) |
| `/feed/profile/:userId/search` | Search one member's posts / comments | server search, debounced, paged |

Post menu: **mine** → Share · Edit (within 15 min) · Delete; **others** → Share · Mute · Block · Report (reason sheet). Comment menu: mine → Edit · Delete; others → Report.

## Code layout (`lib/features/feed/`)

- `domain/` — entities (`FeedAuthor` with `userId`, `FeedPost`, `FeedComment`, `FeedProfile`, `FeedMarriageProfile` + `FeedMarriageAccess`, `FeedPaged`, `ToggleResult`), `feedTimeAgo`, `FeedRepository`.
- `data/` — `FeedRemoteDataSource` (Dio), `dtos/feed_dtos.dart` (json_serializable), `FeedMapper`, `FeedMarriageMapper`, `FeedRepositoryImpl` (Guard). 410 is mapped to not-found in `dio_exception_mapper.dart`.
- `presentation/bloc/` — `FeedBloc`, `PostDetailBloc`, `ProfileBloc`, `MemberSearchBloc`, `CreatePostBloc`, shared `FeedListState` / `FeedNotice`.
- `presentation/` pages + widgets; `feed_marriage_preview.dart` is a **copy** of Menu's Preview (features can't import each other) — to be replaced by the shared `profile_view`.
- Routing: id-based paths in `lib/router/route_paths.dart` (`RoutePaths.isAppLocation` lets the redirect accept them).
- Tests: `test/features/feed/` (domain, data, presentation) and `test/router/feed_routes_test.dart`.

## Known pre-existing failures (not Feed)

`test/architecture/layer_boundaries_test.dart` (needs a `packages/` folder) and
`test/router/app_redirect_test.dart` "new user" fail on the last commit too.
