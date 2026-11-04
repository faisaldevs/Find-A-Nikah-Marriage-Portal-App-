import 'package:equatable/equatable.dart';
import 'package:find_a_nikah/core/core.dart';
import 'package:find_a_nikah/features/face_verification/domain/entities/liveness_step.dart';

/// `POST /profile/face-verification/start`'s outcome:
/// `data.sessionId`, `data.challenges` (→ [plan]) and
/// `data.expiresInSeconds` (→ [expiresAt]). [raw] keeps the full decoded
/// `data` object.
class FaceSession extends Equatable {
  const FaceSession({
    this.sessionId,
    this.plan = LivenessStepPlan.defaultPlan,
    this.expiresAt,
    this.raw = const <String, dynamic>{},
  });

  final String? sessionId;
  final LivenessStepPlan plan;

  /// When the server stops accepting uploads for this session. Null when
  /// the response didn't say — then the session never expires client-side.
  final DateTime? expiresAt;

  final Map<String, dynamic> raw;

  bool isExpiredAt(DateTime now) {
    final expiry = expiresAt;
    return expiry != null && !now.isBefore(expiry);
  }

  FaceSession copyWith({
    Object? sessionId = unchanged,
    LivenessStepPlan? plan,
    Object? expiresAt = unchanged,
    Map<String, dynamic>? raw,
  }) {
    return FaceSession(
      sessionId: identical(sessionId, unchanged)
          ? this.sessionId
          : sessionId as String?,
      plan: plan ?? this.plan,
      expiresAt: identical(expiresAt, unchanged)
          ? this.expiresAt
          : expiresAt as DateTime?,
      raw: raw ?? this.raw,
    );
  }

  @override
  List<Object?> get props => [
    sessionId,
    plan,
    expiresAt,
    raw,
  ];
}
