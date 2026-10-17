import 'package:find_a_nikah/features/face_verification/domain/entities/capture_config.dart';
import 'package:find_a_nikah/features/face_verification/domain/entities/face_snapshot.dart';
import 'package:find_a_nikah/features/face_verification/domain/entities/liveness_pose.dart';

/// Why a live frame doesn't count for the current pose yet.
enum PoseHint { noFace, multipleFaces, lookStraight, turnMore, ok }

/// Pure scoring for the guided photo capture — no Flutter/camera imports.
///
/// - [check]: live gate on stream frames (direction-aware, loose).
/// - [stillScore]: ranks the photos of a burst to keep the clearest one.
class PoseScorer {
  const PoseScorer([this._config = CaptureConfig.standard]);

  final CaptureConfig _config;

  PoseHint check(FaceSnapshot frame, LivenessPose target) {
    if (frame.faceCount == 0) return PoseHint.noFace;
    if (frame.faceCount > 1) return PoseHint.multipleFaces;
    // Positive = turned to the user's own left (see CaptureConfig.yawSign).
    final turn = (frame.yaw ?? 0) * _config.yawSign;
    final pitch = (frame.pitch ?? 0).abs();
    return switch (target) {
      LivenessPose.front =>
        turn.abs() <= _config.frontYawMax && pitch <= _config.frontPitchMax
            ? PoseHint.ok
            : PoseHint.lookStraight,
      LivenessPose.left =>
        turn >= _config.turnYawMin ? PoseHint.ok : PoseHint.turnMore,
      LivenessPose.right =>
        turn <= -_config.turnYawMin ? PoseHint.ok : PoseHint.turnMore,
    };
  }

  /// Higher is better; null when the photo is unusable (no face / several
  /// faces). Uses the turn's *magnitude*, not its sign: saved front-camera
  /// photos may be mirrored differently from the live stream per platform,
  /// and the live gate already confirmed the direction.
  double? stillScore(FaceSnapshot photo, LivenessPose target) {
    if (photo.faceCount != 1) return null;
    final yaw = (photo.yaw ?? 0).abs();
    final pitch = (photo.pitch ?? 0).abs();
    final eyes = _eyesOpen(photo);
    final pose = switch (target) {
      LivenessPose.front => -(yaw * 2 + pitch),
      LivenessPose.left ||
      LivenessPose.right => -((yaw - _config.idealTurnYaw).abs() * 1.5 + pitch),
    };
    return 100 + pose + eyes * 20;
  }

  /// 0..1; unknown (classification didn't run) counts as open.
  double _eyesOpen(FaceSnapshot photo) {
    final left = photo.leftEyeOpenProbability;
    final right = photo.rightEyeOpenProbability;
    if (left == null || right == null) return 1;
    return (left + right) / 2;
  }
}
