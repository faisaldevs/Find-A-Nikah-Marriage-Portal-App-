import 'package:find_a_nikah/core/core.dart';
import 'package:dio/dio.dart';
import 'package:find_a_nikah/features/remote_config/data/data.dart';
import 'package:find_a_nikah/features/remote_config/data/dtos/remote_config_dto.dart';
import 'package:find_a_nikah/features/remote_config/domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/fakes.dart';

class _Remote implements RemoteConfigRemoteDataSource {
  RemoteConfigDto? next;

  @override
  Future<RemoteConfigDto> fetch() async {
    final value = next;
    if (value == null) {
      throw DioException.connectionTimeout(
        requestOptions: RequestOptions(path: '/config'),
        timeout: Duration.zero,
      );
    }
    return value;
  }
}

void main() {
  late _Remote remote;
  late RemoteConfigRepositoryImpl repo;

  setUp(() {
    remote = _Remote();
    repo = RemoteConfigRepositoryImpl(remote, testGuard());
  });

  test('first failure is returned; current stays at defaults', () async {
    final result = await repo.fetch();
    expect(result.getLeft().toNullable(), isA<TimeoutFailure>());
    expect(repo.current, const RemoteConfig());
  });

  test('success is cached and served when the next fetch fails', () async {
    remote.next = const RemoteConfigDto(
      minimumSupportedVersion: '1.2.0',
      flags: {'realtime': true},
    );
    final ok = await repo.fetch();
    expect(ok.getRight().toNullable()!.isEnabled(FeatureFlag.realtime), isTrue);

    remote.next = null;
    final fallback = await repo.fetch();
    expect(fallback.getRight().toNullable(), repo.current);
    expect(repo.current.minimumSupportedVersion, '1.2.0');
  });

  test('DTO maps from JSON', () {
    final dto = RemoteConfigDto.fromJson({
      'minimumSupportedVersion': '2.0.0',
      'flags': {'faceVerification': false},
    });
    expect(dto.toEntity().isEnabled(FeatureFlag.faceVerification), isFalse);
  });
}
