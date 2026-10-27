import 'package:json_annotation/json_annotation.dart';

part 'profile_card_dto.g.dart';

/// `GET /v1/profiles/cards` → `{data: {cards, totalReturned, limit, hasMore,
/// viewerGender, targetGender, targetReligion}}`. No paging parameter:
/// `limit` is the only knob (page/offset/skip are ignored).
@JsonSerializable()
class ProfileCardsResponseDto {
  const ProfileCardsResponseDto({
    required this.data,
  });

  factory ProfileCardsResponseDto.fromJson(Map<String, dynamic> json) =>
      _$ProfileCardsResponseDtoFromJson(json);

  final ProfileCardsDataDto data;

  Map<String, dynamic> toJson() => _$ProfileCardsResponseDtoToJson(this);
}

@JsonSerializable()
class ProfileCardsDataDto {
  const ProfileCardsDataDto({
    this.cards = const <ProfileCardDto>[],
    this.totalReturned = 0,
    this.limit = 0,
    this.hasMore = false,
    this.viewerGender,
    this.targetGender,
    this.targetReligion,
  });

  factory ProfileCardsDataDto.fromJson(Map<String, dynamic> json) =>
      _$ProfileCardsDataDtoFromJson(json);

  final List<ProfileCardDto> cards;
  final int totalReturned;
  final int limit;
  final bool hasMore;
  final String? viewerGender;
  final String? targetGender;
  final String? targetReligion;

  Map<String, dynamic> toJson() => _$ProfileCardsDataDtoToJson(this);
}

/// One swipe card: the full `/cards` payload. The Marriage tab reads only
/// part of it (see `ProfileCardMapper`); the rest is parsed for later use.
@JsonSerializable()
class ProfileCardDto {
  const ProfileCardDto({
    required this.userId,
    this.profileId,
    this.fullName = '',
    this.isVerified = false,
    this.lastActiveAt,
    this.age,
    this.dateOfBirth,
    this.gender,
    this.religion,
    this.faith = const <String>[],
    this.ethnicity = const <String>[],
    this.country,
    this.city,
    this.location,
    this.distanceKm,
    this.aboutMe,
    this.educationLevel,
    this.professionTitle,
    this.maritalStatus,
    this.heightCm,
    this.images = const <String>[],
    this.primaryPhoto,
    this.interests,
    this.allInterests = const <String>[],
    this.sharedInterests = const <String>[],
    this.sharedCount = 0,
    this.matchScore,
    this.completeness,
    this.complement = false,
    this.complementText,
    this.action,
  });

  factory ProfileCardDto.fromJson(Map<String, dynamic> json) =>
      _$ProfileCardDtoFromJson(json);

  final String userId;
  final String? profileId;
  final String fullName;
  final bool isVerified;
  final String? lastActiveAt;
  final int? age;

  /// ISO-8601 (`1999-03-08T00:00:00.000Z`).
  final String? dateOfBirth;

  /// `male` / `female`.
  final String? gender;
  final String? religion;
  final List<String> faith;
  final List<String> ethnicity;
  final String? country;
  final String? city;

  /// Always null so far; shape unconfirmed, so left untyped.
  final Object? location;
  final double? distanceKm;
  final String? aboutMe;
  final String? educationLevel;
  final String? professionTitle;
  final String? maritalStatus;
  final int? heightCm;

  /// Server-relative (`/public/upload/x.jpg`).
  final List<String> images;

  final String? primaryPhoto;

  /// Grouped by category (cultural, foodDrinks, sports, …).
  final ProfileCardInterestsDto? interests;
  final List<String> allInterests;
  final List<String> sharedInterests;
  final int sharedCount;

  /// 0–100.
  final int? matchScore;

  /// Profile completeness, 0–100.
  final int? completeness;
  final bool complement;
  final String? complementText;

  /// Viewer's existing reaction to this card.
  final ProfileCardActionDto? action;

  Map<String, dynamic> toJson() => _$ProfileCardDtoToJson(this);
}

@JsonSerializable()
class ProfileCardInterestsDto {
  const ProfileCardInterestsDto({
    this.cultural = const <String>[],
    this.foodDrinks = const <String>[],
    this.sports = const <String>[],
    this.fashion = const <String>[],
    this.activities = const <String>[],
  });

  factory ProfileCardInterestsDto.fromJson(Map<String, dynamic> json) =>
      _$ProfileCardInterestsDtoFromJson(json);

  final List<String> cultural;
  final List<String> foodDrinks;
  final List<String> sports;
  final List<String> fashion;
  final List<String> activities;

  Map<String, dynamic> toJson() => _$ProfileCardInterestsDtoToJson(this);
}

@JsonSerializable()
class ProfileCardActionDto {
  const ProfileCardActionDto({
    this.complement = false,
    this.complementText,
    this.like = false,
    this.passed = false,
  });

  factory ProfileCardActionDto.fromJson(Map<String, dynamic> json) =>
      _$ProfileCardActionDtoFromJson(json);

  final bool complement;
  final String? complementText;
  final bool like;
  final bool passed;

  Map<String, dynamic> toJson() => _$ProfileCardActionDtoToJson(this);
}

