import 'package:freezed_annotation/freezed_annotation.dart';

part 'my_profile_response.freezed.dart';
part 'my_profile_response.g.dart';

/// `GET /v1/onboarding/status`, read for the member's own profile — only
/// the fields the Menu / Settings / Edit profile screens show. Unknown keys
/// are ignored, every field is optional.
///
/// `TODO(api)`: switch to the dedicated profile API once it exists — only
/// this DTO and `MenuRemoteDataSource` should need to change.
@freezed
abstract class MyProfileResponseDto with _$MyProfileResponseDto {
  const factory MyProfileResponseDto({required MyProfileDataDto data}) =
      _MyProfileResponseDto;

  factory MyProfileResponseDto.fromJson(Map<String, dynamic> json) =>
      _$MyProfileResponseDtoFromJson(json);
}

@freezed
abstract class MyProfileDataDto with _$MyProfileDataDto {
  const factory MyProfileDataDto({
    MyProfileUserDto? user,
    MyProfileDto? profile,
  }) = _MyProfileDataDto;

  factory MyProfileDataDto.fromJson(Map<String, dynamic> json) =>
      _$MyProfileDataDtoFromJson(json);
}

@freezed
abstract class MyProfileUserDto with _$MyProfileUserDto {
  const factory MyProfileUserDto({
    String? fullName,
    String? email,
    String? phone,
  }) = _MyProfileUserDto;

  factory MyProfileUserDto.fromJson(Map<String, dynamic> json) =>
      _$MyProfileUserDtoFromJson(json);
}

@freezed
abstract class MyProfileDto with _$MyProfileDto {
  const factory MyProfileDto({
    String? gender,
    String? dateOfBirth,
    String? country,
    @Default(<String>[]) List<String> grewUpIn,
    num? heightCm,
    num? completeness,
    String? maritalStatus,
    String? aboutMe,
    String? getToknowDuration,
    String? marriageTimeline,
    String? educationLevel,
    String? professionTitle,
    @Default(<String>[]) List<String> faith,
    @Default(<String>[]) List<String> religiousPractices,
    @Default(<String>[]) List<String> personalityTraits,
    @Default(<String>[]) List<String> ethnicity,
    @Default(<String>[]) List<String> nationality,
    @Default(<String>[]) List<String> languages,
    @Default(<String>[]) List<String> images,
    MyProfileFaceVerificationDto? faceVerification,
    MyProfileAboutYouDto? aboutYou,
    MyProfileLifestyleDto? lifestyle,
    MyProfileInterestsDto? interests,
  }) = _MyProfileDto;

  factory MyProfileDto.fromJson(Map<String, dynamic> json) =>
      _$MyProfileDtoFromJson(json);
}

@freezed
abstract class MyProfileFaceVerificationDto
    with _$MyProfileFaceVerificationDto {
  const factory MyProfileFaceVerificationDto({
    @Default(false) bool isFaceVerified,
  }) = _MyProfileFaceVerificationDto;

  factory MyProfileFaceVerificationDto.fromJson(Map<String, dynamic> json) =>
      _$MyProfileFaceVerificationDtoFromJson(json);
}

@freezed
abstract class MyProfileAboutYouDto with _$MyProfileAboutYouDto {
  const factory MyProfileAboutYouDto({
    bool? bornMuslim,
    bool? haveChildren,
    bool? relocateAbroad,
  }) = _MyProfileAboutYouDto;

  factory MyProfileAboutYouDto.fromJson(Map<String, dynamic> json) =>
      _$MyProfileAboutYouDtoFromJson(json);
}

@freezed
abstract class MyProfileLifestyleDto with _$MyProfileLifestyleDto {
  const factory MyProfileLifestyleDto({
    bool? halalFood,
    bool? smoking,
    bool? alcohol,
  }) = _MyProfileLifestyleDto;

  factory MyProfileLifestyleDto.fromJson(Map<String, dynamic> json) =>
      _$MyProfileLifestyleDtoFromJson(json);
}

@freezed
abstract class MyProfileInterestsDto with _$MyProfileInterestsDto {
  const factory MyProfileInterestsDto({
    @Default(<String>[]) List<String> cultural,
    @Default(<String>[]) List<String> foodDrinks,
    @Default(<String>[]) List<String> sports,
    @Default(<String>[]) List<String> fashion,
    @Default(<String>[]) List<String> activities,
  }) = _MyProfileInterestsDto;

  factory MyProfileInterestsDto.fromJson(Map<String, dynamic> json) =>
      _$MyProfileInterestsDtoFromJson(json);
}
