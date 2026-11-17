import 'package:dio/dio.dart';
import 'package:find_a_nikah/features/explore/data/dtos/explore_feed_dto.dart';
import 'package:retrofit/retrofit.dart';

part 'explore_remote_data_source.g.dart';

/// Explore's real endpoints. Same base as the Marriage cards data source:
/// `api.dio`, `/v1` in the path.
@RestApi()
abstract class ExploreRemoteDataSource {
  factory ExploreRemoteDataSource(Dio dio) = _ExploreRemoteDataSource;

  /// One page of a profile feed — [feed] is `near-you`, `just-joined`,
  /// `second-look`, `passed`, `visited-you` or `currently-available` (same
  /// response shape). 1-based [page]; the response echoes `currentPage` /
  /// `hasNext`. [latitude]/[longitude] (send both or neither) are the
  /// device position for distance ordering; omitted, the server uses the
  /// saved profile location.
  @GET('/v1/profiles/feed/{feed}')
  Future<ProfileFeedResponseDto> fetchFeed(
    @Path('feed') String feed, {
    @Query('page') required int page,
    @Query('limit') required int limit,
    @Query('latitude') double? latitude,
    @Query('longitude') double? longitude,
  });

  /// Members who liked me ("Liked you" on For you). Same wrapped shape as
  /// [fetchLikeList].
  @GET('/v1/likes/who-liked-me')
  Future<LikeListResponseDto> fetchWhoLikedMe({
    @Query('page') required int page,
    @Query('limit') required int limit,
  });

  /// Members I liked (My history → Liked). `/v1/likes/sent` — the old
  /// `/v1/likes/like-list` now answers "Who Liked You" (members who liked
  /// me) and was always empty here (found on 2026-11-15).
  // @GET('/v1/likes/like-list')
  @GET('/v1/likes/sent')
  Future<LikeListResponseDto> fetchLikeList({
    @Query('page') required int page,
    @Query('limit') required int limit,
  });

  /// Members I added to favourites (My history → Favourited). Same wrapped
  /// shape as [fetchLikeList].
  @GET('/v1/favorites')
  Future<LikeListResponseDto> fetchFavourites({
    @Query('page') required int page,
    @Query('limit') required int limit,
  });

  /// Members I sent a compliment to (My history → Complimented).
  @GET('/v1/likes/compliments-sent')
  Future<LikeListResponseDto> fetchComplimentsSent({
    @Query('page') required int page,
    @Query('limit') required int limit,
  });
}
