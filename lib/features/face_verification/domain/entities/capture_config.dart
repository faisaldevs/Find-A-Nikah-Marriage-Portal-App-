/// Tunables for the guided photo capture (`LivenessCaptureBloc`). Loose on
/// purpose: the app only collects clear photos per pose — the backend does
/// the actual verification.
class CaptureConfig {
  const CaptureConfig({
    this.frontYawMax = 15,
    this.frontPitchMax = 15,
    this.turnYawMin = 15,
    this.idealTurnYaw = 30,
    this.stepTimeout = const Duration(seconds: 5),
    this.burstCount = 3,
    this.yawSign = 1,
  });

  /// Live gate for "front": head within these angles.
  final double frontYawMax;
  final double frontPitchMax;

  /// Live gate for "left"/"right": head turned at least this far.
  final double turnYawMin;

  /// Best-shot scoring prefers side photos turned about this far — enough
  /// to show a clear profile, not so far the face is lost.
  final double idealTurnYaw;

  /// Pose not reached in this long → take the burst anyway (best attempt).
  final Duration stepTimeout;

  /// Photos taken per pose; the best one is kept.
  final int burstCount;

  /// +1 / -1: which `headEulerAngleY` sign means the user's own LEFT on
  /// the live stream. `TODO(device)`: confirm on a real Android and a real
  /// iPhone front camera.
  final int yawSign;

  static const standard = CaptureConfig();
}
