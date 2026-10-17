import 'package:freezed_annotation/freezed_annotation.dart';

part 'onboarding_profile_response.freezed.dart';
part 'onboarding_profile_response.g.dart';

/// `GET /onboarding/status` — same endpoint auth calls for `currentStep`,
/// read again here for the fields needed to prefill the wizard when
/// resuming. Unknown/extra keys are ignored by json_serializable.
@freezed
abstract class OnboardingProfileResponseDto
    with _$OnboardingProfileResponseDto {
  const factory OnboardingProfileResponseDto({
    required OnboardingProfileDataDto data,
  }) = _OnboardingProfileResponseDto;

  factory OnboardingProfileResponseDto.fromJson(Map<String, dynamic> json) =>
      _$OnboardingProfileResponseDtoFromJson(json);
}

@freezed
abstract class OnboardingProfileDataDto with _$OnboardingProfileDataDto {
  const factory OnboardingProfileDataDto({
    @Default(4) int currentStep,
    OnboardingProfileUserDto? user,
    OnboardingProfileDto? profile,
  }) = _OnboardingProfileDataDto;

  factory OnboardingProfileDataDto.fromJson(Map<String, dynamic> json) =>
      _$OnboardingProfileDataDtoFromJson(json);
}

@freezed
abstract class OnboardingProfileUserDto with _$OnboardingProfileUserDto {
  const factory OnboardingProfileUserDto({String? fullName}) =
      _OnboardingProfileUserDto;

  factory OnboardingProfileUserDto.fromJson(Map<String, dynamic> json) =>
      _$OnboardingProfileUserDtoFromJson(json);
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
@freezed
abstract class OnboardingProfileDto with _$OnboardingProfileDto {
  const factory OnboardingProfileDto({
    String? accountType,
    String? gender,
    String? religion,
    String? dateOfBirth,
    @Default(<String>[]) List<String> languages,
    @Default(<String>[]) List<String> nationality,
    @Default(<String>[]) List<String> grewUpIn,
    @Default(<String>[]) List<String> ethnicity,
    int? heightCm,
    String? educationLevel,
    String? professionTitle,
    String? maritalStatus,
    String? getToknowDuration,
    String? marriageTimeline,
    @Default(<String>[]) List<String> faith,
    @Default(<String>[]) List<String> religiousPractices,
    @Default(<String>[]) List<String> personalityTraits,
    String? aboutMe,

    /// Step 8 photos as server-relative paths (`/public/upload/x.jpg`).
    @Default(<String>[]) List<String> images,
    OnboardingProfileAboutYouDto? aboutYou,
    OnboardingProfileLifestyleDto? lifestyle,
    OnboardingProfileInterestsDto? interests,
  }) = _OnboardingProfileDto;

  factory OnboardingProfileDto.fromJson(Map<String, dynamic> json) =>
      _$OnboardingProfileDtoFromJson(json);
}

@freezed
abstract class OnboardingProfileAboutYouDto
    with _$OnboardingProfileAboutYouDto {
  const factory OnboardingProfileAboutYouDto({
    bool? bornMuslim,
    bool? haveChildren,
    bool? relocateAbroad,
  }) = _OnboardingProfileAboutYouDto;

  factory OnboardingProfileAboutYouDto.fromJson(Map<String, dynamic> json) =>
      _$OnboardingProfileAboutYouDtoFromJson(json);
}

@freezed
abstract class OnboardingProfileLifestyleDto
    with _$OnboardingProfileLifestyleDto {
  const factory OnboardingProfileLifestyleDto({
    bool? alcohol,
    bool? halalFood,
    bool? smoking,
  }) = _OnboardingProfileLifestyleDto;

  factory OnboardingProfileLifestyleDto.fromJson(Map<String, dynamic> json) =>
      _$OnboardingProfileLifestyleDtoFromJson(json);
}

@freezed
abstract class OnboardingProfileInterestsDto
    with _$OnboardingProfileInterestsDto {
  const factory OnboardingProfileInterestsDto({
    @Default(<String>[]) List<String> cultural,
    @Default(<String>[]) List<String> foodDrinks,
    @Default(<String>[]) List<String> sports,
    @Default(<String>[]) List<String> fashion,
    @Default(<String>[]) List<String> activities,
  }) = _OnboardingProfileInterestsDto;

  factory OnboardingProfileInterestsDto.fromJson(Map<String, dynamic> json) =>
      _$OnboardingProfileInterestsDtoFromJson(json);
}
