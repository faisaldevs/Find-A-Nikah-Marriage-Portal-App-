import 'package:equatable/equatable.dart';
import 'package:find_a_nikah/core/core.dart';

/// Who wrote a post or comment — enough to draw the author row and to open
/// their profile.
class FeedAuthor extends Equatable {
  const FeedAuthor({
    required this.userId,
    required this.name,
    required this.handle,
    required this.photoUrl,
    this.photoThumbUrl = '',
    this.countryCode,
    this.isVerified = false,
    this.isMe = false,
    this.isFollowing = false,
  });

  /// The member's identity everywhere (routes, follow, report). [handle] is
  /// only a label and can change.
  final String userId;

  /// "Ayat N." — first name + last initial, from the server.
  final String name;

  /// Without the leading "@".
  final String handle;

  /// Absolute URL, or empty when the member has no photo.
  final String photoUrl;

  /// Small variant (128 px) for avatars; empty when the server gave none.
  final String photoThumbUrl;

  /// What to draw in an avatar: the thumbnail, else the full photo.
  String get avatarUrl => photoThumbUrl.isNotEmpty ? photoThumbUrl : photoUrl;

  /// ISO 3166-1 alpha-2, lower-case ("bd") — picks the flag badge on the
  /// photo. Null or unknown codes show no badge.
  final String? countryCode;

  final bool isVerified;

  /// The signed-in member — never offer Follow / Message / Report on them.
  final bool isMe;

  /// Set on people-search and followers / following rows only.
  final bool isFollowing;

  FeedAuthor copyWith({
    String? userId,
    String? name,
    String? handle,
    String? photoUrl,
    String? photoThumbUrl,
    Object? countryCode = unchanged,
    bool? isVerified,
    bool? isMe,
    bool? isFollowing,
  }) {
    return FeedAuthor(
      userId: userId ?? this.userId,
      name: name ?? this.name,
      handle: handle ?? this.handle,
      photoUrl: photoUrl ?? this.photoUrl,
      photoThumbUrl: photoThumbUrl ?? this.photoThumbUrl,
      countryCode: identical(countryCode, unchanged)
          ? this.countryCode
          : countryCode as String?,
      isVerified: isVerified ?? this.isVerified,
      isMe: isMe ?? this.isMe,
      isFollowing: isFollowing ?? this.isFollowing,
    );
  }

  @override
  List<Object?> get props => [
    userId,
    name,
    handle,
    photoUrl,
    photoThumbUrl,
    countryCode,
    isVerified,
    isMe,
    isFollowing,
  ];
}
