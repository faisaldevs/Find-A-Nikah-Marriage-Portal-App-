import 'package:freezed_annotation/freezed_annotation.dart';

part 'marriage_profile.freezed.dart';

/// One profile shown on the Marriage tab. The wire format is
/// `MarriageProfileDto` (data layer); this entity never sees JSON.
@freezed
abstract class MarriageProfile with _$MarriageProfile {
  const factory MarriageProfile({
    required String id,
    required String name,
    required int age,

    /// Null when the API has no location for them (hidden in the hero).
    required double? distanceKm,

    /// Neighbourhood/city; '' when unknown. String fields below are '' when
    /// not filled in, and the UI hides empty chips/sections.
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

    // About me
    required int? heightCm,
    required String maritalStatus,
    required String children,

    // Marriage intentions timeline: when they want to involve family, how
    // long they'd chat, and how soon they'd marry.
    required String involveFamily,
    required String chatFor,
    required String marryWithin,
    required String education,
    required String grewUpIn,
    required String grewUpFlag,

    /// Free text. Blank lines separate paragraphs; lines starting with "• "
    /// render as a bulleted list.
    required String bio,
    @Default(false) bool isVerified,
    @Default(false) bool isActiveToday,

    /// Crown badge on the photo + the "Curious about X's filters?" teaser.
    @Default(false) bool isPremium,

    /// Background details shared with the signed-in user ("Similarities").
    @Default([]) List<String> similarities,

    @Default([]) List<String> faith,
    @Default([]) List<String> futurePlans,
    @Default([]) List<String> interests,
    @Default([]) List<String> personality,
    @Default([]) List<String> languages,

    // "Verified profile" card.
    @Default(false) bool isPhotoVerified,
    @Default(false) bool isAgeVerified,
    @Default(false) bool isIdVerified,
  }) = _MarriageProfile;
}
