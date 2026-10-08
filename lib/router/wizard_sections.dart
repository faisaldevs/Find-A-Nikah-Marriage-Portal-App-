import 'package:find_a_nikah/core/ui/ui.dart';
import 'package:find_a_nikah/router/route_paths.dart';

/// The Profile part's 3 progress-bar sections (Account type → Bio), in flow
/// order. Single source of truth for the persistent wizard header — pages
/// don't pass title/step.
const WizardSections profileWizardSections = [
  // 1. Basics
  [
    (RoutePaths.accountType, 'Choose account type'),
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
    (RoutePaths.bio, 'Bio'),
  ],
];

/// The Verification part (after Bio): phone → photos → face verification,
/// under one persistent header + 3-segment progress bar. Its pages come
/// from three features (auth, onboarding, face_verification), which is why
/// the shell is assembled in the router.
///
/// Photos sit directly before face verification because the face check
/// compares the selfie against the main profile photo.
const WizardSections verificationSections = [
  // 1. Phone
  [
    (RoutePaths.phoneNumber, 'Phone number'),
    (RoutePaths.phoneCode, 'Phone verification'),
  ],
  // 2. Photos
  [(RoutePaths.addPhotos, 'Photos')],
  // 3. Face verification
  [
    (RoutePaths.scanYourFace, 'Scan your face'),
    (RoutePaths.startVerification, 'Start Verification'),
    (RoutePaths.photoVerification, 'Photo Verification'),
  ],
];
