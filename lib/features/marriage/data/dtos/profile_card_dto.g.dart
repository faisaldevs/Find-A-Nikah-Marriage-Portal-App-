// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_card_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfileCardsResponseDto _$ProfileCardsResponseDtoFromJson(
  Map<String, dynamic> json,
) => ProfileCardsResponseDto(
  data: ProfileCardsDataDto.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ProfileCardsResponseDtoToJson(
  ProfileCardsResponseDto instance,
) => <String, dynamic>{'data': instance.data};

ProfileCardsDataDto _$ProfileCardsDataDtoFromJson(Map<String, dynamic> json) =>
    ProfileCardsDataDto(
      cards:
          (json['cards'] as List<dynamic>?)
              ?.map((e) => ProfileCardDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <ProfileCardDto>[],
      totalReturned: (json['totalReturned'] as num?)?.toInt() ?? 0,
      limit: (json['limit'] as num?)?.toInt() ?? 0,
      hasMore: json['hasMore'] as bool? ?? false,
      viewerGender: json['viewerGender'] as String?,
      targetGender: json['targetGender'] as String?,
      targetReligion: json['targetReligion'] as String?,
    );

Map<String, dynamic> _$ProfileCardsDataDtoToJson(
  ProfileCardsDataDto instance,
) => <String, dynamic>{
  'cards': instance.cards,
  'totalReturned': instance.totalReturned,
  'limit': instance.limit,
  'hasMore': instance.hasMore,
  'viewerGender': instance.viewerGender,
  'targetGender': instance.targetGender,
  'targetReligion': instance.targetReligion,
};

ProfileCardDto _$ProfileCardDtoFromJson(
  Map<String, dynamic> json,
) => ProfileCardDto(
  userId: json['userId'] as String,
  profileId: json['profileId'] as String?,
  fullName: json['fullName'] as String? ?? '',
  isVerified: json['isVerified'] as bool? ?? false,
  lastActiveAt: json['lastActiveAt'] as String?,
  age: (json['age'] as num?)?.toInt(),
  dateOfBirth: json['dateOfBirth'] as String?,
  gender: json['gender'] as String?,
  religion: json['religion'] as String?,
  faith:
      (json['faith'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  ethnicity:
      (json['ethnicity'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  country: json['country'] as String?,
  city: json['city'] as String?,
  location: json['location'],
  distanceKm: (json['distanceKm'] as num?)?.toDouble(),
  aboutMe: json['aboutMe'] as String?,
  educationLevel: json['educationLevel'] as String?,
  professionTitle: json['professionTitle'] as String?,
  maritalStatus: json['maritalStatus'] as String?,
  heightCm: (json['heightCm'] as num?)?.toInt(),
  images:
      (json['images'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  primaryPhoto: json['primaryPhoto'] as String?,
  interests: json['interests'] == null
      ? null
      : ProfileCardInterestsDto.fromJson(
          json['interests'] as Map<String, dynamic>,
        ),
  allInterests:
      (json['allInterests'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const <String>[],
  sharedInterests:
      (json['sharedInterests'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const <String>[],
  sharedCount: (json['sharedCount'] as num?)?.toInt() ?? 0,
  matchScore: (json['matchScore'] as num?)?.toInt(),
  completeness: (json['completeness'] as num?)?.toInt(),
  complement: json['complement'] as bool? ?? false,
  complementText: json['complementText'] as String?,
  action: json['action'] == null
      ? null
      : ProfileCardActionDto.fromJson(json['action'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ProfileCardDtoToJson(ProfileCardDto instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'profileId': instance.profileId,
      'fullName': instance.fullName,
      'isVerified': instance.isVerified,
      'lastActiveAt': instance.lastActiveAt,
      'age': instance.age,
      'dateOfBirth': instance.dateOfBirth,
      'gender': instance.gender,
      'religion': instance.religion,
      'faith': instance.faith,
      'ethnicity': instance.ethnicity,
      'country': instance.country,
      'city': instance.city,
      'location': instance.location,
      'distanceKm': instance.distanceKm,
      'aboutMe': instance.aboutMe,
      'educationLevel': instance.educationLevel,
      'professionTitle': instance.professionTitle,
      'maritalStatus': instance.maritalStatus,
      'heightCm': instance.heightCm,
      'images': instance.images,
      'primaryPhoto': instance.primaryPhoto,
      'interests': instance.interests,
      'allInterests': instance.allInterests,
      'sharedInterests': instance.sharedInterests,
      'sharedCount': instance.sharedCount,
      'matchScore': instance.matchScore,
      'completeness': instance.completeness,
      'complement': instance.complement,
      'complementText': instance.complementText,
      'action': instance.action,
    };

ProfileCardInterestsDto _$ProfileCardInterestsDtoFromJson(
  Map<String, dynamic> json,
) => ProfileCardInterestsDto(
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

Map<String, dynamic> _$ProfileCardInterestsDtoToJson(
  ProfileCardInterestsDto instance,
) => <String, dynamic>{
  'cultural': instance.cultural,
  'foodDrinks': instance.foodDrinks,
  'sports': instance.sports,
  'fashion': instance.fashion,
  'activities': instance.activities,
};

ProfileCardActionDto _$ProfileCardActionDtoFromJson(
  Map<String, dynamic> json,
) => ProfileCardActionDto(
  complement: json['complement'] as bool? ?? false,
  complementText: json['complementText'] as String?,
  like: json['like'] as bool? ?? false,
  passed: json['passed'] as bool? ?? false,
);

Map<String, dynamic> _$ProfileCardActionDtoToJson(
  ProfileCardActionDto instance,
) => <String, dynamic>{
  'complement': instance.complement,
  'complementText': instance.complementText,
  'like': instance.like,
  'passed': instance.passed,
};

ProfileDetailResponseDto _$ProfileDetailResponseDtoFromJson(
  Map<String, dynamic> json,
) => ProfileDetailResponseDto(
  data: ProfileDetailDataDto.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ProfileDetailResponseDtoToJson(
  ProfileDetailResponseDto instance,
) => <String, dynamic>{'data': instance.data};

ProfileDetailDataDto _$ProfileDetailDataDtoFromJson(
  Map<String, dynamic> json,
) => ProfileDetailDataDto(
  profile: json['profile'] == null
      ? null
      : ProfileDetailDto.fromJson(json['profile'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ProfileDetailDataDtoToJson(
  ProfileDetailDataDto instance,
) => <String, dynamic>{'profile': instance.profile};

ProfileDetailDto _$ProfileDetailDtoFromJson(
  Map<String, dynamic> json,
) => ProfileDetailDto(
  marriageIntentions: json['marriageIntentions'] == null
      ? null
      : ProfileMarriageIntentionsDto.fromJson(
          json['marriageIntentions'] as Map<String, dynamic>,
        ),
  aboutYou: json['aboutYou'] == null
      ? null
      : ProfileAboutYouDto.fromJson(json['aboutYou'] as Map<String, dynamic>),
  faceVerification: json['faceVerification'] == null
      ? null
      : ProfileFaceVerificationDto.fromJson(
          json['faceVerification'] as Map<String, dynamic>,
        ),
  languages:
      (json['languages'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  personalityTraits:
      (json['personalityTraits'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const <String>[],
  religiousPractices:
      (json['religiousPractices'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const <String>[],
  grewUpIn:
      (json['grewUpIn'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
);

Map<String, dynamic> _$ProfileDetailDtoToJson(ProfileDetailDto instance) =>
    <String, dynamic>{
      'marriageIntentions': instance.marriageIntentions,
      'aboutYou': instance.aboutYou,
      'faceVerification': instance.faceVerification,
      'languages': instance.languages,
      'personalityTraits': instance.personalityTraits,
      'religiousPractices': instance.religiousPractices,
      'grewUpIn': instance.grewUpIn,
    };

ProfileMarriageIntentionsDto _$ProfileMarriageIntentionsDtoFromJson(
  Map<String, dynamic> json,
) => ProfileMarriageIntentionsDto(
  getToknowDuration: json['getToknowDuration'] as String?,
  marriageTimeline: json['marriageTimeline'] as String?,
);

Map<String, dynamic> _$ProfileMarriageIntentionsDtoToJson(
  ProfileMarriageIntentionsDto instance,
) => <String, dynamic>{
  'getToknowDuration': instance.getToknowDuration,
  'marriageTimeline': instance.marriageTimeline,
};

ProfileAboutYouDto _$ProfileAboutYouDtoFromJson(Map<String, dynamic> json) =>
    ProfileAboutYouDto(
      haveChildren: json['haveChildren'] as bool?,
      relocateAbroad: json['relocateAbroad'] as bool?,
    );

Map<String, dynamic> _$ProfileAboutYouDtoToJson(ProfileAboutYouDto instance) =>
    <String, dynamic>{
      'haveChildren': instance.haveChildren,
      'relocateAbroad': instance.relocateAbroad,
    };

ProfileFaceVerificationDto _$ProfileFaceVerificationDtoFromJson(
  Map<String, dynamic> json,
) => ProfileFaceVerificationDto(
  isFaceVerified: json['isFaceVerified'] as bool? ?? false,
);

Map<String, dynamic> _$ProfileFaceVerificationDtoToJson(
  ProfileFaceVerificationDto instance,
) => <String, dynamic>{'isFaceVerified': instance.isFaceVerified};

Map<String, dynamic> _$SwipeRequestDtoToJson(SwipeRequestDto instance) =>
    <String, dynamic>{
      'action': instance.action,
      'targetUserId': ?instance.targetUserId,
      'text': ?instance.text,
    };

SwipeResponseDto _$SwipeResponseDtoFromJson(Map<String, dynamic> json) =>
    SwipeResponseDto(
      data: json['data'] == null
          ? null
          : SwipeResponseDataDto.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SwipeResponseDtoToJson(SwipeResponseDto instance) =>
    <String, dynamic>{'data': instance.data};

SwipeResponseDataDto _$SwipeResponseDataDtoFromJson(
  Map<String, dynamic> json,
) => SwipeResponseDataDto(isMatch: json['isMatch'] as bool? ?? false);

Map<String, dynamic> _$SwipeResponseDataDtoToJson(
  SwipeResponseDataDto instance,
) => <String, dynamic>{'isMatch': instance.isMatch};
