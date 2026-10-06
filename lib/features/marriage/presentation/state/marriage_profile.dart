import 'package:freezed_annotation/freezed_annotation.dart';

part 'marriage_profile.freezed.dart';

/// One profile shown on the Marriage tab.
///
/// UI-only for now (fed by dummy data) — add `fromJson` + `part '*.g.dart'`
/// when the discovery API arrives.
@freezed
abstract class MarriageProfile with _$MarriageProfile {
  const factory MarriageProfile({
    required String id,
    required String name,
    required int age,
    required double distanceKm,
    required String area,
    required String country,
    required String countryFlag,
    required String profession,
    required String practice,
    required String ethnicity,
    required String ethnicityFlag,

    /// First is the main (hero) photo; the next four sit between the detail
    /// sections (after About me, My faith, Future plans and Personality).
    required List<String> photoUrls,
    @Default(false) bool isVerified,
    @Default(false) bool isActiveToday,

    /// Crown badge on the photo + the "Curious about X's filters?" teaser.
    @Default(false) bool isPremium,

    /// Background details shared with the signed-in user ("Similarities").
    @Default([]) List<String> similarities,

    // About me
    required int heightCm,
    required String maritalStatus,
    required String children,

    // Marriage intentions timeline: when they want to involve family, how
    // long they'd chat, and how soon they'd marry.
    required String involveFamily,
    required String chatFor,
    required String marryWithin,

    @Default([]) List<String> faith,
    @Default([]) List<String> futurePlans,
    @Default([]) List<String> interests,
    @Default([]) List<String> personality,
    required String education,
    @Default([]) List<String> languages,
    required String grewUpIn,
    required String grewUpFlag,

    /// Free text. Blank lines separate paragraphs; lines starting with "• "
    /// render as a bulleted list.
    required String bio,

    // "Verified profile" card.
    @Default(false) bool isPhotoVerified,
    @Default(false) bool isAgeVerified,
    @Default(false) bool isIdVerified,
  }) = _MarriageProfile;
}
