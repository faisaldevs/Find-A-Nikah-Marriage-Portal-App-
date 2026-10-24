// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_card_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProfileCardsResponseDto _$ProfileCardsResponseDtoFromJson(
  Map<String, dynamic> json,
) => _ProfileCardsResponseDto(
  data: ProfileCardsDataDto.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ProfileCardsResponseDtoToJson(
  _ProfileCardsResponseDto instance,
) => <String, dynamic>{'data': instance.data};

_ProfileCardsDataDto _$ProfileCardsDataDtoFromJson(Map<String, dynamic> json) =>
    _ProfileCardsDataDto(
      cards:
          (json['cards'] as List<dynamic>?)
              ?.map((e) => ProfileCardDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <ProfileCardDto>[],
      hasMore: json['hasMore'] as bool? ?? false,
    );

Map<String, dynamic> _$ProfileCardsDataDtoToJson(
  _ProfileCardsDataDto instance,
) => <String, dynamic>{'cards': instance.cards, 'hasMore': instance.hasMore};

_ProfileCardDto _$ProfileCardDtoFromJson(
  Map<String, dynamic> json,
) => _ProfileCardDto(
  userId: json['userId'] as String,
  fullName: json['fullName'] as String? ?? '',
  isVerified: json['isVerified'] as bool? ?? false,
  lastActiveAt: json['lastActiveAt'] as String?,
  age: (json['age'] as num?)?.toInt(),
  faith:
      (json['faith'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  ethnicity:
      (json['ethnicity'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  country: json['country'] as String?,
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
);

Map<String, dynamic> _$ProfileCardDtoToJson(_ProfileCardDto instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'fullName': instance.fullName,
      'isVerified': instance.isVerified,
      'lastActiveAt': instance.lastActiveAt,
      'age': instance.age,
      'faith': instance.faith,
      'ethnicity': instance.ethnicity,
      'country': instance.country,
      'distanceKm': instance.distanceKm,
      'aboutMe': instance.aboutMe,
      'educationLevel': instance.educationLevel,
      'professionTitle': instance.professionTitle,
      'maritalStatus': instance.maritalStatus,
      'heightCm': instance.heightCm,
      'images': instance.images,
      'primaryPhoto': instance.primaryPhoto,
      'allInterests': instance.allInterests,
      'sharedInterests': instance.sharedInterests,
    };

_ProfileDetailResponseDto _$ProfileDetailResponseDtoFromJson(
  Map<String, dynamic> json,
) => _ProfileDetailResponseDto(
  data: ProfileDetailDataDto.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ProfileDetailResponseDtoToJson(
  _ProfileDetailResponseDto instance,
) => <String, dynamic>{'data': instance.data};

_ProfileDetailDataDto _$ProfileDetailDataDtoFromJson(
  Map<String, dynamic> json,
) => _ProfileDetailDataDto(
  profile: json['profile'] == null
      ? null
      : ProfileDetailDto.fromJson(json['profile'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ProfileDetailDataDtoToJson(
  _ProfileDetailDataDto instance,
) => <String, dynamic>{'profile': instance.profile};

_ProfileDetailDto _$ProfileDetailDtoFromJson(
  Map<String, dynamic> json,
) => _ProfileDetailDto(
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

Map<String, dynamic> _$ProfileDetailDtoToJson(_ProfileDetailDto instance) =>
    <String, dynamic>{
      'marriageIntentions': instance.marriageIntentions,
      'aboutYou': instance.aboutYou,
      'faceVerification': instance.faceVerification,
      'languages': instance.languages,
      'personalityTraits': instance.personalityTraits,
      'religiousPractices': instance.religiousPractices,
      'grewUpIn': instance.grewUpIn,
    };

_ProfileMarriageIntentionsDto _$ProfileMarriageIntentionsDtoFromJson(
  Map<String, dynamic> json,
) => _ProfileMarriageIntentionsDto(
  getToknowDuration: json['getToknowDuration'] as String?,
  marriageTimeline: json['marriageTimeline'] as String?,
);

Map<String, dynamic> _$ProfileMarriageIntentionsDtoToJson(
  _ProfileMarriageIntentionsDto instance,
) => <String, dynamic>{
  'getToknowDuration': instance.getToknowDuration,
  'marriageTimeline': instance.marriageTimeline,
};

_ProfileAboutYouDto _$ProfileAboutYouDtoFromJson(Map<String, dynamic> json) =>
    _ProfileAboutYouDto(
      haveChildren: json['haveChildren'] as bool?,
      relocateAbroad: json['relocateAbroad'] as bool?,
    );

Map<String, dynamic> _$ProfileAboutYouDtoToJson(_ProfileAboutYouDto instance) =>
    <String, dynamic>{
      'haveChildren': instance.haveChildren,
      'relocateAbroad': instance.relocateAbroad,
    };

_ProfileFaceVerificationDto _$ProfileFaceVerificationDtoFromJson(
  Map<String, dynamic> json,
) => _ProfileFaceVerificationDto(
  isFaceVerified: json['isFaceVerified'] as bool? ?? false,
);

Map<String, dynamic> _$ProfileFaceVerificationDtoToJson(
  _ProfileFaceVerificationDto instance,
) => <String, dynamic>{'isFaceVerified': instance.isFaceVerified};

Map<String, dynamic> _$SwipeRequestDtoToJson(_SwipeRequestDto instance) =>
    <String, dynamic>{
      'action': instance.action,
      'targetUserId': ?instance.targetUserId,
    };

_SwipeResponseDto _$SwipeResponseDtoFromJson(Map<String, dynamic> json) =>
    _SwipeResponseDto(
      data: json['data'] == null
          ? null
          : SwipeResponseDataDto.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SwipeResponseDtoToJson(_SwipeResponseDto instance) =>
    <String, dynamic>{'data': instance.data};

_SwipeResponseDataDto _$SwipeResponseDataDtoFromJson(
  Map<String, dynamic> json,
) => _SwipeResponseDataDto(isMatch: json['isMatch'] as bool? ?? false);

Map<String, dynamic> _$SwipeResponseDataDtoToJson(
  _SwipeResponseDataDto instance,
) => <String, dynamic>{'isMatch': instance.isMatch};
