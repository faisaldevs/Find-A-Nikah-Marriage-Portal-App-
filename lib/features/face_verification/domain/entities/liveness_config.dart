import 'package:freezed_annotation/freezed_annotation.dart';

part 'liveness_config.freezed.dart';

/// Tunable thresholds for the liveness pose evaluator. Starting values
/// from the spec — tune on real devices once hardware is available;
/// [yawSign] in particular must be verified on a real Android *and* a
/// real iPhone front camera, since ML Kit's `headEulerAngleY` sign
/// relative to the user's own left/right can differ with front-camera
/// mirroring per platform.
@freezed
abstract class LivenessConfig with _$LivenessConfig {
  const factory LivenessConfig({
    @Default(0.35) double minFaceRatio,
    @Default(0.70) double maxFaceRatio,
    @Default(0.15) double maxCenterOffset,
    @Default(10.0) double frontYawMax,
    @Default(12.0) double frontPitchMax,
    @Default(25.0) double turnYawMin,
    @Default(0.5) double eyeOpenMin,
    @Default(Duration(milliseconds: 600)) Duration holdDuration,
    @Default(Duration(seconds: 15)) Duration stepTimeout,

    /// +1 or -1. Flips which physical turn direction `headEulerAngleY`'s
    /// sign maps to `LivenessPose.left`/`LivenessPose.right`.
    @Default(1) int yawSign,
  }) = _LivenessConfig;

  const LivenessConfig._();

  static const standard = LivenessConfig();
}
