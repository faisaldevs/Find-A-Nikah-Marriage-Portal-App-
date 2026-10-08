import 'package:find_a_nikah/core/core.dart';
import 'package:find_a_nikah/features/face_verification/domain/entities/selfie_check_result.dart';

/// Selfie verification: capture, on-device quality gate, server-side match.
abstract interface class FaceVerificationRepository {
  /// Front camera. Right(null) when the user cancels.
  Future<Either<Failure, String?>> captureSelfie();

  /// Gallery, for "Change photo". Right(null) when the user cancels.
  Future<Either<Failure, String?>> pickProfilePhoto();

  /// On-device ML Kit gate on the image at [path].
  Future<Either<Failure, SelfieCheckResult>> checkSelfie(String path);

  /// Uploads both images for server-side matching. Success means "under
  /// review" — the server, not the app, decides the match. Write policy:
  /// online only.
  Future<Either<Failure, Unit>> submit({
    required String profilePhotoPath,
    required String selfiePath,
  });
}
