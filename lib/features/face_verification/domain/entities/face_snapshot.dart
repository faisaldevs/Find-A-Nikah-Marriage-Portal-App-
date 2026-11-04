import 'package:equatable/equatable.dart';
import 'package:find_a_nikah/core/core.dart';

/// One analysed camera frame, already rotation-corrected and reduced to the
/// primitives the pose evaluator needs — no `Rect`/`Size`, so this stays
/// usable from pure-Dart domain code.
class FaceSnapshot extends Equatable {
  const FaceSnapshot({
    required this.faceCount,
    this.yaw,
    this.pitch,
    this.roll,
    this.leftEyeOpenProbability,
    this.rightEyeOpenProbability,
    this.boxWidthRatio,
    this.boxCenterOffsetRatio,
  });

  final int faceCount;

  /// `headEulerAngleY` — left/right turn. Null when ML Kit couldn't tell.
  final double? yaw;

  /// `headEulerAngleX` — up/down tilt.
  final double? pitch;

  /// `headEulerAngleZ` — in-plane tilt (unused by pose checks today, kept
  /// for the debug overlay).
  final double? roll;

  final double? leftEyeOpenProbability;
  final double? rightEyeOpenProbability;

  /// Face bounding-box width ÷ frame width — stands in for distance.
  final double? boxWidthRatio;

  /// Face box center offset from the frame center ÷ frame width —
  /// 0 is perfectly centered.
  final double? boxCenterOffsetRatio;

  FaceSnapshot copyWith({
    int? faceCount,
    Object? yaw = unchanged,
    Object? pitch = unchanged,
    Object? roll = unchanged,
    Object? leftEyeOpenProbability = unchanged,
    Object? rightEyeOpenProbability = unchanged,
    Object? boxWidthRatio = unchanged,
    Object? boxCenterOffsetRatio = unchanged,
  }) {
    return FaceSnapshot(
      faceCount: faceCount ?? this.faceCount,
      yaw: identical(yaw, unchanged) ? this.yaw : (yaw as num?)?.toDouble(),
      pitch: identical(pitch, unchanged)
          ? this.pitch
          : (pitch as num?)?.toDouble(),
      roll: identical(roll, unchanged) ? this.roll : (roll as num?)?.toDouble(),
      leftEyeOpenProbability: identical(leftEyeOpenProbability, unchanged)
          ? this.leftEyeOpenProbability
          : (leftEyeOpenProbability as num?)?.toDouble(),
      rightEyeOpenProbability: identical(rightEyeOpenProbability, unchanged)
          ? this.rightEyeOpenProbability
          : (rightEyeOpenProbability as num?)?.toDouble(),
      boxWidthRatio: identical(boxWidthRatio, unchanged)
          ? this.boxWidthRatio
          : (boxWidthRatio as num?)?.toDouble(),
      boxCenterOffsetRatio: identical(boxCenterOffsetRatio, unchanged)
          ? this.boxCenterOffsetRatio
          : (boxCenterOffsetRatio as num?)?.toDouble(),
    );
  }

  @override
  List<Object?> get props => [
    faceCount,
    yaw,
    pitch,
    roll,
    leftEyeOpenProbability,
    rightEyeOpenProbability,
    boxWidthRatio,
    boxCenterOffsetRatio,
  ];
}
