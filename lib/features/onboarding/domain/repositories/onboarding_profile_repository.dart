import 'package:find_a_nikah/core/core.dart';
import 'package:find_a_nikah/features/onboarding/domain/entities/onboarding_data.dart';

/// Reads back whatever sections have already been submitted (the read side
/// — `OnboardingSubmissionRepository` is the write side), so a resumed
/// wizard can prefill pages the user already answered instead of showing
/// them blank.
abstract interface class OnboardingProfileRepository {
  /// Maps the already-submitted sections onto a draft, gated by the
  /// backend's `currentStep` (a section's fields are only read once the
  /// user has moved past it) — null if nothing has been submitted yet.
  Future<Either<Failure, OnboardingData?>> fetchSubmittedDraft();
}
