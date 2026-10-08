import 'package:find_a_nikah/core/core.dart';
import 'package:find_a_nikah/features/onboarding/domain/entities/onboarding_data.dart';

/// The profile being built during onboarding. Session-scoped: dropped on
/// sign-out, so the next user starts from a blank draft.
abstract interface class OnboardingDraftRepository {
  /// Current draft first, then every change.
  Stream<OnboardingData> watchDraft();

  OnboardingData get current;

  /// Write policy: in-memory until the profile API exists, then online
  /// only on submit.
  Future<Either<Failure, Unit>> save(OnboardingData draft);
}
