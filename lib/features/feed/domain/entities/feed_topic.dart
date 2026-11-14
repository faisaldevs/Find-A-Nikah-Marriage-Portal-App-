import 'package:equatable/equatable.dart';
import 'package:find_a_nikah/core/core.dart';

/// A community topic, offered as a filter chip after "For you" / "New" and
/// as the category a post is filed under.
class FeedTopic extends Equatable {
  const FeedTopic({
    required this.id,
    required this.name,
    this.imageUrl,
    this.canPost = true,
  });

  final String id;
  final String name;

  /// Thumbnail shown inside the chip, if the topic has one.
  final String? imageUrl;

  /// False for read-only topics (e.g. announcements): hidden from the
  /// compose picker.
  final bool canPost;

  FeedTopic copyWith({
    String? id,
    String? name,
    Object? imageUrl = unchanged,
    bool? canPost,
  }) {
    return FeedTopic(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: identical(imageUrl, unchanged)
          ? this.imageUrl
          : imageUrl as String?,
      canPost: canPost ?? this.canPost,
    );
  }

  @override
  List<Object?> get props => [id, name, imageUrl, canPost];
}
