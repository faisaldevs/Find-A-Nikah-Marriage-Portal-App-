import 'package:find_a_nikah/core/core.dart';
import 'package:find_a_nikah/features/face_verification/domain/entities/camera_permission_status.dart';
import 'package:find_a_nikah/features/face_verification/domain/entities/face_session.dart';
import 'package:find_a_nikah/features/face_verification/domain/entities/face_snapshot.dart';
import 'package:find_a_nikah/features/face_verification/domain/entities/face_verification_result.dart';
import 'package:find_a_nikah/features/face_verification/domain/entities/liveness_pose.dart';
import 'package:find_a_nikah/features/face_verification/domain/entities/selfie_check_result.dart';

/// Selfie verification: capture, on-device quality gate, server-side match.
abstract interface class FaceVerificationRepository {
  /// Front camera. Right(null) when the user cancels.
  Future<Either<Failure, String?>> captureSelfie();

  /// Gallery, for "Change photo". Right(null) when the user cancels.
  Future<Either<Failure, String?>> pickProfilePhoto();

  /// On-device ML Kit gate on the image at [path]. [expectedPose] relaxes
  /// the yaw check for a guided-liveness turn step.
  Future<Either<Failure, SelfieCheckResult>> checkSelfie(
    String path, {
    LivenessPose expectedPose = LivenessPose.front,
  });

  /// Face metrics (count, pose, eyes) of the still at [path] — used to
  /// pick the best photo of a capture burst.
  Future<Either<Failure, FaceSnapshot>> analyzeStill(String path);

  /// Uploads both images for server-side matching. Success means "under
  /// review" — the server, not the app, decides the match. Write policy:
  /// online only.
  Future<Either<Failure, Unit>> submit({
    required String profilePhotoPath,
    required String selfiePath,
  });

  /// Requests camera access for the guided liveness capture.
  Future<Either<Failure, CameraPermissionStatus>> requestCameraPermission();

  /// Starts a guided-liveness session (`livenessEnabled` path).
  Future<Either<Failure, FaceSession>> startLivenessSession();

  /// Uploads the captured, compressed liveness steps (keyed by
  /// [FaceSession.plan]'s field names) for server-side matching.
  Future<Either<Failure, FaceVerificationResult>> submitLivenessSteps({
    required FaceSession session,
    required Map<String, String> stepFilePaths,
  });
}
