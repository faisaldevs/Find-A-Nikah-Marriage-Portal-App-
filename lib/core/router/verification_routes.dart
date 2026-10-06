import 'package:go_router/go_router.dart';

import '../../features/auth/auth_routes.dart';
import '../../features/onboarding/onboarding_routes.dart';
import '../ui/components/wizard_shell.dart';

/// The Verification part of sign-up (after the Profile part ends at Bio):
/// phone → photos → face verification, under one persistent header +
/// 3-segment progress bar.
///
/// Its steps come from two features (onboarding owns phone/photos, auth
/// owns face verification). Features can't import each other, so the
/// shared shell is assembled here — `core/router/` is the one place allowed
/// to see every feature's route table.
///
/// Photos sit directly before face verification because the face check
/// compares the selfie against the main profile photo.
const WizardSections verificationSections = [
  // 1. Phone
  [
    (OnboardingRoutes.phoneNumber, 'Phone number'),
    (OnboardingRoutes.phoneVerificationCode, 'Phone verification'),
  ],
  // 2. Photos
  [(OnboardingRoutes.addPhotos, 'Photos')],
  // 3. Face verification
  [
    (AuthRoutes.scanYourFace, 'Scan your face'),
    (AuthRoutes.startVerification, 'Start Verification'),
    (AuthRoutes.photoVerification, 'Photo Verification'),
  ],
];

final verificationShellRoute = ShellRoute(
  builder: (_, _, child) =>
      RoutedWizardShell(sections: verificationSections, child: child),
  routes: [
    ...OnboardingRoutes.verificationRoutes,
    ...AuthRoutes.faceVerificationRoutes,
  ],
);
