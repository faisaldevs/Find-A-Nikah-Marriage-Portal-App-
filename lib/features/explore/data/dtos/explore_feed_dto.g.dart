// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'explore_feed_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfileFeedResponseDto _$ProfileFeedResponseDtoFromJson(
  Map<String, dynamic> json,
) => ProfileFeedResponseDto(
  data: ProfileFeedDataDto.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ProfileFeedResponseDtoToJson(
  ProfileFeedResponseDto instance,
) => <String, dynamic>{'data': instance.data};

ProfileFeedDataDto _$ProfileFeedDataDtoFromJson(Map<String, dynamic> json) =>
    ProfileFeedDataDto(
      profiles:
          (json['profiles'] as List<dynamic>?)
              ?.map(
                (e) => ProfileFeedItemDto.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const <ProfileFeedItemDto>[],
      pagination: json['pagination'] == null
          ? const ProfileFeedPaginationDto()
          : ProfileFeedPaginationDto.fromJson(
              json['pagination'] as Map<String, dynamic>,
            ),
      totalCount: (json['totalCount'] as num?)?.toInt(),
      locked: json['locked'] as bool? ?? false,
    );

Map<String, dynamic> _$ProfileFeedDataDtoToJson(ProfileFeedDataDto instance) =>
    <String, dynamic>{
      'profiles': instance.profiles.map((e) => e.toJson()).toList(),
      'pagination': instance.pagination.toJson(),
      'totalCount': instance.totalCount,
      'locked': instance.locked,
    };

ProfileFeedPaginationDto _$ProfileFeedPaginationDtoFromJson(
  Map<String, dynamic> json,
) => ProfileFeedPaginationDto(
  currentPage: (json['currentPage'] as num?)?.toInt() ?? 1,
  limit: (json['limit'] as num?)?.toInt(),
  totalPages: (json['totalPages'] as num?)?.toInt(),
  totalCount: (json['totalCount'] as num?)?.toInt() ?? 0,
  hasNext: json['hasNext'] as bool? ?? false,
  hasPrev: json['hasPrev'] as bool? ?? false,
);

Map<String, dynamic> _$ProfileFeedPaginationDtoToJson(
  ProfileFeedPaginationDto instance,
) => <String, dynamic>{
  'currentPage': instance.currentPage,
  'limit': instance.limit,
  'totalPages': instance.totalPages,
  'totalCount': instance.totalCount,
  'hasNext': instance.hasNext,
  'hasPrev': instance.hasPrev,
};

ProfileFeedItemDto _$ProfileFeedItemDtoFromJson(
  Map<String, dynamic> json,
) => ProfileFeedItemDto(
  userId: json['userId'] as String,
  profileId: json['profileId'] as String?,
  fullName: json['fullName'] as String? ?? '',
  isVerified: json['isVerified'] as bool? ?? false,
  lastActiveAt: json['lastActiveAt'] as String?,
  gender: json['gender'] as String?,
  photoUrl: json['photoUrl'] as String?,
  images:
      (json['images'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  age: (json['age'] as num?)?.toInt(),
  dateOfBirth: json['dateOfBirth'] as String?,
  maritalStatus: json['maritalStatus'] as String?,
  professionTitle: json['professionTitle'] as String?,
  educationLevel: json['educationLevel'] as String?,
  religion: json['religion'] as String?,
  faith:
      (json['faith'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  sect:
      (json['sect'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  city: json['city'] as String?,
  country: json['country'] as String?,
  distanceKm: (json['distanceKm'] as num?)?.toDouble(),
  completeness: (json['completeness'] as num?)?.toInt(),
  publishedAt: json['publishedAt'] as String?,
  passedAt: json['passedAt'] as String?,
  viewedAt: json['viewedAt'] as String?,
  likedAt: json['likedAt'] as String?,
  likeId: json['likeId'] as String?,
  likeStatus: json['likeStatus'] as String?,
  complement: json['complement'] as bool? ?? false,
  isComplement: json['isComplement'] as bool? ?? false,
  complemented: json['complemented'] as bool? ?? false,
  complementText: json['complementText'] as String?,
  tag: json['tag'] as String?,
  action: json['action'] == null
      ? null
      : ProfileFeedActionDto.fromJson(json['action'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ProfileFeedItemDtoToJson(ProfileFeedItemDto instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'profileId': instance.profileId,
      'fullName': instance.fullName,
      'isVerified': instance.isVerified,
      'lastActiveAt': instance.lastActiveAt,
      'gender': instance.gender,
      'photoUrl': instance.photoUrl,
      'images': instance.images,
      'age': instance.age,
      'dateOfBirth': instance.dateOfBirth,
      'maritalStatus': instance.maritalStatus,
      'professionTitle': instance.professionTitle,
      'educationLevel': instance.educationLevel,
      'religion': instance.religion,
      'faith': instance.faith,
      'sect': instance.sect,
      'city': instance.city,
      'country': instance.country,
      'distanceKm': instance.distanceKm,
      'completeness': instance.completeness,
      'publishedAt': instance.publishedAt,
      'passedAt': instance.passedAt,
      'viewedAt': instance.viewedAt,
      'likedAt': instance.likedAt,
      'likeId': instance.likeId,
      'likeStatus': instance.likeStatus,
      'complement': instance.complement,
      'isComplement': instance.isComplement,
      'complemented': instance.complemented,
      'complementText': instance.complementText,
      'tag': instance.tag,
      'action': instance.action?.toJson(),
    };

ProfileFeedActionDto _$ProfileFeedActionDtoFromJson(
  Map<String, dynamic> json,
) => ProfileFeedActionDto(
  complement: json['complement'] as bool? ?? false,
  complementText: json['complementText'] as String?,
  like: json['like'] as bool? ?? false,
  passed: json['passed'] as bool? ?? false,
);

Map<String, dynamic> _$ProfileFeedActionDtoToJson(
  ProfileFeedActionDto instance,
) => <String, dynamic>{
  'complement': instance.complement,
  'complementText': instance.complementText,
  'like': instance.like,
  'passed': instance.passed,
};

LikeListResponseDto _$LikeListResponseDtoFromJson(Map<String, dynamic> json) =>
    LikeListResponseDto(
      data: LikeListDataDto.fromJson(json['data'] as Map<String, dynamic>),
    );

LikeListDataDto _$LikeListDataDtoFromJson(Map<String, dynamic> json) =>
    LikeListDataDto(
      profiles:
          (json['profiles'] as List<dynamic>?)
              ?.map(
                (e) => ProfileFeedItemDto.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const <ProfileFeedItemDto>[],
      likes: json['likes'] == null
          ? const <ProfileFeedItemDto>[]
          : _likeItems(json['likes']),
      pagination: json['pagination'] == null
          ? null
          : ProfileFeedPaginationDto.fromJson(
              json['pagination'] as Map<String, dynamic>,
            ),
      totalCount: (json['totalCount'] as num?)?.toInt(),
      locked: json['locked'] as bool? ?? false,
    );
