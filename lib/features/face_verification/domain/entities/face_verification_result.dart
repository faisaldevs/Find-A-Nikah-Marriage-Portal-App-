import 'package:equatable/equatable.dart';

/// `POST /profile/face-verification`'s outcome, mapped leniently from the
/// raw response by `FaceVerificationResponseMapper` (data layer) since the
/// backend contract isn't final.
///
/// `TODO(api)`: confirm which status codes/fields distinguish these cases.
sealed class FaceVerificationResult extends Equatable {
  const FaceVerificationResult();

  /// The server matched the selfie steps to the profile photo immediately.
  const factory FaceVerificationResult.verified() = Verified;

  /// The match runs asynchronously; the profile is "under review" until
  /// the server pushes a verdict.
  const factory FaceVerificationResult.underReview() = UnderReview;

  /// The server rejected the submission (match failed, poor quality, …).
  const factory FaceVerificationResult.rejected({
    String? reason,
    bool canRetry,
  }) = Rejected;
}

final class Verified extends FaceVerificationResult {
  const Verified();

  @override
  List<Object?> get props => [];
}

final class UnderReview extends FaceVerificationResult {
  const UnderReview();

  @override
  List<Object?> get props => [];
}

final class Rejected extends FaceVerificationResult {
  const Rejected({this.reason, this.canRetry = true});

  final String? reason;
  final bool canRetry;

  @override
  List<Object?> get props => [reason, canRetry];
}
