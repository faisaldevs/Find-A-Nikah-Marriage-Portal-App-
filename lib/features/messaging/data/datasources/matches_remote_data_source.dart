import 'package:dio/dio.dart';
import 'package:find_a_nikah/features/messaging/data/dtos/my_matches_dto.dart';
import 'package:retrofit/retrofit.dart';

part 'matches_remote_data_source.g.dart';

/// The Chat tab's Matches panel. Same base as the other feature data
/// sources: `api.dio`, `/v1` in the path. Conversations and messages are
/// still on `DummyMessagingDataSource`.
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
}
