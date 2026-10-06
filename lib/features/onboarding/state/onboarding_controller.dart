import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'onboarding_data.dart';

/// Holds wizard answers as the user moves through the profile-info flow.
/// One generic [patch] method instead of ~20 named setters — every screen
/// just supplies its own copyWith call.
class OnboardingController extends Notifier<OnboardingData> {
  @override
  OnboardingData build() => const OnboardingData();

  void patch(OnboardingData Function(OnboardingData current) update) {
    state = update(state);
  }
}

final onboardingControllerProvider =
    NotifierProvider<OnboardingController, OnboardingData>(
      OnboardingController.new,
    );
