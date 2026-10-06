import 'package:freezed_annotation/freezed_annotation.dart';

part 'face_verification_state.freezed.dart';

/// Where the user is in the selfie-verification flow.
enum FaceVerificationStatus {
  /// Nothing captured yet.
  idle,

  /// Selfie taken, ML Kit is checking it has exactly one usable face.
  checkingSelfie,

  /// Selfie passed the on-device face check — ready to submit.
  selfieReady,

  /// Selfie + profile photo are being uploaded for server-side matching.
  submitting,

  /// Backend accepted the submission; profile is pending review.
  underReview,

  /// On-device check or submission failed — see [FaceVerificationState.errorMessage].
  failed,
}

/// Provider state for `features/auth/face_verification`. Pure UI state, so
/// no JSON (de)serialisation is generated for it.
@freezed
abstract class FaceVerificationState with _$FaceVerificationState {
  const factory FaceVerificationState({
    /// Profile photo the user is confirming is theirs (from onboarding, or
    /// re-picked via "Change photo").
    String? profilePhotoPath,

    /// Front-camera selfie captured on the "Start verification" screen.
    /// Never shown on the public profile.
    String? selfiePath,
    @Default(FaceVerificationStatus.idle) FaceVerificationStatus status,
    String? errorMessage,
  }) = _FaceVerificationState;
}