/// `GET /v1/profiles/{userId}` → `{data: {userId, fullName, isVerified,
/// profile: {...}, isMatch, hasLiked, ...}}`. Read for the fields the card
/// leaves out (intentions, lifestyle, languages, personality, practice).
@JsonSerializable()
class ProfileDetailResponseDto {
  const ProfileDetailResponseDto({
    required this.data,
  });

  factory ProfileDetailResponseDto.fromJson(Map<String, dynamic> json) =>
      _$ProfileDetailResponseDtoFromJson(json);

  final ProfileDetailDataDto data;

  Map<String, dynamic> toJson() => _$ProfileDetailResponseDtoToJson(this);
}

@JsonSerializable()
class ProfileDetailDataDto {
  const ProfileDetailDataDto({
    this.profile,
  });

  factory ProfileDetailDataDto.fromJson(Map<String, dynamic> json) =>
      _$ProfileDetailDataDtoFromJson(json);

  final ProfileDetailDto? profile;

  Map<String, dynamic> toJson() => _$ProfileDetailDataDtoToJson(this);
}

@JsonSerializable()
class ProfileDetailDto {
  const ProfileDetailDto({
    this.marriageIntentions,
    this.aboutYou,
    this.faceVerification,
    this.languages = const <String>[],
    this.personalityTraits = const <String>[],
    this.religiousPractices = const <String>[],
    this.grewUpIn = const <String>[],
  });

  factory ProfileDetailDto.fromJson(Map<String, dynamic> json) =>
      _$ProfileDetailDtoFromJson(json);

  final ProfileMarriageIntentionsDto? marriageIntentions;
  final ProfileAboutYouDto? aboutYou;
  final ProfileFaceVerificationDto? faceVerification;
  final List<String> languages;
  final List<String> personalityTraits;
  final List<String> religiousPractices;
  final List<String> grewUpIn;

  Map<String, dynamic> toJson() => _$ProfileDetailDtoToJson(this);
}

@JsonSerializable()
class ProfileMarriageIntentionsDto {
  const ProfileMarriageIntentionsDto({
    this.getToknowDuration,
    this.marriageTimeline,
  });

  factory ProfileMarriageIntentionsDto.fromJson(Map<String, dynamic> json) =>
      _$ProfileMarriageIntentionsDtoFromJson(json);

  /// `3-4_months` — how long they'd chat ("Chatting").
  final String? getToknowDuration;

  /// `4-12_months` — how soon they'd marry ("Marriage").
  final String? marriageTimeline;

  Map<String, dynamic> toJson() => _$ProfileMarriageIntentionsDtoToJson(this);
}

@JsonSerializable()
class ProfileAboutYouDto {
  const ProfileAboutYouDto({
    this.haveChildren,
    this.relocateAbroad,
  });

  factory ProfileAboutYouDto.fromJson(Map<String, dynamic> json) =>
      _$ProfileAboutYouDtoFromJson(json);

  final bool? haveChildren;
  final bool? relocateAbroad;

  Map<String, dynamic> toJson() => _$ProfileAboutYouDtoToJson(this);
}

@JsonSerializable()
class ProfileFaceVerificationDto {
  const ProfileFaceVerificationDto({
    this.isFaceVerified = false,
  });

  factory ProfileFaceVerificationDto.fromJson(Map<String, dynamic> json) =>
      _$ProfileFaceVerificationDtoFromJson(json);

  final bool isFaceVerified;

  Map<String, dynamic> toJson() => _$ProfileFaceVerificationDtoToJson(this);
}

/// `POST /v1/profiles/swipe` body. `targetUserId` is omitted for `undo`;
/// `text` is sent only with `complement`.
@JsonSerializable(createFactory: false)
class SwipeRequestDto {
  const SwipeRequestDto({
    required this.action,
    this.targetUserId,
    this.text,
  });

  final String action;

  @JsonKey(includeIfNull: false)
  final String? targetUserId;

  @JsonKey(includeIfNull: false)
  final String? text;

  Map<String, dynamic> toJson() => _$SwipeRequestDtoToJson(this);
}

/// `{data: {action, targetUserId, isMatch, matchId, conversationId}}` for
/// like (complement adds `text`, `messageId`); pass/undo leave out the match fields (undo also returns the
/// rewound `card`, which isn't read).
@JsonSerializable()
class SwipeResponseDto {
  const SwipeResponseDto({
    this.data,
  });

  factory SwipeResponseDto.fromJson(Map<String, dynamic> json) =>
      _$SwipeResponseDtoFromJson(json);

  final SwipeResponseDataDto? data;

  Map<String, dynamic> toJson() => _$SwipeResponseDtoToJson(this);
}

@JsonSerializable()
class SwipeResponseDataDto {
  const SwipeResponseDataDto({
    this.isMatch = false,
  });

  factory SwipeResponseDataDto.fromJson(Map<String, dynamic> json) =>
      _$SwipeResponseDataDtoFromJson(json);

  final bool isMatch;

  Map<String, dynamic> toJson() => _$SwipeResponseDataDtoToJson(this);
}
