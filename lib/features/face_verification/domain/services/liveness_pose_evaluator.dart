import 'package:find_a_nikah/features/face_verification/domain/entities/face_snapshot.dart';
import 'package:find_a_nikah/features/face_verification/domain/entities/liveness_config.dart';
import 'package:find_a_nikah/features/face_verification/domain/entities/liveness_pose.dart';
import 'package:find_a_nikah/features/face_verification/domain/entities/pose_feedback.dart';

/// Pure pose-quality check for one camera frame against one target pose.
/// No Flutter/camera imports — trivially unit-testable, and keeps the
/// domain layer pure Dart per the architecture boundary test.
class LivenessPoseEvaluator {
  const LivenessPoseEvaluator([this._config = LivenessConfig.standard]);

  final LivenessConfig _config;

  /// First failing check wins; [PoseFeedback.ok] only when every check for
  /// [target] passes.
  PoseFeedback evaluate(FaceSnapshot snapshot, LivenessPose target) {
    if (snapshot.faceCount == 0) return PoseFeedback.noFace;
    if (snapshot.faceCount > 1) return PoseFeedback.multipleFaces;

    final ratio = snapshot.boxWidthRatio;
    if (ratio != null) {
      if (ratio < _config.minFaceRatio) return PoseFeedback.moveCloser;
      if (ratio > _config.maxFaceRatio) return PoseFeedback.moveBack;
    }

    final offset = snapshot.boxCenterOffsetRatio;
    if (offset != null && offset > _config.maxCenterOffset) {
      return PoseFeedback.centerFace;
    }

    final yaw = (snapshot.yaw ?? 0) * _config.yawSign;
    final pitch = snapshot.pitch?.abs() ?? 0;

    switch (target) {
      case LivenessPose.front:
        if (yaw.abs() > _config.frontYawMax || pitch > _config.frontPitchMax) {
          return PoseFeedback.lookStraight;
        }
        if (!_eyesOpen(snapshot)) return PoseFeedback.openEyes;
      case LivenessPose.left:
        if (yaw < _config.turnYawMin) return PoseFeedback.turnLeft;
      case LivenessPose.right:
        if (yaw > -_config.turnYawMin) return PoseFeedback.turnRight;
    }

    return PoseFeedback.ok;
  }

  bool _eyesOpen(FaceSnapshot snapshot) {
    final left = snapshot.leftEyeOpenProbability;
    final right = snapshot.rightEyeOpenProbability;
    // Null when classification couldn't run — don't block on a signal we
    // don't have (same call as SelfieFaceDetector's still-photo gate).
    if (left == null || right == null) return true;
    return left >= _config.eyeOpenMin || right >= _config.eyeOpenMin;
  }
}
