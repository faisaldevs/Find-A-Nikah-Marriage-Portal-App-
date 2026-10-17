import 'package:dio/dio.dart';
import 'package:find_a_nikah/features/face_verification/domain/entities/face_session.dart';
import 'package:find_a_nikah/features/face_verification/domain/entities/face_verification_result.dart';
import 'package:find_a_nikah/features/face_verification/domain/entities/liveness_pose.dart';
import 'package:find_a_nikah/features/face_verification/domain/entities/liveness_step.dart';

/// Turns the raw `/profile/face-verification*` responses into domain
/// entities. Parsed leniently: an unexpected body never crashes, it falls
/// back to the safest reading.
class FaceVerificationResponseMapper {
  const FaceVerificationResponseMapper();

  /// `/start` → `{statusCode, data: {sessionId, challenges,
  /// expiresInSeconds}, message, success}`. [now] anchors `expiresAt`.
  FaceSession mapSession(Response<dynamic> response, {DateTime? now}) {
    final envelope = _asMap(response.data);
    // Unwrap the standard envelope; tolerate a bare body too.
    final body = envelope['data'] is Map<String, dynamic>
        ? envelope['data'] as Map<String, dynamic>
        : envelope;
    final sessionId = _string(body, const ['sessionId', 'session_id', 'id']);
    final expiresIn = body['expiresInSeconds'];
    return FaceSession(
      sessionId: sessionId,
      plan: _plan(body['challenges']),
      expiresAt: expiresIn is num && expiresIn > 0
          ? (now ?? DateTime.now()).add(
              Duration(milliseconds: (expiresIn * 1000).round()),
            )
          : null,
      raw: body,
    );
  }

  /// One step per recognised challenge, in server order. Unknown names are
  /// skipped (the app can't guide a pose it doesn't know); none recognised
  /// → [LivenessStepPlan.defaultPlan].
  LivenessStepPlan _plan(Object? challenges) {
    if (challenges is! List) return LivenessStepPlan.defaultPlan;
    final steps = [
      for (final c in challenges)
        if (c is String && _pose(c) != null)
          LivenessStep(fieldName: c, pose: _pose(c)!),
    ];
    return steps.isEmpty
        ? LivenessStepPlan.defaultPlan
        : LivenessStepPlan(steps: steps);
  }

  LivenessPose? _pose(String challenge) => switch (challenge.toLowerCase()) {
    'front' => LivenessPose.front,
    'left' => LivenessPose.left,
    'right' => LivenessPose.right,
    _ => null,
  };

  /// `POST /v1/profile/face-verification`, confirmed against the backend:
  /// - 200 `{data: {isFaceVerified: true, verification: {status:
  ///   "approved", rejectionReason: null}, distance, steps}}` → verified.
  /// - 4xx (e.g. 422 `{message: "Step 1 (front): no face detected. …"}`)
  ///   → rejected with the backend's message; the user can retry.
  /// - `verification.status` "pending"/"under_review" → under review (not
  ///   seen yet; handled so an async backend doesn't read as a failure).
  FaceVerificationResult mapResult(Response<dynamic> response) {
    final body = _asMap(response.data);
    final statusCode = response.statusCode ?? 0;

    if (statusCode >= 400) {
      return FaceVerificationResult.rejected(
        reason: _string(body, const ['message', 'reason', 'error']),
        canRetry: _bool(body, const ['canRetry', 'can_retry']) ?? true,
      );
    }

    final data = _asMap(body['data']);
    final verification = _asMap(data['verification']);
    final status = _string(verification, const ['status'])?.toLowerCase();

    if (data['isFaceVerified'] == true || status == 'approved') {
      return const FaceVerificationResult.verified();
    }
    if (status == 'rejected' || data['isFaceVerified'] == false) {
      return FaceVerificationResult.rejected(
        reason:
            _string(verification, const ['rejectionReason']) ??
            _string(body, const ['message']),
      );
    }
    // Pending / unrecognized 2xx: never a false "verified".
    return const FaceVerificationResult.underReview();
  }

  // Before the contract was confirmed — every 2xx counted as verified:
  // /// `TODO(api)`: the verify endpoint's response isn't specified yet, so
  // /// every successful upload counts as [FaceVerificationResult.verified]
  // /// for now (dev placeholder so the rest of the flow can be built).
  // /// Network/server errors still surface as failures — Dio throws on
  // /// non-2xx before this runs. Restore the lenient parsing below once the
  // /// contract is known (and give the call a `validateStatus` that lets the
  // /// 4xx rejection body through, or map it from the `DioException`).
  // FaceVerificationResult mapResult(Response<dynamic> response) {
  //   return const FaceVerificationResult.verified();
  // }

  // Earlier guess-based lenient parser (superseded by the confirmed
  // contract above):
  /*
  FaceVerificationResult mapResult(Response<dynamic> response) {
    final body = _asMap(response.data);
    final statusCode = response.statusCode ?? 0;

    if (statusCode >= 400) {
      return FaceVerificationResult.rejected(
        reason: _string(body, const ['reason', 'message', 'error']),
        canRetry: _bool(body, const ['canRetry', 'can_retry']) ?? true,
      );
    }

    final status = _string(body, const ['status', 'verdict', 'result'])
        ?.toLowerCase();
    if (status != null) {
      if (status.contains('reject') || status.contains('fail')) {
        return FaceVerificationResult.rejected(
          reason: _string(body, const ['reason', 'message']),
          canRetry: _bool(body, const ['canRetry', 'can_retry']) ?? true,
        );
      }
      if (status.contains('verif') || status.contains('approv')) {
        return const FaceVerificationResult.verified();
      }
    }

    // 202, or a 2xx body we don't recognize: the safe default is "the
    // server is still deciding", never a false positive verdict.
    return const FaceVerificationResult.underReview();
  }
  */

  Map<String, dynamic> _asMap(Object? data) =>
      data is Map<String, dynamic> ? data : const {};

  String? _string(Map<String, dynamic> body, List<String> keys) {
    for (final key in keys) {
      final value = body[key];
      if (value is String && value.isNotEmpty) return value;
    }
    return null;
  }

  bool? _bool(Map<String, dynamic> body, List<String> keys) {
    for (final key in keys) {
      final value = body[key];
      if (value is bool) return value;
    }
    return null;
  }
}
