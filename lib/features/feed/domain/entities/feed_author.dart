import 'package:equatable/equatable.dart';
import 'package:find_a_nikah/core/core.dart';

/// Who wrote a post or comment — enough to draw the author row and to open
/// their profile.
class FeedAuthor extends Equatable {
  const FeedAuthor({
    required this.name,
    required this.handle,
    required this.photoUrl,
    this.countryCode,
  });

  final String name;

  /// Without the leading "@". Doubles as the author's id.
  final String handle;

  final String photoUrl;

  /// ISO 3166-1 alpha-2, lower-case ("bd") — picks the flag badge on the
  /// photo. Null or unknown codes show no badge.
  final String? countryCode;

  FeedAuthor copyWith({
    String? name,
    String? handle,
    String? photoUrl,
    Object? countryCode = unchanged,
  }) {
    return FeedAuthor(
      name: name ?? this.name,
      handle: handle ?? this.handle,
      photoUrl: photoUrl ?? this.photoUrl,
      countryCode: identical(countryCode, unchanged)
          ? this.countryCode
          : countryCode as String?,
    );
  }

  @override
  List<Object?> get props => [
    name,
    handle,
    photoUrl,
    countryCode,
  ];
}
