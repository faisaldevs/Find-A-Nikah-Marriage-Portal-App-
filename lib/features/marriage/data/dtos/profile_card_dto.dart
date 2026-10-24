import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_card_dto.freezed.dart';
part 'profile_card_dto.g.dart';

/// `GET /v1/profiles/cards` → `{data: {cards, totalReturned, limit, hasMore,
/// viewerGender, targetGender, targetReligion}}`. No paging parameter:
/// `limit` is the only knob (page/offset/skip are ignored).
@freezed
abstract class ProfileCardsResponseDto with _$ProfileCardsResponseDto {
  const factory ProfileCardsResponseDto({required ProfileCardsDataDto data}) =
      _ProfileCardsResponseDto;

  factory ProfileCardsResponseDto.fromJson(Map<String, dynamic> json) =>
      _$ProfileCardsResponseDtoFromJson(json);
}

@freezed
abstract class ProfileCardsDataDto with _$ProfileCardsDataDto {
  const factory ProfileCardsDataDto({
    @Default(<ProfileCardDto>[]) List<ProfileCardDto> cards,
    @Default(false) bool hasMore,
  }) = _ProfileCardsDataDto;

  factory ProfileCardsDataDto.fromJson(Map<String, dynamic> json) =>
      _$ProfileCardsDataDtoFromJson(json);
}

/// One swipe card. Only what the Marriage tab reads; the rest of the
/// payload (`location`, `matchScore`, `completeness`, …) is ignored.
@freezed
abstract class ProfileCardDto with _$ProfileCardDto {
  const factory ProfileCardDto({
    required String userId,
    @Default('') String fullName,
    @Default(false) bool isVerified,
    String? lastActiveAt,
    int? age,
    @Default(<String>[]) List<String> faith,
    @Default(<String>[]) List<String> ethnicity,
    String? country,
    double? distanceKm,
    String? aboutMe,
    String? educationLevel,
    String? professionTitle,
    String? maritalStatus,
    int? heightCm,

    /// Server-relative (`/public/upload/x.jpg`).
    @Default(<String>[]) List<String> images,
    String? primaryPhoto,
    @Default(<String>[]) List<String> allInterests,
    @Default(<String>[]) List<String> sharedInterests,
  }) = _ProfileCardDto;

  factory ProfileCardDto.fromJson(Map<String, dynamic> json) =>
      _$ProfileCardDtoFromJson(json);
}

/// `GET /v1/profiles/{userId}` → `{data: {userId, fullName, isVerified,
/// profile: {...}, isMatch, hasLiked, ...}}`. Read for the fields the card
/// leaves out (intentions, lifestyle, languages, personality, practice).
@freezed
abstract class ProfileDetailResponseDto with _$ProfileDetailResponseDto {
  const factory ProfileDetailResponseDto({required ProfileDetailDataDto data}) =
      _ProfileDetailResponseDto;

  factory ProfileDetailResponseDto.fromJson(Map<String, dynamic> json) =>
      _$ProfileDetailResponseDtoFromJson(json);
}

@freezed
abstract class ProfileDetailDataDto with _$ProfileDetailDataDto {
  const factory ProfileDetailDataDto({ProfileDetailDto? profile}) =
      _ProfileDetailDataDto;

  factory ProfileDetailDataDto.fromJson(Map<String, dynamic> json) =>
      _$ProfileDetailDataDtoFromJson(json);
}

@freezed
abstract class ProfileDetailDto with _$ProfileDetailDto {
  const factory ProfileDetailDto({
    ProfileMarriageIntentionsDto? marriageIntentions,
    ProfileAboutYouDto? aboutYou,
    ProfileFaceVerificationDto? faceVerification,
    @Default(<String>[]) List<String> languages,
    @Default(<String>[]) List<String> personalityTraits,
    @Default(<String>[]) List<String> religiousPractices,
    @Default(<String>[]) List<String> grewUpIn,
  }) = _ProfileDetailDto;

  factory ProfileDetailDto.fromJson(Map<String, dynamic> json) =>
      _$ProfileDetailDtoFromJson(json);
}

@freezed
abstract class ProfileMarriageIntentionsDto
    with _$ProfileMarriageIntentionsDto {
  const factory ProfileMarriageIntentionsDto({
    /// `3-4_months` — how long they'd chat ("Chatting").
    String? getToknowDuration,

    /// `4-12_months` — how soon they'd marry ("Marriage").
    String? marriageTimeline,
  }) = _ProfileMarriageIntentionsDto;

  factory ProfileMarriageIntentionsDto.fromJson(Map<String, dynamic> json) =>
      _$ProfileMarriageIntentionsDtoFromJson(json);
}

@freezed
abstract class ProfileAboutYouDto with _$ProfileAboutYouDto {
  const factory ProfileAboutYouDto({bool? haveChildren, bool? relocateAbroad}) =
      _ProfileAboutYouDto;

  factory ProfileAboutYouDto.fromJson(Map<String, dynamic> json) =>
      _$ProfileAboutYouDtoFromJson(json);
}

@freezed
abstract class ProfileFaceVerificationDto with _$ProfileFaceVerificationDto {
  const factory ProfileFaceVerificationDto({
    @Default(false) bool isFaceVerified,
  }) = _ProfileFaceVerificationDto;

  factory ProfileFaceVerificationDto.fromJson(Map<String, dynamic> json) =>
      _$ProfileFaceVerificationDtoFromJson(json);
}

/// `POST /v1/profiles/swipe` body. `targetUserId` is omitted for `undo`.
@Freezed(fromJson: false, toJson: true)
abstract class SwipeRequestDto with _$SwipeRequestDto {
  const factory SwipeRequestDto({
    required String action,
    @JsonKey(includeIfNull: false) String? targetUserId,
  }) = _SwipeRequestDto;
}

/// `{data: {action, targetUserId, isMatch, matchId, conversationId}}` for
/// like; pass/undo leave out the match fields (undo also returns the
/// rewound `card`, which isn't read).
@freezed
abstract class SwipeResponseDto with _$SwipeResponseDto {
  const factory SwipeResponseDto({SwipeResponseDataDto? data}) =
      _SwipeResponseDto;

  factory SwipeResponseDto.fromJson(Map<String, dynamic> json) =>
      _$SwipeResponseDtoFromJson(json);
}

@freezed
abstract class SwipeResponseDataDto with _$SwipeResponseDataDto {
  const factory SwipeResponseDataDto({@Default(false) bool isMatch}) =
      _SwipeResponseDataDto;

  factory SwipeResponseDataDto.fromJson(Map<String, dynamic> json) =>
      _$SwipeResponseDataDtoFromJson(json);
}
