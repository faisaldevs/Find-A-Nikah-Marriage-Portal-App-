// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_profile_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MyProfileResponseDto _$MyProfileResponseDtoFromJson(
  Map<String, dynamic> json,
) => MyProfileResponseDto(
  data: MyProfileDataDto.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$MyProfileResponseDtoToJson(
  MyProfileResponseDto instance,
) => <String, dynamic>{'data': instance.data};

MyProfileDataDto _$MyProfileDataDtoFromJson(
  Map<String, dynamic> json,
) => MyProfileDataDto(
  user: json['user'] == null
      ? null
      : MyProfileUserDto.fromJson(json['user'] as Map<String, dynamic>),
  profile: json['profile'] == null
      ? null
      : MyProfileDto.fromJson(json['profile'] as Map<String, dynamic>),
  dateOfBirth: json['dateOfBirth'] as String?,
  heightCm: json['heightCm'] as num?,
  ethnicity:
      (json['ethnicity'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  nationality:
      (json['nationality'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const <String>[],
  grewUpIn:
      (json['grewUpIn'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  ethnicityAlt:
      (json['Ethnicity'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  nationalityAlt:
      (json['Nationality'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const <String>[],
  grewUpInAlt:
      (json['Grew up in'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const <String>[],
);

Map<String, dynamic> _$MyProfileDataDtoToJson(MyProfileDataDto instance) =>
    <String, dynamic>{
      'user': instance.user,
      'profile': instance.profile,
      'dateOfBirth': instance.dateOfBirth,
      'heightCm': instance.heightCm,
      'ethnicity': instance.ethnicity,
      'nationality': instance.nationality,
      'grewUpIn': instance.grewUpIn,
      'Ethnicity': instance.ethnicityAlt,
      'Nationality': instance.nationalityAlt,
      'Grew up in': instance.grewUpInAlt,
    };

MyProfileUserDto _$MyProfileUserDtoFromJson(Map<String, dynamic> json) =>
    MyProfileUserDto(
      fullName: json['fullName'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
    );

Map<String, dynamic> _$MyProfileUserDtoToJson(MyProfileUserDto instance) =>
    <String, dynamic>{
      'fullName': instance.fullName,
      'email': instance.email,
      'phone': instance.phone,
    };

MyProfileDto _$MyProfileDtoFromJson(Map<String, dynamic> json) => MyProfileDto(
  gender: json['gender'] as String?,
  religion: json['religion'] as String?,
  dateOfBirth: json['dateOfBirth'] as String?,
  country: json['country'] as String?,
  grewUpIn:
      (json['grewUpIn'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  heightCm: json['heightCm'] as num?,
  completeness: json['completeness'] as num?,
  maritalStatus: json['maritalStatus'] as String?,
  aboutMe: json['aboutMe'] as String?,
  marriageIntentions: json['marriageIntentions'] == null
      ? null
      : MyProfileMarriageIntentionsDto.fromJson(
          json['marriageIntentions'] as Map<String, dynamic>,
        ),
  educationLevel: json['educationLevel'] as String?,
  professionTitle: json['professionTitle'] as String?,
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
  ethnicity:
      (json['ethnicity'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  nationality:
      (json['nationality'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const <String>[],
  languages:
      (json['languages'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  images:
      (json['images'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  faceVerification: json['faceVerification'] == null
      ? null
      : MyProfileFaceVerificationDto.fromJson(
          json['faceVerification'] as Map<String, dynamic>,
        ),
  aboutYou: json['aboutYou'] == null
      ? null
      : MyProfileAboutYouDto.fromJson(json['aboutYou'] as Map<String, dynamic>),
  lifestyle: json['lifestyle'] == null
      ? null
      : MyProfileLifestyleDto.fromJson(
          json['lifestyle'] as Map<String, dynamic>,
        ),
  interests: json['interests'] == null
      ? null
      : MyProfileInterestsDto.fromJson(
          json['interests'] as Map<String, dynamic>,
        ),
  ethnicityAlt:
      (json['Ethnicity'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  nationalityAlt:
      (json['Nationality'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const <String>[],
  grewUpInAlt:
      (json['Grew up in'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const <String>[],
);

Map<String, dynamic> _$MyProfileDtoToJson(MyProfileDto instance) =>
    <String, dynamic>{
      'gender': instance.gender,
      'religion': instance.religion,
      'dateOfBirth': instance.dateOfBirth,
      'country': instance.country,
      'grewUpIn': instance.grewUpIn,
      'heightCm': instance.heightCm,
      'completeness': instance.completeness,
      'maritalStatus': instance.maritalStatus,
      'aboutMe': instance.aboutMe,
      'marriageIntentions': instance.marriageIntentions,
      'educationLevel': instance.educationLevel,
      'professionTitle': instance.professionTitle,
      'faith': instance.faith,
      'religiousPractices': instance.religiousPractices,
      'personalityTraits': instance.personalityTraits,
      'ethnicity': instance.ethnicity,
      'nationality': instance.nationality,
      'languages': instance.languages,
      'images': instance.images,
      'faceVerification': instance.faceVerification,
      'aboutYou': instance.aboutYou,
      'lifestyle': instance.lifestyle,
      'interests': instance.interests,
      'Ethnicity': instance.ethnicityAlt,
      'Nationality': instance.nationalityAlt,
      'Grew up in': instance.grewUpInAlt,
    };

MyProfileMarriageIntentionsDto _$MyProfileMarriageIntentionsDtoFromJson(
  Map<String, dynamic> json,
) => MyProfileMarriageIntentionsDto(
  getToknowDuration: json['getToknowDuration'] as String?,
  marriageTimeline: json['marriageTimeline'] as String?,
);

Map<String, dynamic> _$MyProfileMarriageIntentionsDtoToJson(
  MyProfileMarriageIntentionsDto instance,
) => <String, dynamic>{
  'getToknowDuration': instance.getToknowDuration,
  'marriageTimeline': instance.marriageTimeline,
};

MyProfileFaceVerificationDto _$MyProfileFaceVerificationDtoFromJson(
  Map<String, dynamic> json,
) => MyProfileFaceVerificationDto(
  isFaceVerified: json['isFaceVerified'] as bool? ?? false,
);

Map<String, dynamic> _$MyProfileFaceVerificationDtoToJson(
  MyProfileFaceVerificationDto instance,
) => <String, dynamic>{'isFaceVerified': instance.isFaceVerified};

MyProfileAboutYouDto _$MyProfileAboutYouDtoFromJson(
  Map<String, dynamic> json,
) => MyProfileAboutYouDto(
  bornMuslim: json['bornMuslim'] as bool?,
  haveChildren: json['haveChildren'] as bool?,
  relocateAbroad: json['relocateAbroad'] as bool?,
);

Map<String, dynamic> _$MyProfileAboutYouDtoToJson(
  MyProfileAboutYouDto instance,
) => <String, dynamic>{
  'bornMuslim': instance.bornMuslim,
  'haveChildren': instance.haveChildren,
  'relocateAbroad': instance.relocateAbroad,
};

MyProfileLifestyleDto _$MyProfileLifestyleDtoFromJson(
  Map<String, dynamic> json,
) => MyProfileLifestyleDto(
  halalFood: json['halalFood'] as bool?,
  smoking: json['smoking'] as bool?,
  alcohol: json['alcohol'] as bool?,
);

Map<String, dynamic> _$MyProfileLifestyleDtoToJson(
  MyProfileLifestyleDto instance,
) => <String, dynamic>{
  'halalFood': instance.halalFood,
  'smoking': instance.smoking,
  'alcohol': instance.alcohol,
};

MyProfileInterestsDto _$MyProfileInterestsDtoFromJson(
  Map<String, dynamic> json,
) => MyProfileInterestsDto(
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

Map<String, dynamic> _$MyProfileInterestsDtoToJson(
  MyProfileInterestsDto instance,
) => <String, dynamic>{
  'cultural': instance.cultural,
  'foodDrinks': instance.foodDrinks,
  'sports': instance.sports,
  'fashion': instance.fashion,
  'activities': instance.activities,
};
