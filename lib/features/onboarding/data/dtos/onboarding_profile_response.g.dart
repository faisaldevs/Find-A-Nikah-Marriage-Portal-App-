// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onboarding_profile_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OnboardingProfileResponseDto _$OnboardingProfileResponseDtoFromJson(
  Map<String, dynamic> json,
) => _OnboardingProfileResponseDto(
  data: OnboardingProfileDataDto.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$OnboardingProfileResponseDtoToJson(
  _OnboardingProfileResponseDto instance,
) => <String, dynamic>{'data': instance.data};

_OnboardingProfileDataDto _$OnboardingProfileDataDtoFromJson(
  Map<String, dynamic> json,
) => _OnboardingProfileDataDto(
  currentStep: (json['currentStep'] as num?)?.toInt() ?? 4,
  user: json['user'] == null
      ? null
      : OnboardingProfileUserDto.fromJson(json['user'] as Map<String, dynamic>),
  profile: json['profile'] == null
      ? null
      : OnboardingProfileDto.fromJson(json['profile'] as Map<String, dynamic>),
);

Map<String, dynamic> _$OnboardingProfileDataDtoToJson(
  _OnboardingProfileDataDto instance,
) => <String, dynamic>{
  'currentStep': instance.currentStep,
  'user': instance.user,
  'profile': instance.profile,
};

_OnboardingProfileUserDto _$OnboardingProfileUserDtoFromJson(
  Map<String, dynamic> json,
) => _OnboardingProfileUserDto(fullName: json['fullName'] as String?);

Map<String, dynamic> _$OnboardingProfileUserDtoToJson(
  _OnboardingProfileUserDto instance,
) => <String, dynamic>{'fullName': instance.fullName};

_OnboardingProfileDto _$OnboardingProfileDtoFromJson(
  Map<String, dynamic> json,
) => _OnboardingProfileDto(
  accountType: json['accountType'] as String?,
  gender: json['gender'] as String?,
  religion: json['religion'] as String?,
  dateOfBirth: json['dateOfBirth'] as String?,
  languages:
      (json['languages'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  nationality:
      (json['nationality'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const <String>[],
  grewUpIn:
      (json['grewUpIn'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  ethnicity:
      (json['ethnicity'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  heightCm: (json['heightCm'] as num?)?.toInt(),
  educationLevel: json['educationLevel'] as String?,
  professionTitle: json['professionTitle'] as String?,
  maritalStatus: json['maritalStatus'] as String?,
  getToknowDuration: json['getToknowDuration'] as String?,
  marriageTimeline: json['marriageTimeline'] as String?,
  faith:
      (json['faith'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  religiousPractices:
      (json['religiousPractices'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const <String>[],
  personalityTraits:
      (json['personalityTraits'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const <String>[],
  aboutMe: json['aboutMe'] as String?,
  images:
      (json['images'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  aboutYou: json['aboutYou'] == null
      ? null
      : OnboardingProfileAboutYouDto.fromJson(
          json['aboutYou'] as Map<String, dynamic>,
        ),
  lifestyle: json['lifestyle'] == null
      ? null
      : OnboardingProfileLifestyleDto.fromJson(
          json['lifestyle'] as Map<String, dynamic>,
        ),
  interests: json['interests'] == null
      ? null
      : OnboardingProfileInterestsDto.fromJson(
          json['interests'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$OnboardingProfileDtoToJson(
  _OnboardingProfileDto instance,
) => <String, dynamic>{
  'accountType': instance.accountType,
  'gender': instance.gender,
  'religion': instance.religion,
  'dateOfBirth': instance.dateOfBirth,
  'languages': instance.languages,
  'nationality': instance.nationality,
  'grewUpIn': instance.grewUpIn,
  'ethnicity': instance.ethnicity,
  'heightCm': instance.heightCm,
  'educationLevel': instance.educationLevel,
  'professionTitle': instance.professionTitle,
  'maritalStatus': instance.maritalStatus,
  'getToknowDuration': instance.getToknowDuration,
  'marriageTimeline': instance.marriageTimeline,
  'faith': instance.faith,
  'religiousPractices': instance.religiousPractices,
  'personalityTraits': instance.personalityTraits,
  'aboutMe': instance.aboutMe,
  'images': instance.images,
  'aboutYou': instance.aboutYou,
  'lifestyle': instance.lifestyle,
  'interests': instance.interests,
};

_OnboardingProfileAboutYouDto _$OnboardingProfileAboutYouDtoFromJson(
  Map<String, dynamic> json,
) => _OnboardingProfileAboutYouDto(
  bornMuslim: json['bornMuslim'] as bool?,
  haveChildren: json['haveChildren'] as bool?,
  relocateAbroad: json['relocateAbroad'] as bool?,
);

Map<String, dynamic> _$OnboardingProfileAboutYouDtoToJson(
  _OnboardingProfileAboutYouDto instance,
) => <String, dynamic>{
  'bornMuslim': instance.bornMuslim,
  'haveChildren': instance.haveChildren,
  'relocateAbroad': instance.relocateAbroad,
};

_OnboardingProfileLifestyleDto _$OnboardingProfileLifestyleDtoFromJson(
  Map<String, dynamic> json,
) => _OnboardingProfileLifestyleDto(
  alcohol: json['alcohol'] as bool?,
  halalFood: json['halalFood'] as bool?,
  smoking: json['smoking'] as bool?,
);

Map<String, dynamic> _$OnboardingProfileLifestyleDtoToJson(
  _OnboardingProfileLifestyleDto instance,
) => <String, dynamic>{
  'alcohol': instance.alcohol,
  'halalFood': instance.halalFood,
  'smoking': instance.smoking,
};

_OnboardingProfileInterestsDto _$OnboardingProfileInterestsDtoFromJson(
  Map<String, dynamic> json,
) => _OnboardingProfileInterestsDto(
  cultural:
      (json['cultural'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  foodDrinks:
      (json['foodDrinks'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const <String>[],
  sports:
      (json['sports'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  fashion:
      (json['fashion'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  activities:
      (json['activities'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const <String>[],
);

Map<String, dynamic> _$OnboardingProfileInterestsDtoToJson(
  _OnboardingProfileInterestsDto instance,
) => <String, dynamic>{
  'cultural': instance.cultural,
  'foodDrinks': instance.foodDrinks,
  'sports': instance.sports,
  'fashion': instance.fashion,
  'activities': instance.activities,
};
