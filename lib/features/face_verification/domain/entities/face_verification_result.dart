import 'package:freezed_annotation/freezed_annotation.dart';

part 'face_verification_result.freezed.dart';

/// `POST /profile/face-verification`'s outcome, mapped leniently from the
/// raw response by `FaceVerificationResponseMapper` (data layer) since the
/// backend contract isn't final.
///
/// `TODO(api)`: confirm which status codes/fields distinguish these cases.
@freezed
sealed class FaceVerificationResult with _$FaceVerificationResult {
  /// The server matched the selfie steps to the profile photo immediately.
  const factory FaceVerificationResult.verified() = Verified;

  /// The match runs asynchronously; the profile is "under review" until
  /// the server pushes a verdict.
  const factory FaceVerificationResult.underReview() = UnderReview;

  /// The server rejected the submission (match failed, poor quality, …).
  const factory FaceVerificationResult.rejected({
    String? reason,
    @Default(true) bool canRetry,
  }) = Rejected;
}
