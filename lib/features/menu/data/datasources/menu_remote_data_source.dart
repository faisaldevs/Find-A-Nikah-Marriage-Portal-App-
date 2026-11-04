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

  /// Same endpoint onboarding's Photos page uses; by file name (the last
  /// segment of `/public/upload/<filename>`).
  @DELETE('/v1/onboarding/images')
  Future<void> deletePhoto(@Query('filename') String filename);
}
