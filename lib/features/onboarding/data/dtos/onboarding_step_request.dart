import 'package:json_annotation/json_annotation.dart';

part 'onboarding_step_request.g.dart';

/// Step 4 — Basics.
@JsonSerializable(createFactory: false)
class OnboardingBasicsRequestDto {
  const OnboardingBasicsRequestDto({
    required this.accountType,
    required this.fullName,
    required this.gender,
    required this.religion,
    required this.dateOfBirth,
    required this.intent,
    required this.referralSource,
    required this.nationality,
    required this.grewUpIn,
    required this.ethnicity,
    required this.heightCm,
    required this.languages,
    this.profileFor,
    this.step = 4,
  });

  final int step;
  final String? accountType;

  /// Family flow only (`son`/`daughter`/`brother`/`sister`/
  /// `other_family_member`).
  @JsonKey(includeIfNull: false)
  final String? profileFor;
  final String? fullName;
  final String? gender;
  final String? religion;

  /// `yyyy-MM-dd`.
  final String? dateOfBirth;
  final String? intent;

  /// Optional (the page has Skip). Sending `null` gets a 400 "Referral
  /// source must be one of …", so it's left out when skipped (audit #15).
  @JsonKey(includeIfNull: false)
  final String? referralSource;

  /// Full country names (not ISO codes) — see
  /// `OnboardingSubmissionRepositoryImpl` for the code→name mapping.
  final List<String> nationality;
  // final String? grewUpIn;
  /// The backend stores `grewUpIn` as a list (the status response returns
  /// an array); a bare string left it empty — the AI bio read "grew up in ."
  /// (audit #33).
  final List<String> grewUpIn;
  final List<String> ethnicity;
  final int? heightCm;

  /// Spoken languages from Basic information — previously never sent
  /// (audit #12). Same labels the status response's `profile.languages`
  /// returns.
  final List<String> languages;

  Map<String, dynamic> toJson() => _$OnboardingBasicsRequestDtoToJson(this);
}

/// Step 5 — Background & faith.
@JsonSerializable(createFactory: false)
class OnboardingBackgroundFaithRequestDto {
  const OnboardingBackgroundFaithRequestDto({
    required this.educationLevel,
    required this.professionTitle,
    required this.maritalStatus,
    required this.getToknowDuration,
    required this.marriageTimeline,
    required this.faith,
    required this.religiousPractices,
    this.step = 5,
  });

  final int step;
  final String? educationLevel;
  final String? professionTitle;
  final String? maritalStatus;
  final String? getToknowDuration;
  final String? marriageTimeline;
  final List<String> faith;
  final List<String> religiousPractices;

  Map<String, dynamic> toJson() =>
      _$OnboardingBackgroundFaithRequestDtoToJson(this);
}

/// Step 6 — Lifestyle & personality (everything in that section except bio).
@JsonSerializable(createFactory: false)
class OnboardingLifestylePersonalityRequestDto {
  const OnboardingLifestylePersonalityRequestDto({
    required this.halalFood,
    required this.smoking,
    required this.alcohol,
    required this.bornMuslim,
    required this.haveChildren,
    required this.relocateAbroad,
    required this.personalityTraits,
    required this.cultural,
    required this.foodDrinks,
    required this.sports,
    this.step = 6,
  });

  final int step;
  final bool? halalFood;
  final bool? smoking;
  final bool? alcohol;
  final bool? bornMuslim;
  final bool? haveChildren;
  final bool? relocateAbroad;
  final List<String> personalityTraits;
  final List<String> cultural;
  final List<String> foodDrinks;
  final List<String> sports;

  // `fashion`/`activities` aren't sent — no source category exists in the
  // interests screen yet (see PENDING.md / ask before adding them).

  Map<String, dynamic> toJson() =>
      _$OnboardingLifestylePersonalityRequestDtoToJson(this);
}

/// Step 7 — Bio.
@JsonSerializable(createFactory: false)
class OnboardingBioRequestDto {
  const OnboardingBioRequestDto({required this.aboutMe, this.step = 7});

  final int step;
  final String? aboutMe;

  Map<String, dynamic> toJson() => _$OnboardingBioRequestDtoToJson(this);
}

// Replaced: step 8 is a multipart upload of the files themselves (see
// `OnboardingRemoteDataSource.submitPhotos`), not a JSON list of URLs.
// /// Step 8 — Images. Built per spec but not called anywhere yet: the actual
// /// upload flow (`/public/upload`) is a separate, not-yet-wired concern.
// @JsonSerializable(createFactory: false)
// class OnboardingImagesRequestDto {
//   const OnboardingImagesRequestDto({required this.images, this.step = 8});
//
//   final int step;
//   final List<String> images;
//
//   Map<String, dynamic> toJson() => _$OnboardingImagesRequestDtoToJson(this);
// }
