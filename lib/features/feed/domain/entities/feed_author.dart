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
    this.countryCode,
    this.isVerified = false,
    this.isMe = false,
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

  /// ISO 3166-1 alpha-2, lower-case ("bd") — picks the flag badge on the
  /// photo. Null or unknown codes show no badge.
  final String? countryCode;

  final bool isVerified;

  /// The signed-in member — never offer Follow / Message / Report on them.
  final bool isMe;

  FeedAuthor copyWith({
    String? userId,
    String? name,
    String? handle,
    String? photoUrl,
    Object? countryCode = unchanged,
    bool? isVerified,
    bool? isMe,
  }) {
    return FeedAuthor(
      userId: userId ?? this.userId,
      name: name ?? this.name,
      handle: handle ?? this.handle,
      photoUrl: photoUrl ?? this.photoUrl,
      countryCode: identical(countryCode, unchanged)
          ? this.countryCode
          : countryCode as String?,
      isVerified: isVerified ?? this.isVerified,
      isMe: isMe ?? this.isMe,
    );
  }

  @override
  List<Object?> get props => [
    userId,
    name,
    handle,
    photoUrl,
    countryCode,
    isVerified,
    isMe,
  ];
}
