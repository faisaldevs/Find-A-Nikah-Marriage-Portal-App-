import 'package:find_a_nikah/core/ui/ui.dart';
import 'package:find_a_nikah/router/route_paths.dart';

/// The Profile part's 4 progress-bar sections (Account type → Bio), in flow
/// order. Single source of truth for the persistent wizard header — pages
/// don't pass title/step.
const WizardSections profileWizardSections = [
  // 1. Basics
  [
    (RoutePaths.accountType, 'Choose account type'),
    // Family flow only — skipped for individual.
    (RoutePaths.relationship, 'Relationship'),
    (RoutePaths.basicInformation, 'Basic Information'),
    (RoutePaths.intentions, 'About Find A Nikah'),
    (RoutePaths.howHeard, 'About Find A Nikah'),
    (RoutePaths.nationality, 'Nationality'),
    (RoutePaths.country, 'Country'),
    (RoutePaths.ethnicity, 'Ethnicity'),
    (RoutePaths.height, 'Height'),
  ],
  // 2. Background & faith
  [
    (RoutePaths.education, 'Education'),
    (RoutePaths.profession, 'Profession'),
    (RoutePaths.maritalStatus, 'Marital Status'),
    (RoutePaths.marriageTimeline, 'Marital Status'),
    (RoutePaths.faith, 'Faith'),
    (RoutePaths.religiousPractice, 'Religious practice'),
  ],
  // 3. Lifestyle & personality
  [
    (RoutePaths.lifestylePreferences, 'Lifestyle preferences'),
    (RoutePaths.aboutYou, 'About you'),
    (RoutePaths.personality, 'Personality'),
    (RoutePaths.interests, 'Interests'),
  ],
  // 4. Bio — its own backend step (7), separate from Lifestyle &
  // personality (6); matches `OnboardingSubmissionRepository.submitBio`.
  [(RoutePaths.bio, 'Bio')],
];

/// Phone verification (after Bio): its own `ShellRoute`, own persistent
/// header + progress bar, own bloc — a fully separate layer from photo +
/// face verification below, not just a different section of the same
/// shell. Once verified it's locked in: changing the number afterwards is
/// a Settings concern, and there's no `ShellRoute` boundary to cross back
/// into even if a user tried (the next layer's own back button is also
/// hidden via `RoutedWizardShell.hideBackFor` — see `routes.dart`).
const WizardSections phoneVerificationSections = [
  [
    (RoutePaths.phoneNumber, 'Phone number'),
    (RoutePaths.phoneCode, 'Phone verification'),
  ],
];

/// Photo + face verification (after phone): its own `ShellRoute` and
/// progress bar, started only once the phone layer above is done. One
/// section, not two: adding a photo immediately drives the face check
/// against it, so it's a single flow with multiple steps, from three
/// features (auth, onboarding, face_verification) — hence the shell being
/// assembled in the router.
const WizardSections photoFaceVerificationSections = [
  [
    (RoutePaths.addPhotos, 'Photos'),
    (RoutePaths.scanYourFace, 'Scan your face'),
    (RoutePaths.startVerification, 'Start Verification'),
    (RoutePaths.photoVerification, 'Photo Verification'),
  ],
];
