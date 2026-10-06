import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/selfie_face_checker.dart';
import 'face_verification_state.dart';

/// Drives the 3-screen selfie verification flow:
/// "Scan your face" → "Start verification" → "Photo verification".
class FaceVerificationController extends Notifier<FaceVerificationState> {
  @override
  FaceVerificationState build() => const FaceVerificationState();

  /// Called from "Scan your face" once the user confirms the profile photo
  /// is theirs. Resets any previous selfie attempt.
  void begin(String? profilePhotoPath) {
    state = FaceVerificationState(profilePhotoPath: profilePhotoPath);
  }

  /// Runs the on-device ML Kit gate on a freshly captured selfie.
  Future<void> onSelfieCaptured(String path) async {
    state = state.copyWith(
      selfiePath: path,
      status: FaceVerificationStatus.checkingSelfie,
      errorMessage: null,
    );
    try {
      final result = await ref.read(selfieFaceCheckerProvider).check(path);
      if (result == SelfieCheckResult.ok) {
        state = state.copyWith(status: FaceVerificationStatus.selfieReady);
      } else {
        state = state.copyWith(
          selfiePath: null,
          status: FaceVerificationStatus.failed,
          errorMessage: result.message,
        );
      }
    } catch (e) {
      state = state.copyWith(
        selfiePath: null,
        status: FaceVerificationStatus.failed,
        errorMessage: "We couldn't check that photo. Please try again.",
      );
    }
  }

  /// Uploads selfie + profile photo for server-side matching.
  ///
  /// TODO(backend): POST both images to the verification endpoint via
  /// `DioClient` (add `face_verification/data/face_verification_repository.dart`
  /// at that point). The server — not the app — decides the match result;
  /// until then this resolves straight to [FaceVerificationStatus.underReview]
  /// so the UI flow can be exercised end-to-end.
  Future<void> submit() async {
    if (state.status != FaceVerificationStatus.selfieReady) return;
    state = state.copyWith(status: FaceVerificationStatus.submitting);
    await Future<void>.delayed(const Duration(milliseconds: 600));
    state = state.copyWith(status: FaceVerificationStatus.underReview);
  }

  /// Drops the captured selfie so the user can retake it.
  void retake() {
    state = state.copyWith(
      selfiePath: null,
      status: FaceVerificationStatus.idle,
      errorMessage: null,
    );
  }
}

final faceVerificationControllerProvider =
    NotifierProvider<FaceVerificationController, FaceVerificationState>(
      FaceVerificationController.new,
    );
