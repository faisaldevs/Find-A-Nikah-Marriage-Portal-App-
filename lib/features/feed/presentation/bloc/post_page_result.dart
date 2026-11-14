import 'package:find_a_nikah/features/feed/domain/domain.dart';

/// What the post page tells the screen it was opened from, so a list can
/// follow along (new like / comment counts, a deleted post, a hidden
/// author) without reloading.
class PostPageResult {
  const PostPageResult({this.post, this.removedPostId, this.hiddenUserId});

  /// The post as it is now (counts, edits).
  final FeedPost? post;

  /// The post was deleted or reported — drop it from the list.
  final String? removedPostId;

  /// The author was muted or blocked — drop all of their posts.
  final String? hiddenUserId;
}
