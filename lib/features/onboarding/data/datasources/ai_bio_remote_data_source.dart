import 'package:dio/dio.dart';
import 'package:find_a_nikah/features/onboarding/data/dtos/ai_bio_response.dart';
import 'package:retrofit/retrofit.dart';

part 'ai_bio_remote_data_source.g.dart';

@RestApi()
abstract class AiBioRemoteDataSource {
  factory AiBioRemoteDataSource(Dio dio) = _AiBioRemoteDataSource;

  @GET('/v1/onboarding/ai-bio')
  Future<AiBioResponse> generateBio();
}
