import 'package:dio/dio.dart';
import 'package:find_a_nikah/features/messaging/data/dtos/my_matches_dto.dart';
import 'package:retrofit/retrofit.dart';

part 'matches_remote_data_source.g.dart';

/// The Chat tab's Matches panel. Same base as the other feature data
/// sources: `api.dio`, `/v1` in the path. Conversations and messages live in
/// `ChatRemoteDataSource`.
@RestApi()
abstract class MatchesRemoteDataSource {
  factory MatchesRemoteDataSource(Dio dio) = _MatchesRemoteDataSource;

  /// One page of the signed-in user's matches. 1-based [page]; the
  /// response echoes `currentPage` / `hasNext`.
  @GET('/v1/matches/my-matches')
  Future<MyMatchesResponseDto> fetchMyMatches({
    @Query('page') required int page,
    @Query('limit') required int limit,
  });

  /// Ended matches. Same row shape as `my-matches`. (Use the query form:
  /// `/matches/unmatched` returned the *active* matches when checked.)
  @GET('/v1/matches')
  Future<MyMatchesResponseDto> fetchUnmatched({
    @Query('status') String status = 'unmatched',
    @Query('page') required int page,
    @Query('limit') required int limit,
  });

  /// The full profile of a matched member (raw JSON: `{ data: { profile:
  /// {...} } }`). The app reads only the fields it shows.
  @GET('/v1/profiles/{userId}')
  Future<dynamic> fetchProfile(@Path('userId') String userId);
}
