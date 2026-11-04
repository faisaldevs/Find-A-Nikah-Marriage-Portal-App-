import 'package:equatable/equatable.dart';
import 'package:find_a_nikah/core/core.dart';

/// One profile card anywhere on the Explore tab. The same shape serves
/// every section; each section's card widget picks which optional fields
/// it shows (e.g. "Active near you" shows [distanceKm], not [postedAt]).
class ExploreProfile extends Equatable {
  const ExploreProfile({
    required this.id,
    required this.name,
    required this.age,
    required this.photoUrl,
    required this.area,
    required this.countryFlag,
    this.isVerified = false,
    this.isActiveToday = false,
    this.profession,
    this.postedAt,
    this.distanceKm,
    this.interactedAt,
  });

  final String id;
  final String name;
  final int age;
  final String photoUrl;
  final String area;

  /// Emoji flag (e.g. 🇧🇩) — rendered by the platform emoji font, same as
  /// `MarriageProfile.countryFlag`.
  final String countryFlag;

  final bool isVerified;
  final bool isActiveToday;

  /// "Student", "Doctor" — only the "Likes in your filters" card shows it.
  final String? profession;

  /// Display-ready relative time ("1 hour ago", "Last Month") — shown
  /// instead of an active-today dot on sections that are about when
  /// something happened rather than presence.
  final String? postedAt;

  /// Shown instead of [area] on "Active near you".
  final double? distanceKm;

  /// Display-ready relative time of the liked/favourited/passed/
  /// complimented action ("10 seconds ago", "Yesterday") — "My history"
  /// tab only, shown alongside [isActiveToday] rather than replacing it
  /// like [postedAt] does.
  final String? interactedAt;

  ExploreProfile copyWith({
    String? id,
    String? name,
    int? age,
    String? photoUrl,
    String? area,
    String? countryFlag,
    bool? isVerified,
    bool? isActiveToday,
    Object? profession = unchanged,
    Object? postedAt = unchanged,
    Object? distanceKm = unchanged,
    Object? interactedAt = unchanged,
  }) {
    return ExploreProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      photoUrl: photoUrl ?? this.photoUrl,
      area: area ?? this.area,
      countryFlag: countryFlag ?? this.countryFlag,
      isVerified: isVerified ?? this.isVerified,
      isActiveToday: isActiveToday ?? this.isActiveToday,
      profession: identical(profession, unchanged)
          ? this.profession
          : profession as String?,
      postedAt: identical(postedAt, unchanged)
          ? this.postedAt
          : postedAt as String?,
      distanceKm: identical(distanceKm, unchanged)
          ? this.distanceKm
          : (distanceKm as num?)?.toDouble(),
      interactedAt: identical(interactedAt, unchanged)
          ? this.interactedAt
          : interactedAt as String?,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    age,
    photoUrl,
    area,
    countryFlag,
    isVerified,
    isActiveToday,
    profession,
    postedAt,
    distanceKm,
    interactedAt,
  ];
}
