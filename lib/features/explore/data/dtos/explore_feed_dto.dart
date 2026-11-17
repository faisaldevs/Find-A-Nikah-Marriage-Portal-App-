import 'package:json_annotation/json_annotation.dart';

part 'explore_feed_dto.g.dart';

/// `GET /v1/profiles/feed/{near-you|just-joined|second-look|passed|
/// visited-you}?page=&limit=` → `{data: {profiles, pagination, tag, ...}}`.
/// Only what the Explore cards read; per-feed extras (`viewerCoordinates`,
/// `radiusKm`, `matchedPreference`, `daysFilter`, …) are ignored.
@JsonSerializable()
class ProfileFeedResponseDto {
  const ProfileFeedResponseDto({
    required this.data,
  });

  factory ProfileFeedResponseDto.fromJson(Map<String, dynamic> json) =>
      _$ProfileFeedResponseDtoFromJson(json);

  final ProfileFeedDataDto data;

  Map<String, dynamic> toJson() => _$ProfileFeedResponseDtoToJson(this);
}

@JsonSerializable(explicitToJson: true)
class ProfileFeedDataDto {
  const ProfileFeedDataDto({
    this.profiles = const <ProfileFeedItemDto>[],
    this.pagination = const ProfileFeedPaginationDto(),
    this.totalCount,
    this.locked = false,
    this.viewerCoordinates,
  });

  factory ProfileFeedDataDto.fromJson(Map<String, dynamic> json) =>
      _$ProfileFeedDataDtoFromJson(json);

  final List<ProfileFeedItemDto> profiles;
  final ProfileFeedPaginationDto pagination;

  /// Premium-gated responses send no `pagination`, just a top-level
  /// count — and, while [locked], an empty [profiles]. (Everything is
  /// free for now, so no feed sends this today.)
  final int? totalCount;

  /// Free members can't open these profiles: cards show with the lock and
  /// do nothing on tap.
  final bool locked;

  /// `near-you` / `currently-available`: where the server measured distance
  /// from; null when it had no location for the member.
  final Map<String, dynamic>? viewerCoordinates;

  Map<String, dynamic> toJson() => _$ProfileFeedDataDtoToJson(this);
}

@JsonSerializable()
class ProfileFeedPaginationDto {
  const ProfileFeedPaginationDto({
    this.currentPage = 1,
    this.limit,
    this.totalPages,
    this.totalCount = 0,
    this.hasNext = false,
    this.hasPrev = false,
  });

  factory ProfileFeedPaginationDto.fromJson(Map<String, dynamic> json) =>
      _$ProfileFeedPaginationDtoFromJson(json);

  final int currentPage;
  final int? limit;
  final int? totalPages;
  final int totalCount;
  final bool hasNext;
  final bool hasPrev;

  Map<String, dynamic> toJson() => _$ProfileFeedPaginationDtoToJson(this);
}

/// One profile in a feed. Carries the full payload (incl. the `like-list`
/// extras `likeId`, `likeStatus`, `tag`, `action`); the cards read only part
/// of it.
@JsonSerializable(explicitToJson: true)
class ProfileFeedItemDto {
  const ProfileFeedItemDto({
    required this.userId,
    this.profileId,
    this.fullName = '',
    this.isVerified = false,
    this.lastActiveAt,
    this.gender,
    this.photoUrl,
    this.images = const <String>[],
    this.age,
    this.dateOfBirth,
    this.maritalStatus,
    this.professionTitle,
    this.educationLevel,
    this.religion,
    this.faith = const <String>[],
    this.sect = const <String>[],
    this.city,
    this.country,
    this.distanceKm,
    this.completeness,
    this.publishedAt,
    this.passedAt,
    this.viewedAt,
    this.likedAt,
    this.likeId,
    this.likeStatus,
    this.complement = false,
    this.isComplement = false,
    this.complemented = false,
    this.complementText,
    this.tag,
    this.action,
  });

  factory ProfileFeedItemDto.fromJson(Map<String, dynamic> json) =>
      _$ProfileFeedItemDtoFromJson(json);

  final String userId;
  final String? profileId;
  final String fullName;
  final bool isVerified;
  final String? lastActiveAt;
  final String? gender;

  /// Server-relative (`/public/upload/x.jpg`).
  final String? photoUrl;
  final List<String> images;

  final int? age;

  /// ISO-8601.
  final String? dateOfBirth;
  final String? maritalStatus;
  final String? professionTitle;
  final String? educationLevel;
  final String? religion;
  final List<String> faith;
  final List<String> sect;
  final String? city;
  final String? country;
  final double? distanceKm;

