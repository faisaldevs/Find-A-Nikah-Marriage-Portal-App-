import 'package:dio/dio.dart';
import 'package:find_a_nikah/features/marriage/data/dtos/marriage_profile_dto.dart';
import 'package:retrofit/retrofit.dart';

part 'marriage_remote_data_source.g.dart';

/// Discovery feed. Cursor pagination (decisions register #6):
/// `?cursor=<opaque>&limit=20` plus the filter fields.
@RestApi()
abstract class MarriageRemoteDataSource {
  factory MarriageRemoteDataSource(Dio dio) = _MarriageRemoteDataSource;

  @GET('/discovery/profiles')
  Future<MarriageFeedPageDto> fetchProfiles(
    @Queries() Map<String, dynamic> query,
  );
}
