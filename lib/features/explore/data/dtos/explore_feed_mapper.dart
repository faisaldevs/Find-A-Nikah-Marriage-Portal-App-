import 'package:find_a_nikah/core/ui/text/time_labels.dart';
import 'package:find_a_nikah/core/utils/profile_mapping.dart';
import 'package:find_a_nikah/features/explore/data/dtos/explore_feed_dto.dart';
import 'package:find_a_nikah/features/explore/domain/domain.dart';

extension ProfileFeedItemMapper on ProfileFeedItemDto {
  /// [now] decides "active today", so a cached copy is re-judged when it's
  /// read rather than frozen at the time it was saved.
  ExploreProfile toEntity({required String imageBaseUrl, DateTime? now}) {
    final countryName = country?.trim() ?? '';
    final cityName = city?.trim() ?? '';
    final photo = photoUrl;
    final passed = passedAt == null ? null : DateTime.tryParse(passedAt!);
    final viewed = viewedAt == null ? null : DateTime.tryParse(viewedAt!);
    final liked = likedAt == null ? null : DateTime.tryParse(likedAt!);
    // "Visited you" shows when they viewed; "Likes in your filters" when
    // they liked.
    final seen = viewed ?? liked;
    final at = now ?? DateTime.now();
    return ExploreProfile(
      id: userId,
      name: fullName,
      age: age ?? 0,
      photoUrl: photo == null || photo.isEmpty
          ? ''
          : resolveImageUrl(imageBaseUrl, photo),
      // TODO(api): `city` is null for every near-you profile so far — the
      // country name stands in until the backend fills it.
      area: cityName.isNotEmpty ? cityName : countryName,
      countryFlag: flagForCountryName(countryName),
      isVerified: isVerified,
      isActiveToday: isActiveWithinADay(lastActiveAt, at),
      profession: professionTitle?.trim(),
      distanceKm: distanceKm,
      postedAt: seen == null ? null : TimeLabels.ago(seen.toLocal(), now: at),
      // My history shows when I passed / liked.
      interactedAt: (passed ?? liked) == null
          ? null
          : TimeLabels.ago((passed ?? liked)!.toLocal(), now: at),
    );
  }
}

extension ProfileFeedDataMapper on ProfileFeedDataDto {
  ExploreSection toSection({required String imageBaseUrl, DateTime? now}) {
    final at = now ?? DateTime.now();
    return ExploreSection(
      count: totalCount ?? pagination.totalCount,
      profiles: List.unmodifiable(
        profiles.map((p) => p.toEntity(imageBaseUrl: imageBaseUrl, now: at)),
      ),
      page: pagination.currentPage,
      hasMore: pagination.hasNext,
      locked: locked,
    );
  }
}
