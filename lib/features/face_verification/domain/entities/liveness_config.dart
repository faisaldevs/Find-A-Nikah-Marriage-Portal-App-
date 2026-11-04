import 'package:equatable/equatable.dart';

/// Tunable thresholds for the liveness pose evaluator. Starting values
/// from the spec — tune on real devices once hardware is available;
/// [yawSign] in particular must be verified on a real Android *and* a
/// real iPhone front camera, since ML Kit's `headEulerAngleY` sign
/// relative to the user's own left/right can differ with front-camera
/// mirroring per platform.
class LivenessConfig extends Equatable {
  const LivenessConfig({
    this.minFaceRatio = 0.35,
    this.maxFaceRatio = 0.70,
    this.maxCenterOffset = 0.15,
    this.frontYawMax = 10.0,
    this.frontPitchMax = 12.0,
    this.turnYawMin = 25.0,
    this.eyeOpenMin = 0.5,
    this.holdDuration = const Duration(milliseconds: 600),
    this.stepTimeout = const Duration(seconds: 15),
    this.yawSign = 1,
  });

  final double minFaceRatio;
  final double maxFaceRatio;
  final double maxCenterOffset;
  final double frontYawMax;
  final double frontPitchMax;
  final double turnYawMin;
  final double eyeOpenMin;
  final Duration holdDuration;
  final Duration stepTimeout;

  /// +1 or -1. Flips which physical turn direction `headEulerAngleY`'s
  /// sign maps to `LivenessPose.left`/`LivenessPose.right`.
  final int yawSign;

  static const standard = LivenessConfig();

  LivenessConfig copyWith({
    double? minFaceRatio,
    double? maxFaceRatio,
    double? maxCenterOffset,
    double? frontYawMax,
    double? frontPitchMax,
    double? turnYawMin,
    double? eyeOpenMin,
    Duration? holdDuration,
    Duration? stepTimeout,
    int? yawSign,
  }) {
    return LivenessConfig(
      minFaceRatio: minFaceRatio ?? this.minFaceRatio,
      maxFaceRatio: maxFaceRatio ?? this.maxFaceRatio,
      maxCenterOffset: maxCenterOffset ?? this.maxCenterOffset,
      frontYawMax: frontYawMax ?? this.frontYawMax,
      frontPitchMax: frontPitchMax ?? this.frontPitchMax,
      turnYawMin: turnYawMin ?? this.turnYawMin,
      eyeOpenMin: eyeOpenMin ?? this.eyeOpenMin,
      holdDuration: holdDuration ?? this.holdDuration,
      stepTimeout: stepTimeout ?? this.stepTimeout,
      yawSign: yawSign ?? this.yawSign,
    );
  }

  @override
  List<Object?> get props => [
    minFaceRatio,
    maxFaceRatio,
    maxCenterOffset,
    frontYawMax,
    frontPitchMax,
    turnYawMin,
    eyeOpenMin,
    holdDuration,
    stepTimeout,
    yawSign,
  ];
}
