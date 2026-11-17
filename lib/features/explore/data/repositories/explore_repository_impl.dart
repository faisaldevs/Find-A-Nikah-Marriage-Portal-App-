import 'package:find_a_nikah/core/core.dart';
import 'package:find_a_nikah/core/database/database.dart';
import 'package:find_a_nikah/features/explore/data/datasources/dummy_explore_data_source.dart';
import 'package:find_a_nikah/features/explore/data/datasources/explore_remote_data_source.dart';
import 'package:find_a_nikah/features/explore/data/dtos/explore_feed_dto.dart';
import 'package:find_a_nikah/features/explore/data/dtos/explore_feed_mapper.dart';
import 'package:find_a_nikah/features/explore/domain/domain.dart';

class ExploreRepositoryImpl implements ExploreRepository {
  /// [_imageBaseUrl]: server root that `/public/upload/...` paths hang off.
  const ExploreRepositoryImpl(
    this._dummy,
    this._remote,
    this._cache,
    this._guard,
    this._imageBaseUrl, {
    this.viewerPosition,
  });

  // Dev-only for every section but "Active near you" — no API for those
  // yet (see `MarriageRepositoryImpl` for the shape a real/dummy split
  // takes).
  final DummyExploreDataSource _dummy;
  final ExploreRemoteDataSource _remote;
  final JsonCache _cache;
  final Guard _guard;
  final String _imageBaseUrl;

  /// The device position for "Currently available" (distance ordering), or
  /// null when location isn't allowed — it never asks. Without it the server
  /// falls back to the profile's saved location.
  final Future<({double latitude, double longitude})?> Function()?
  viewerPosition;

  /// Path segment under `/v1/profiles/feed/`; null = not a feed endpoint
  /// (likes come from `/v1/likes/who-liked-me` and `/v1/likes/like-list`).
  static String? feedPath(ExploreLiveSection s) => switch (s) {
    ExploreLiveSection.activeNearYou => 'near-you',
    ExploreLiveSection.currentlyAvailable => 'currently-available',
    ExploreLiveSection.justJoined => 'just-joined',
    ExploreLiveSection.secondLook => 'second-look',
    ExploreLiveSection.visitedYou => 'visited-you',
    ExploreLiveSection.passed => 'passed',
    ExploreLiveSection.likesInFilters ||
    ExploreLiveSection.liked ||
    ExploreLiveSection.favourited ||
    ExploreLiveSection.complimented => null,
  };

  static String cacheKey(ExploreLiveSection s) => 'explore.${s.name}.page1';

  /// Page size. 12 = the server default; an even number keeps the 2-row
  /// grid's columns full between pages.
  static const pageSize = 12;

  @override
  Future<Either<Failure, ExploreFeed>> fetchFeed() => _guard(_dummy.fetchFeed);

  @override
  Future<Either<Failure, ExploreHistoryFeed>> fetchHistory() =>
      _guard(_dummy.fetchHistory);

  @override
  Future<ExploreSection?> cachedSection(ExploreLiveSection section) async {
    final result = await _guard(() async {
      final json = await _cache.read(cacheKey(section));
      if (json == null) return null;
      return ProfileFeedDataDto.fromJson(
        json,
      ).toSection(imageBaseUrl: _imageBaseUrl);
    });
    // A broken cache is reported by the guard and treated as "no cache".
    return result.getOrElse((_) => null);
  }

  @override
  Future<Either<Failure, ExploreSection>> fetchSection(
    ExploreLiveSection section, {
    required int page,
  }) => _guard(() async {
    final path = feedPath(section);
    final here = section == ExploreLiveSection.currentlyAvailable
        ? await viewerPosition?.call()
        : null;
    final data = path != null
        ? (await _remote.fetchFeed(
            path,
            page: page,
            limit: pageSize,
            latitude: here?.latitude,
            longitude: here?.longitude,
          )).data
        : (await _likes(section, page)).data.toFeedData();
    if (page == 1) {
      // Saved only after a successful response; a failed write just
      // means the next launch shows the shimmer again.
      await _guard(() => _cache.write(cacheKey(section), data.toJson()));
    }
    return data.toSection(imageBaseUrl: _imageBaseUrl);
  });

  Future<LikeListResponseDto> _likes(ExploreLiveSection section, int page) =>
      switch (section) {
        ExploreLiveSection.liked => _remote.fetchLikeList(
          page: page,
          limit: pageSize,
        ),
        ExploreLiveSection.favourited => _remote.fetchFavourites(
          page: page,
          limit: pageSize,
        ),
        ExploreLiveSection.complimented => _remote.fetchComplimentsSent(
          page: page,
          limit: pageSize,
        ),
        _ => _remote.fetchWhoLikedMe(page: page, limit: pageSize),
      };
}
