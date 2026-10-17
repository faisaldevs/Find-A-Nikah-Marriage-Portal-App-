import 'package:freezed_annotation/freezed_annotation.dart';

part 'face_snapshot.freezed.dart';

/// One analysed camera frame, already rotation-corrected and reduced to the
/// primitives the pose evaluator needs — no `Rect`/`Size`, so this stays
/// usable from pure-Dart domain code.
@freezed
abstract class FaceSnapshot with _$FaceSnapshot {
  const factory FaceSnapshot({
    required int faceCount,

    /// `headEulerAngleY` — left/right turn. Null when ML Kit couldn't tell.
    double? yaw,

    /// `headEulerAngleX` — up/down tilt.
    double? pitch,

    /// `headEulerAngleZ` — in-plane tilt (unused by pose checks today, kept
    /// for the debug overlay).
    double? roll,
    double? leftEyeOpenProbability,
    double? rightEyeOpenProbability,

    /// Face bounding-box width ÷ frame width — stands in for distance.
    double? boxWidthRatio,

    /// Face box center offset from the frame center ÷ frame width —
    /// 0 is perfectly centered.
    double? boxCenterOffsetRatio,
  }) = _FaceSnapshot;
}
