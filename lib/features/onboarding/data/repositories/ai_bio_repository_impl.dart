import 'package:find_a_nikah/core/core.dart';
import 'package:find_a_nikah/features/onboarding/data/datasources/ai_bio_remote_data_source.dart';
import 'package:find_a_nikah/features/onboarding/domain/repositories/ai_bio_repository.dart';

class AiBioRepositoryImpl implements AiBioRepository {
  const AiBioRepositoryImpl(this._remote, this._guard);

  final AiBioRemoteDataSource _remote;
  final Guard _guard;

  @override
  Future<Either<Failure, String>> generateBio() =>
      _guard(() async => (await _remote.generateBio()).data.bio);
}
