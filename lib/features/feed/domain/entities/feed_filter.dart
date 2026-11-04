import 'package:equatable/equatable.dart';
import 'package:find_a_nikah/features/feed/domain/entities/feed_topic.dart';

/// What the feed is showing — one per chip under the title.
sealed class FeedFilter extends Equatable {
  const FeedFilter();

  const factory FeedFilter.forYou() = FeedForYou;
  const factory FeedFilter.newest() = FeedNewest;
  const factory FeedFilter.topic(FeedTopic topic) = FeedTopicFilter;
}

final class FeedForYou extends FeedFilter {
  const FeedForYou();

  @override
  List<Object?> get props => [];
}

final class FeedNewest extends FeedFilter {
  const FeedNewest();

  @override
  List<Object?> get props => [];
}

final class FeedTopicFilter extends FeedFilter {
  const FeedTopicFilter(this.topic);

  final FeedTopic topic;

  @override
  List<Object?> get props => [topic];
}
