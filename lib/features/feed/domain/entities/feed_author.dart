import 'package:freezed_annotation/freezed_annotation.dart';

part 'feed_author.freezed.dart';

/// Who wrote a post or comment — enough to draw the author row and to open
/// their profile.
@freezed
abstract class FeedAuthor with _$FeedAuthor {
  const factory FeedAuthor({
    required String name,

    /// Without the leading "@". Doubles as the author's id.
    required String handle,
    required String photoUrl,

    /// ISO 3166-1 alpha-2, lower-case ("bd") — picks the flag badge on the
    /// photo. Null or unknown codes show no badge.
    String? countryCode,
  }) = _FeedAuthor;
}
