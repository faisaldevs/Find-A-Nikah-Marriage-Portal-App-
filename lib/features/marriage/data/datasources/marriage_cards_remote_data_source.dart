import 'package:dio/dio.dart';
import 'package:find_a_nikah/features/marriage/data/dtos/profile_card_dto.dart';
import 'package:retrofit/retrofit.dart';

part 'marriage_cards_remote_data_source.g.dart';

/// The real discovery API (replaces the placeholder
/// `MarriageRemoteDataSource` → `/discovery/profiles`, which never existed).
/// Same base as the onboarding data source: `api.dio`, `/v1` in the path.
@RestApi()
abstract class MarriageCardsRemoteDataSource {
  factory MarriageCardsRemoteDataSource(Dio dio) =
      _MarriageCardsRemoteDataSource;

  /// Swipe deck for the signed-in member (opposite gender, same religion,
  /// server-side). Confirmed query params: `limit`, `minAge`, `maxAge`,
  /// `country` (country name). GET only — POST is 404.
  @GET('/v1/profiles/cards')
  Future<ProfileCardsResponseDto> fetchCards(
    @Queries() Map<String, dynamic> query,
  );

  /// Full profile by **userId** (a profileId is 404).
  @GET('/v1/profiles/{userId}')
  Future<ProfileDetailResponseDto> fetchProfile(@Path() String userId);

  /// `{action: pass|like|undo, targetUserId}`; undo needs no target and
  /// rewinds the last pass only.
  @POST('/v1/profiles/swipe')
  /// [body] is `SwipeRequestDto.toJson()` (a map, so Dio encodes it the
  /// same way as every other JSON body).
  Future<SwipeResponseDto> swipe(@Body() Map<String, dynamic> body);
}
