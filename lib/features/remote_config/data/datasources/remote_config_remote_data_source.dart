import 'package:dio/dio.dart';
import 'package:find_a_nikah/core/network/network.dart';
import 'package:find_a_nikah/features/remote_config/data/dtos/remote_config_dto.dart';
import 'package:retrofit/retrofit.dart';

part 'remote_config_remote_data_source.g.dart';

@RestApi()
abstract class RemoteConfigRemoteDataSource {
  factory RemoteConfigRemoteDataSource(Dio dio) = _RemoteConfigRemoteDataSource;

  /// Public: must work before sign-in so force-update can block old builds.
  @GET('/config')
  @Extra({requiresAuthExtraKey: false})
  Future<RemoteConfigDto> fetch();
}

/// Dev flavor: no backend yet, so every flag keeps its default.
class FakeRemoteConfigRemoteDataSource implements RemoteConfigRemoteDataSource {
  const FakeRemoteConfigRemoteDataSource();

  @override
  Future<RemoteConfigDto> fetch() async => const RemoteConfigDto();
}
