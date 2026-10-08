import 'package:find_a_nikah/core/core.dart';
import 'package:find_a_nikah/features/remote_config/data/datasources/remote_config_remote_data_source.dart';
import 'package:find_a_nikah/features/remote_config/data/dtos/remote_config_dto.dart';
import 'package:find_a_nikah/features/remote_config/domain/entities/remote_config.dart';
import 'package:find_a_nikah/features/remote_config/domain/repositories/remote_config_repository.dart';

class RemoteConfigRepositoryImpl implements RemoteConfigRepository {
  RemoteConfigRepositoryImpl(this._remote, this._guard);

  final RemoteConfigRemoteDataSource _remote;
  final Guard _guard;
  RemoteConfig? _last;

  @override
  RemoteConfig get current => _last ?? const RemoteConfig();

  @override
  Future<Either<Failure, RemoteConfig>> fetch() async {
    final result = await _guard(() async => (await _remote.fetch()).toEntity());
    return result.fold(
      (failure) => _last == null ? left(failure) : right(_last!),
      (config) {
        _last = config;
        return right(config);
      },
    );
  }
}
