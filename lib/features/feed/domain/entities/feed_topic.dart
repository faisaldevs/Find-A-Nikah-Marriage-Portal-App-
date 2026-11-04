import 'package:equatable/equatable.dart';
import 'package:find_a_nikah/core/core.dart';

/// A community topic, offered as a filter chip after "For you" / "New".
class FeedTopic extends Equatable {
  const FeedTopic({
    required this.id,
    required this.name,
    this.imageUrl,
  });

  final String id;
  final String name;

  /// Thumbnail shown inside the chip, if the topic has one. A network URL,
  /// or an `assets/` path for bundled dev data.
  final String? imageUrl;

  FeedTopic copyWith({
    String? id,
    String? name,
    Object? imageUrl = unchanged,
  }) {
    return FeedTopic(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: identical(imageUrl, unchanged)
          ? this.imageUrl
          : imageUrl as String?,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    imageUrl,
  ];
}
