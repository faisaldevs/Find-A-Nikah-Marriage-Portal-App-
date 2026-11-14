# Outdated code (kept just in case)

- `dummy_feed_data_source.dart.txt` — the Feed's in-memory dummy data source
  (Figma copy, pravatar portraits). Replaced by `FeedRemoteDataSource` on
  2026-11-14. Rename to `.dart` and adapt to the new entities to use it again
  (it targets the old `FeedAuthor`/`FeedPost` shape: `handle`-as-id,
  `postedAgo` strings, `anonymous`).
