import 'package:find_a_nikah/features/face_verification/domain/entities/liveness_step.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'face_session.freezed.dart';

/// `POST /profile/face-verification/start`'s outcome:
/// `data.sessionId`, `data.challenges` (→ [plan]) and
/// `data.expiresInSeconds` (→ [expiresAt]). [raw] keeps the full decoded
/// `data` object.
@freezed
abstract class FaceSession with _$FaceSession {
  const factory FaceSession({
    String? sessionId,
    @Default(LivenessStepPlan.defaultPlan) LivenessStepPlan plan,

    /// When the server stops accepting uploads for this session. Null when
    /// the response didn't say — then the session never expires client-side.
    DateTime? expiresAt,
    @Default(<String, dynamic>{}) Map<String, dynamic> raw,
  }) = _FaceSession;

  const FaceSession._();

  bool isExpiredAt(DateTime now) {
    final expiry = expiresAt;
    return expiry != null && !now.isBefore(expiry);
  }
}
