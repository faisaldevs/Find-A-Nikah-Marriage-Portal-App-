import 'package:find_a_nikah/features/feed/domain/entities/feed_topic.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'feed_filter.freezed.dart';

/// What the feed is showing — one per chip under the title.
@freezed
sealed class FeedFilter with _$FeedFilter {
  const factory FeedFilter.forYou() = FeedForYou;
  const factory FeedFilter.newest() = FeedNewest;
  const factory FeedFilter.topic(FeedTopic topic) = FeedTopicFilter;
}