  /// 0–100.
  final int? completeness;
  final String? publishedAt;

  /// `passed` feed only — when the member passed on this profile.
  final String? passedAt;

  /// `visited-you` feed only — when this member last viewed the profile.
  final String? viewedAt;

  /// `like-list` only — when this member liked you (joined in from the
  /// wrapped `likes` entries; the flat profile carries no time).
  final String? likedAt;

  /// `like-list` / `who-liked-me` only.
  final String? likeId;

  /// `pending`, …
  final String? likeStatus;
  final bool complement;
  final bool isComplement;
  final bool complemented;
  final String? complementText;

  /// Section label, e.g. `Like`.
  final String? tag;
  final ProfileFeedActionDto? action;

  ProfileFeedItemDto withLikedAt(String? at) =>
      ProfileFeedItemDto.fromJson({...toJson(), 'likedAt': at});

  Map<String, dynamic> toJson() => _$ProfileFeedItemDtoToJson(this);
}

/// Viewer's reaction to a profile (`action` on feed / like-list items).
@JsonSerializable()
class ProfileFeedActionDto {
  const ProfileFeedActionDto({
    this.complement = false,
    this.complementText,
    this.like = false,
    this.passed = false,
  });

  factory ProfileFeedActionDto.fromJson(Map<String, dynamic> json) =>
      _$ProfileFeedActionDtoFromJson(json);

  final bool complement;
  final String? complementText;
  final bool like;
  final bool passed;

  Map<String, dynamic> toJson() => _$ProfileFeedActionDtoToJson(this);
}

/// `GET /v1/likes/like-list` →
/// `{data: {likes: [{likeId, likedAt, status, sender, profile}], profiles,
/// pagination}}`. `profiles` is the flat list every other feed uses;
/// `likes` wraps the same people with the time of the like. Normalised into
/// [ProfileFeedDataDto] by [LikeListDataDto.toFeedData] so it caches and
/// maps like every other feed.
@JsonSerializable(createToJson: false)
class LikeListResponseDto {
  const LikeListResponseDto({
    required this.data,
  });

  factory LikeListResponseDto.fromJson(Map<String, dynamic> json) =>
      _$LikeListResponseDtoFromJson(json);

  final LikeListDataDto data;
}

@JsonSerializable(createToJson: false)
class LikeListDataDto {
  const LikeListDataDto({
    this.profiles = const <ProfileFeedItemDto>[],
    this.likes = const <ProfileFeedItemDto>[],
    this.pagination,
    this.totalCount,
    this.locked = false,
  });

  factory LikeListDataDto.fromJson(Map<String, dynamic> json) =>
      _$LikeListDataDtoFromJson(json);

  /// The flat profile list (preferred).
  final List<ProfileFeedItemDto> profiles;

  /// The wrapped entries, unwrapped to profiles carrying `likedAt`. Used
  /// for the time of each like, and as the list itself when [profiles] is
  /// absent.
  @JsonKey(fromJson: _likeItems)
  final List<ProfileFeedItemDto> likes;

  final ProfileFeedPaginationDto? pagination;

  /// Older / locked responses: a top-level count instead of [pagination].
  final int? totalCount;
  final bool locked;

  ProfileFeedDataDto toFeedData() {
    final likedAt = {
      for (final l in likes)
        if (l.likedAt != null) l.userId: l.likedAt,
    };
    final items = profiles.isNotEmpty
        ? [
            for (final p in profiles)
              likedAt[p.userId] == null ? p : p.withLikedAt(likedAt[p.userId]),
          ]
        : likes;
    return ProfileFeedDataDto(
      profiles: items,
      pagination:
          pagination ??
          ProfileFeedPaginationDto(totalCount: totalCount ?? items.length),
      totalCount: totalCount,
      locked: locked,
    );
  }
}

/// Accepts a wrapped entry (`{likeId, likedAt, profile: {...}}`) or a flat
/// profile; anything without a `userId` is skipped rather than failing the
/// section. The wrapper's `likedAt` is copied onto the profile.
List<ProfileFeedItemDto> _likeItems(Object? raw) => [
  for (final item in (raw as List<Object?>? ?? const []))
    if (item is Map<String, dynamic>)
      if (_profileIn(item) case final profile?)
        ProfileFeedItemDto.fromJson({
          ...profile,
          if (item['likedAt'] is String) 'likedAt': item['likedAt'],
        }),
];

Map<String, dynamic>? _profileIn(Map<String, dynamic> item) {
  if (item['userId'] is String) return item;
  for (final value in item.values) {
    if (value is Map<String, dynamic> && value['userId'] is String) {
      return value;
    }
  }
  return null;
}
