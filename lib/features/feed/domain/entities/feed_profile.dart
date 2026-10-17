import 'package:find_a_nikah/features/feed/domain/entities/feed_author.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'feed_profile.freezed.dart';

/// A member's community profile.
@freezed
abstract class FeedProfile with _$FeedProfile {
  const factory FeedProfile({
    required FeedAuthor author,
    required String countryName,

    /// Display-ready ("Oct 2026").
    required String joined,
    @Default(0) int followers,
    @Default(0) int following,
  }) = _FeedProfile;
}
