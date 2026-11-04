// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_matches_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MyMatchesResponseDto _$MyMatchesResponseDtoFromJson(
  Map<String, dynamic> json,
) => MyMatchesResponseDto(
  data: MyMatchesDataDto.fromJson(json['data'] as Map<String, dynamic>),
);

MyMatchesDataDto _$MyMatchesDataDtoFromJson(Map<String, dynamic> json) =>
    MyMatchesDataDto(
      matches:
          (json['matches'] as List<dynamic>?)
              ?.map((e) => MatchDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      pagination: json['pagination'] == null
          ? const MatchesPaginationDto()
          : MatchesPaginationDto.fromJson(
              json['pagination'] as Map<String, dynamic>,
            ),
    );

MatchesPaginationDto _$MatchesPaginationDtoFromJson(
  Map<String, dynamic> json,
) => MatchesPaginationDto(
  currentPage: (json['currentPage'] as num?)?.toInt() ?? 1,
  hasNext: json['hasNext'] as bool? ?? false,
);

MatchDto _$MatchDtoFromJson(Map<String, dynamic> json) => MatchDto(
  matchId: json['matchId'] as String,
  status: json['status'] as String?,
  partner: json['partner'] == null
      ? null
      : MatchPartnerDto.fromJson(json['partner'] as Map<String, dynamic>),
  profile: json['profile'] == null
      ? null
      : MatchProfileDto.fromJson(json['profile'] as Map<String, dynamic>),
  conversationId: json['conversationId'] as String?,
  canMessage: json['canMessage'] as bool? ?? true,
);

MatchPartnerDto _$MatchPartnerDtoFromJson(Map<String, dynamic> json) =>
    MatchPartnerDto(
      id: json['_id'] as String,
      fullName: json['fullName'] as String?,
      lastActiveAt: json['lastActiveAt'] as String?,
    );

MatchProfileDto _$MatchProfileDtoFromJson(Map<String, dynamic> json) =>
    MatchProfileDto(
      userId: json['userId'] as String?,
      fullName: json['fullName'] as String?,
      photoUrl: json['photoUrl'] as String?,
      images:
          (json['images'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      lastActiveAt: json['lastActiveAt'] as String?,
    );
