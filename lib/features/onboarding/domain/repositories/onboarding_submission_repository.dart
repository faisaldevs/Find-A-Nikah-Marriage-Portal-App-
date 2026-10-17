import 'package:find_a_nikah/core/core.dart';
import 'package:find_a_nikah/features/onboarding/domain/entities/onboarding_data.dart';

/// Submits the profile wizard's sections to the backend, one PATCH per
/// section boundary (steps 4-8). Separate from `OnboardingDraftRepository`,
/// which only keeps the local draft — this is the online-only write side
/// now that the profile API exists.
abstract interface class OnboardingSubmissionRepository {
  /// Step 4 — Basics.
  Future<Either<Failure, Unit>> submitBasics(OnboardingData draft);

  /// Step 5 — Background & faith.
  Future<Either<Failure, Unit>> submitBackgroundFaith(OnboardingData draft);

  /// Step 6 — Lifestyle & personality (everything but bio).
  Future<Either<Failure, Unit>> submitLifestylePersonality(
    OnboardingData draft,
  );

  /// Step 7 — Bio.
  Future<Either<Failure, Unit>> submitBio(OnboardingData draft);

  /// Step 8 — Photos: uploads every file in [OnboardingData.photoPaths]
  /// (already compressed when picked), in order — the first is the main
  /// photo.
  Future<Either<Failure, Unit>> submitPhotos(OnboardingData draft);

  /// Deletes an already-uploaded photo ([url] as prefilled into the draft).
  Future<Either<Failure, Unit>> deleteUploadedPhoto(String url);
}
