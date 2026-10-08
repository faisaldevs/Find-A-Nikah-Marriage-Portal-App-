import 'package:find_a_nikah/core/core.dart';

abstract interface class AiBioRepository {
  Future<Either<Failure, String>> generateBio();
}
