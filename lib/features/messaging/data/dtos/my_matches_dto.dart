import 'package:json_annotation/json_annotation.dart';

part 'my_matches_dto.g.dart';

/// `GET /v1/matches/my-matches?page=&limit=` →
/// `{data: {matches, pagination, totalCount}}`. Only what the Chat tab's
/// Matches panel reads; the rest of each row (`users`, `isFriend`, the
/// profile's faith / education / …) is ignored.
@JsonSerializable(createToJson: false)
class MyMatchesResponseDto {
  const MyMatchesResponseDto({required this.data});

  factory MyMatchesResponseDto.fromJson(Map<String, dynamic> json) =>
      _$MyMatchesResponseDtoFromJson(json);

  final MyMatchesDataDto data;
}

@JsonSerializable(createToJson: false)
class MyMatchesDataDto {
  const MyMatchesDataDto({
    this.matches = const [],
    this.pagination = const MatchesPaginationDto(),
  });

  factory MyMatchesDataDto.fromJson(Map<String, dynamic> json) =>
      _$MyMatchesDataDtoFromJson(json);

  final List<MatchDto> matches;
  final MatchesPaginationDto pagination;
}

@JsonSerializable(createToJson: false)
class MatchesPaginationDto {
  const MatchesPaginationDto({this.currentPage = 1, this.hasNext = false});

  factory MatchesPaginationDto.fromJson(Map<String, dynamic> json) =>
      _$MatchesPaginationDtoFromJson(json);

  final int currentPage;
  final bool hasNext;
}

/// One match, from the signed-in user's side: [partner] is the other
/// person, [profile] their card (photo lives only here).
@JsonSerializable(createToJson: false)
class MatchDto {
  const MatchDto({
    required this.matchId,
    this.status,
    this.partner,
    this.profile,
    this.conversationId,
    this.canMessage = true,
  });

  factory MatchDto.fromJson(Map<String, dynamic> json) =>
      _$MatchDtoFromJson(json);

  final String matchId;

  /// `active` seen so far; other values unconfirmed.
  final String? status;
  final MatchPartnerDto? partner;
  final MatchProfileDto? profile;

  /// The server creates the conversation when the match is made, so this
  /// is set even before the first message.
  final String? conversationId;
  final bool canMessage;
}

@JsonSerializable(createToJson: false)
class MatchPartnerDto {
  const MatchPartnerDto({
    required this.id,
    this.fullName,
    this.lastActiveAt,
  });

  factory MatchPartnerDto.fromJson(Map<String, dynamic> json) =>
      _$MatchPartnerDtoFromJson(json);

  @JsonKey(name: '_id')
  final String id;
  final String? fullName;

  /// ISO-8601.
  final String? lastActiveAt;
}

@JsonSerializable(createToJson: false)
class MatchProfileDto {
  const MatchProfileDto({
    this.userId,
    this.fullName,
    this.photoUrl,
    this.images = const [],
    this.lastActiveAt,
  });

  factory MatchProfileDto.fromJson(Map<String, dynamic> json) =>
      _$MatchProfileDtoFromJson(json);

  final String? userId;
  final String? fullName;

  /// Server-relative (`/public/upload/...`).
  final String? photoUrl;
  final List<String> images;
  final String? lastActiveAt;
}
