import 'package:dio/dio.dart';
import 'package:find_a_nikah/features/menu/data/dtos/my_profile_response.dart';
import 'package:retrofit/retrofit.dart';

part 'menu_remote_data_source.g.dart';

/// Same base as the onboarding data source: `api.dio`, `/v1` in the path.
@RestApi()
abstract class MenuRemoteDataSource {
  factory MenuRemoteDataSource(Dio dio) = _MenuRemoteDataSource;

  /// `TODO(api)`: the onboarding status endpoint stands in for a profile
  /// API until one exists.
  @GET('/v1/onboarding/status')
  Future<MyProfileResponseDto> getMyProfile();
}
