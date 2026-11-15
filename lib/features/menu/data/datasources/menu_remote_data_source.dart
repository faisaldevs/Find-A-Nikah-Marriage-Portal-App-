import 'package:dio/dio.dart';
import 'package:find_a_nikah/features/menu/data/dtos/my_profile_response.dart';
import 'package:retrofit/retrofit.dart';

part 'menu_remote_data_source.g.dart';

/// Same base as the onboarding data source: `api.dio`, `/v1` in the path.
@RestApi()
abstract class MenuRemoteDataSource {
  factory MenuRemoteDataSource(Dio dio) = _MenuRemoteDataSource;

  @GET('/v1/profiles/me')
  Future<MyProfileResponseDto> getMyProfile();

  /// Body built by `profilePatchBody`. Answers with the same shape as GET.
  @PATCH('/v1/profiles/me')
  Future<MyProfileResponseDto> updateMyProfile(
    @Body() Map<String, dynamic> body,
  );

  /// `{data: {messageNotifications, messagePreview, readReceipts,
  /// showOnlineStatus, allowMessagesFrom}}` (backend chat round 3, §8).
  @GET('/v1/me/settings')
  Future<HttpResponse<dynamic>> getMySettings();

  /// Same body shape, only the keys that changed.
  @PATCH('/v1/me/settings')
  Future<HttpResponse<dynamic>> updateMySettings(
    @Body() Map<String, dynamic> body,
  );

  /// Plan + live counters: `likesRemainingToday` (-1 = unlimited),
  /// `complimentsRemaining`, `likesInYourFiltersCount`.
  @GET('/v1/subscriptions/me')
  Future<HttpResponse<dynamic>> getSubscription();

  /// Soft-deletes the account: hides the profile, removes device tokens and
  /// invalidates every session. The app then signs out locally.
  @DELETE('/v1/me')
  Future<void> deleteAccount();

  /// "Start again": clears this member's passes. `{data: {passesCleared}}`.
  @POST('/v1/me/reset-deck')
  Future<HttpResponse<dynamic>> resetDeck();

  /// Same endpoint onboarding's Photos page uses; by file name (the last
  /// segment of `/public/upload/<filename>`).
  @DELETE('/v1/onboarding/images')
  Future<void> deletePhoto(@Query('filename') String filename);
}
