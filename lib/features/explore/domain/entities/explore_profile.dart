import 'package:freezed_annotation/freezed_annotation.dart';

part 'explore_profile.freezed.dart';

/// One profile card anywhere on the Explore tab. The same shape serves
/// every section; each section's card widget picks which optional fields
/// it shows (e.g. "Active near you" shows [distanceKm], not [postedAt]).
@freezed
abstract class ExploreProfile with _$ExploreProfile {
  const factory ExploreProfile({
    required String id,
    required String name,
    required int age,
    required String photoUrl,
    required String area,

    /// Emoji flag (e.g. 🇧🇩) — rendered by the platform emoji font, same as
    /// `MarriageProfile.countryFlag`.
    required String countryFlag,
    @Default(false) bool isVerified,
    @Default(false) bool isActiveToday,

    /// "Student", "Doctor" — only the "Likes in your filters" card shows it.
    String? profession,

    /// Display-ready relative time ("1 hour ago", "Last Month") — shown
    /// instead of an active-today dot on sections that are about when
    /// something happened rather than presence.
    String? postedAt,

    /// Shown instead of [area] on "Active near you".
    double? distanceKm,
  }) = _ExploreProfile;
}
