import 'package:json_annotation/json_annotation.dart';

part 'my_profile_response.g.dart';

/// `GET /v1/profiles/me` — only the fields the Menu / Settings / Edit
/// profile screens show. Unknown keys are ignored, every field is optional.
@JsonSerializable()
class MyProfileResponseDto {
  const MyProfileResponseDto({
    required this.data,
  });

  factory MyProfileResponseDto.fromJson(Map<String, dynamic> json) =>
      _$MyProfileResponseDtoFromJson(json);

  final MyProfileDataDto data;

  Map<String, dynamic> toJson() => _$MyProfileResponseDtoToJson(this);
}

@JsonSerializable()
class MyProfileDataDto {
  const MyProfileDataDto({
    this.user,
    this.profile,
    this.dateOfBirth,
    this.heightCm,
    this.ethnicity = const <String>[],
    this.nationality = const <String>[],
    this.grewUpIn = const <String>[],
    this.ethnicityAlt = const <String>[],
    this.nationalityAlt = const <String>[],
    this.grewUpInAlt = const <String>[],
  });

  factory MyProfileDataDto.fromJson(Map<String, dynamic> json) =>
      _$MyProfileDataDtoFromJson(json);

  final MyProfileUserDto? user;
  final MyProfileDto? profile;

  // The API repeats some profile fields at this level (and again under
  // differently-cased keys); `profile` wins, these are the fallback.
  final String? dateOfBirth;
  final num? heightCm;
  final List<String> ethnicity;
  final List<String> nationality;
  final List<String> grewUpIn;

  @JsonKey(name: 'Ethnicity')
  final List<String> ethnicityAlt;
  @JsonKey(name: 'Nationality')
  final List<String> nationalityAlt;
  @JsonKey(name: 'Grew up in')
  final List<String> grewUpInAlt;

  Map<String, dynamic> toJson() => _$MyProfileDataDtoToJson(this);
}

@JsonSerializable()
class MyProfileUserDto {
  const MyProfileUserDto({
    this.fullName,
    this.email,
    this.phone,
  });

  factory MyProfileUserDto.fromJson(Map<String, dynamic> json) =>
      _$MyProfileUserDtoFromJson(json);

  final String? fullName;
  final String? email;
  final String? phone;

  Map<String, dynamic> toJson() => _$MyProfileUserDtoToJson(this);
}

@JsonSerializable()
class MyProfileDto {
  const MyProfileDto({
    this.gender,
    this.religion,
    this.dateOfBirth,
    this.country,
    this.grewUpIn = const <String>[],
    this.heightCm,
    this.completeness,
    this.maritalStatus,
    this.aboutMe,
    this.marriageIntentions,
    this.educationLevel,
    this.professionTitle,
    this.faith = const <String>[],
    this.religiousPractices = const <String>[],
    this.personalityTraits = const <String>[],
    this.ethnicity = const <String>[],
    this.nationality = const <String>[],
    this.languages = const <String>[],
    this.images = const <String>[],
    this.faceVerification,
    this.aboutYou,
    this.lifestyle,
    this.interests,
    this.ethnicityAlt = const <String>[],
    this.nationalityAlt = const <String>[],
    this.grewUpInAlt = const <String>[],
  });

  factory MyProfileDto.fromJson(Map<String, dynamic> json) =>
      _$MyProfileDtoFromJson(json);

  final String? gender;

  /// Backend token, e.g. `islam`.
  final String? religion;
  final String? dateOfBirth;
  final String? country;
  final List<String> grewUpIn;
  final num? heightCm;
  final num? completeness;
  final String? maritalStatus;
  final String? aboutMe;
  final MyProfileMarriageIntentionsDto? marriageIntentions;
  final String? educationLevel;
  final String? professionTitle;
  final List<String> faith;
  final List<String> religiousPractices;
  final List<String> personalityTraits;
  final List<String> ethnicity;
  final List<String> nationality;
  final List<String> languages;
  final List<String> images;
  final MyProfileFaceVerificationDto? faceVerification;
  final MyProfileAboutYouDto? aboutYou;
  final MyProfileLifestyleDto? lifestyle;
  final MyProfileInterestsDto? interests;

  // Same fields under the capitalised keys the API also sends.
  @JsonKey(name: 'Ethnicity')
  final List<String> ethnicityAlt;
  @JsonKey(name: 'Nationality')
  final List<String> nationalityAlt;
  @JsonKey(name: 'Grew up in')
  final List<String> grewUpInAlt;

  Map<String, dynamic> toJson() => _$MyProfileDtoToJson(this);
}

@JsonSerializable()
class MyProfileMarriageIntentionsDto {
  const MyProfileMarriageIntentionsDto({
    this.getToknowDuration,
    this.marriageTimeline,
  });

  factory MyProfileMarriageIntentionsDto.fromJson(Map<String, dynamic> json) =>
      _$MyProfileMarriageIntentionsDtoFromJson(json);

  final String? getToknowDuration;
  final String? marriageTimeline;

  Map<String, dynamic> toJson() => _$MyProfileMarriageIntentionsDtoToJson(this);
}

@JsonSerializable()
class MyProfileFaceVerificationDto {
  const MyProfileFaceVerificationDto({
    this.isFaceVerified = false,
  });

  factory MyProfileFaceVerificationDto.fromJson(Map<String, dynamic> json) =>
      _$MyProfileFaceVerificationDtoFromJson(json);

  final bool isFaceVerified;

  Map<String, dynamic> toJson() => _$MyProfileFaceVerificationDtoToJson(this);
}

@JsonSerializable()
class MyProfileAboutYouDto {
  const MyProfileAboutYouDto({
    this.bornMuslim,
    this.haveChildren,
    this.relocateAbroad,
  });

  factory MyProfileAboutYouDto.fromJson(Map<String, dynamic> json) =>
      _$MyProfileAboutYouDtoFromJson(json);

  final bool? bornMuslim;
  final bool? haveChildren;
  final bool? relocateAbroad;

  Map<String, dynamic> toJson() => _$MyProfileAboutYouDtoToJson(this);
}

@JsonSerializable()
class MyProfileLifestyleDto {
  const MyProfileLifestyleDto({
    this.halalFood,
    this.smoking,
    this.alcohol,
  });

  factory MyProfileLifestyleDto.fromJson(Map<String, dynamic> json) =>
      _$MyProfileLifestyleDtoFromJson(json);

  final bool? halalFood;
  final bool? smoking;
  final bool? alcohol;

  Map<String, dynamic> toJson() => _$MyProfileLifestyleDtoToJson(this);
}

@JsonSerializable()
class MyProfileInterestsDto {
  const MyProfileInterestsDto({
    this.cultural = const <String>[],
    this.foodDrinks = const <String>[],
    this.sports = const <String>[],
    this.fashion = const <String>[],
    this.activities = const <String>[],
  });

  factory MyProfileInterestsDto.fromJson(Map<String, dynamic> json) =>
      _$MyProfileInterestsDtoFromJson(json);

  final List<String> cultural;
  final List<String> foodDrinks;
  final List<String> sports;
  final List<String> fashion;
  final List<String> activities;

  Map<String, dynamic> toJson() => _$MyProfileInterestsDtoToJson(this);
}
