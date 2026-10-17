import 'package:freezed_annotation/freezed_annotation.dart';

part 'feed_topic.freezed.dart';

/// A community topic, offered as a filter chip after "For you" / "New".
@freezed
abstract class FeedTopic with _$FeedTopic {
  const factory FeedTopic({
    required String id,
    required String name,

    /// Thumbnail shown inside the chip, if the topic has one. A network URL,
    /// or an `assets/` path for bundled dev data.
    String? imageUrl,
  }) = _FeedTopic;
}
