// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'marriage_profile_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MarriageProfileDto _$MarriageProfileDtoFromJson(
  Map<String, dynamic> json,
) => MarriageProfileDto(
  id: json['id'] as String,
  name: json['name'] as String,
  age: (json['age'] as num).toInt(),
  distanceKm: (json['distanceKm'] as num).toDouble(),
  area: json['area'] as String,
  country: json['country'] as String,
  countryFlag: json['countryFlag'] as String,
  profession: json['profession'] as String,
  practice: json['practice'] as String,
  ethnicity: json['ethnicity'] as String,
  ethnicityFlag: json['ethnicityFlag'] as String,
  photoUrls: (json['photoUrls'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  heightCm: (json['heightCm'] as num).toInt(),
  maritalStatus: json['maritalStatus'] as String,
  children: json['children'] as String,
  involveFamily: json['involveFamily'] as String,
  chatFor: json['chatFor'] as String,
  marryWithin: json['marryWithin'] as String,
  education: json['education'] as String,
  grewUpIn: json['grewUpIn'] as String,
  grewUpFlag: json['grewUpFlag'] as String,
  bio: json['bio'] as String,
  isVerified: json['isVerified'] as bool? ?? false,
  isActiveToday: json['isActiveToday'] as bool? ?? false,
  isPremium: json['isPremium'] as bool? ?? false,
  similarities:
      (json['similarities'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  faith:
      (json['faith'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  futurePlans:
      (json['futurePlans'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  interests:
      (json['interests'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  personality:
      (json['personality'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  languages:
      (json['languages'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  isPhotoVerified: json['isPhotoVerified'] as bool? ?? false,
  isAgeVerified: json['isAgeVerified'] as bool? ?? false,
  isIdVerified: json['isIdVerified'] as bool? ?? false,
);

Map<String, dynamic> _$MarriageProfileDtoToJson(MarriageProfileDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'age': instance.age,
      'distanceKm': instance.distanceKm,
      'area': instance.area,
      'country': instance.country,
      'countryFlag': instance.countryFlag,
      'profession': instance.profession,
      'practice': instance.practice,
      'ethnicity': instance.ethnicity,
      'ethnicityFlag': instance.ethnicityFlag,
      'photoUrls': instance.photoUrls,
      'isVerified': instance.isVerified,
      'isActiveToday': instance.isActiveToday,
      'isPremium': instance.isPremium,
      'similarities': instance.similarities,
      'heightCm': instance.heightCm,
      'maritalStatus': instance.maritalStatus,
      'children': instance.children,
      'involveFamily': instance.involveFamily,
      'chatFor': instance.chatFor,
      'marryWithin': instance.marryWithin,
      'faith': instance.faith,
      'futurePlans': instance.futurePlans,
      'interests': instance.interests,
      'personality': instance.personality,
      'education': instance.education,
      'languages': instance.languages,
      'grewUpIn': instance.grewUpIn,
      'grewUpFlag': instance.grewUpFlag,
      'bio': instance.bio,
      'isPhotoVerified': instance.isPhotoVerified,
      'isAgeVerified': instance.isAgeVerified,
      'isIdVerified': instance.isIdVerified,
    };

MarriageFeedPageDto _$MarriageFeedPageDtoFromJson(Map<String, dynamic> json) =>
    MarriageFeedPageDto(
      items: (json['items'] as List<dynamic>)
          .map((e) => MarriageProfileDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      nextCursor: json['nextCursor'] as String?,
    );

Map<String, dynamic> _$MarriageFeedPageDtoToJson(
  MarriageFeedPageDto instance,
) => <String, dynamic>{
  'items': instance.items,
  'nextCursor': instance.nextCursor,
};
