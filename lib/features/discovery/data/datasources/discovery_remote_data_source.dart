import 'package:dio/dio.dart';
import 'package:find_a_nikah/features/discovery/data/dtos/location_step_request.dart';
import 'package:retrofit/retrofit.dart';

part 'discovery_remote_data_source.g.dart';

/// Same base as the onboarding data source: `api.dio`, `/v1` in the path.
@RestApi()
abstract class DiscoveryRemoteDataSource {
  factory DiscoveryRemoteDataSource(Dio dio) = _DiscoveryRemoteDataSource;

  /// Onboarding step 11 — location preference.
  @PATCH('/v1/onboarding/step')
  Future<void> submitLocation(@Body() LocationStepRequestDto body);
}
