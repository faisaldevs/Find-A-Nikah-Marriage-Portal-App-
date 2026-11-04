import 'package:json_annotation/json_annotation.dart';

part 'onboarding_profile_response.g.dart';

/// `GET /onboarding/status` — same endpoint auth calls for `currentStep`,
/// read again here for the fields needed to prefill the wizard when
/// resuming. Unknown/extra keys are ignored by json_serializable.
@JsonSerializable()
class OnboardingProfileResponseDto {
  const OnboardingProfileResponseDto({
    required this.data,
  });

  factory OnboardingProfileResponseDto.fromJson(Map<String, dynamic> json) =>
      _$OnboardingProfileResponseDtoFromJson(json);

  final OnboardingProfileDataDto data;

  Map<String, dynamic> toJson() => _$OnboardingProfileResponseDtoToJson(this);
}

@JsonSerializable()
class OnboardingProfileDataDto {
  const OnboardingProfileDataDto({
    this.currentStep = 4,
    this.user,
    this.profile,
  });

  factory OnboardingProfileDataDto.fromJson(Map<String, dynamic> json) =>
      _$OnboardingProfileDataDtoFromJson(json);

  final int currentStep;
  final OnboardingProfileUserDto? user;
  final OnboardingProfileDto? profile;

  Map<String, dynamic> toJson() => _$OnboardingProfileDataDtoToJson(this);
}

@JsonSerializable()
class OnboardingProfileUserDto {
  const OnboardingProfileUserDto({
    this.fullName,
  });

  factory OnboardingProfileUserDto.fromJson(Map<String, dynamic> json) =>
      _$OnboardingProfileUserDtoFromJson(json);

  final String? fullName;

  Map<String, dynamic> toJson() => _$OnboardingProfileUserDtoToJson(this);
}

/// Field names for `educationLevel`/`professionTitle`/`maritalStatus`/
/// `getToknowDuration`/`marriageTimeline`/`faith`/`religiousPractices`
/// mirror the submit request's own field names (`onboarding_step_request
/// .dart`) — confirmed in a real response for `maritalStatus`/`faith`/
/// `religiousPractices` (present as backend defaults even before step 5 is
/// submitted); `educationLevel`/`professionTitle`/`getToknowDuration`/
/// `marriageTimeline` are the same-name assumption, unconfirmed — fix if a
/// real post-step-5 payload shows different keys. `aboutYou`/`lifestyle`/
/// `interests` nesting is confirmed from a real payload.
@JsonSerializable()
class OnboardingProfileDto {
  const OnboardingProfileDto({
    this.accountType,
    this.gender,
    this.religion,
    this.dateOfBirth,
    this.languages = const <String>[],
    this.nationality = const <String>[],
    this.grewUpIn = const <String>[],
    this.ethnicity = const <String>[],
    this.heightCm,
    this.educationLevel,
    this.professionTitle,
    this.maritalStatus,
    this.getToknowDuration,
    this.marriageTimeline,
    this.faith = const <String>[],
    this.religiousPractices = const <String>[],
    this.personalityTraits = const <String>[],
    this.aboutMe,
    this.images = const <String>[],
    this.aboutYou,
    this.lifestyle,
    this.interests,
  });

  factory OnboardingProfileDto.fromJson(Map<String, dynamic> json) =>
      _$OnboardingProfileDtoFromJson(json);

  final String? accountType;
  final String? gender;
  final String? religion;
  final String? dateOfBirth;
  final List<String> languages;
  final List<String> nationality;
  final List<String> grewUpIn;
  final List<String> ethnicity;
  final int? heightCm;
  final String? educationLevel;
  final String? professionTitle;
  final String? maritalStatus;
  final String? getToknowDuration;
  final String? marriageTimeline;
  final List<String> faith;
  final List<String> religiousPractices;
  final List<String> personalityTraits;
  final String? aboutMe;

  /// Step 8 photos as server-relative paths (`/public/upload/x.jpg`).
  final List<String> images;

  final OnboardingProfileAboutYouDto? aboutYou;
  final OnboardingProfileLifestyleDto? lifestyle;
  final OnboardingProfileInterestsDto? interests;

  Map<String, dynamic> toJson() => _$OnboardingProfileDtoToJson(this);
}

@JsonSerializable()
class OnboardingProfileAboutYouDto {
  const OnboardingProfileAboutYouDto({
    this.bornMuslim,
    this.haveChildren,
    this.relocateAbroad,
  });

  factory OnboardingProfileAboutYouDto.fromJson(Map<String, dynamic> json) =>
      _$OnboardingProfileAboutYouDtoFromJson(json);

  final bool? bornMuslim;
  final bool? haveChildren;
  final bool? relocateAbroad;

  Map<String, dynamic> toJson() => _$OnboardingProfileAboutYouDtoToJson(this);
}

@JsonSerializable()
class OnboardingProfileLifestyleDto {
  const OnboardingProfileLifestyleDto({
    this.alcohol,
    this.halalFood,
    this.smoking,
  });

  factory OnboardingProfileLifestyleDto.fromJson(Map<String, dynamic> json) =>
      _$OnboardingProfileLifestyleDtoFromJson(json);

  final bool? alcohol;
  final bool? halalFood;
  final bool? smoking;

  Map<String, dynamic> toJson() => _$OnboardingProfileLifestyleDtoToJson(this);
}

@JsonSerializable()
class OnboardingProfileInterestsDto {
  const OnboardingProfileInterestsDto({
    this.cultural = const <String>[],
    this.foodDrinks = const <String>[],
    this.sports = const <String>[],
    this.fashion = const <String>[],
    this.activities = const <String>[],
  });

  factory OnboardingProfileInterestsDto.fromJson(Map<String, dynamic> json) =>
      _$OnboardingProfileInterestsDtoFromJson(json);

  final List<String> cultural;
  final List<String> foodDrinks;
  final List<String> sports;
  final List<String> fashion;
  final List<String> activities;

  Map<String, dynamic> toJson() => _$OnboardingProfileInterestsDtoToJson(this);
}
