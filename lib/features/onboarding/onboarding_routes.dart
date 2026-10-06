import 'package:go_router/go_router.dart';

import '../../core/ui/components/wizard_shell.dart';
import 'profile/presentation/widgets/onboarding_wizard_shell.dart';

import 'profile/presentation/screens/lifestyle_personality/about_you_screen.dart';
import 'profile/presentation/screens/basics/account_type_screen.dart';
import 'verification/presentation/screens/add_photos_screen.dart';
import 'profile/presentation/screens/lifestyle_personality/bio_screen.dart';
import 'profile/presentation/screens/basics/country_screen.dart';
import 'signup/presentation/screens/create_password_screen.dart';
import 'profile/presentation/screens/background_faith/education_screen.dart';
import 'signup/presentation/screens/email_address_screen.dart';
import 'profile/presentation/screens/basics/ethnicity_screen.dart';
import 'profile/presentation/screens/background_faith/faith_screen.dart';
import 'signup/presentation/screens/get_started_screen.dart';
import 'profile/presentation/screens/basics/height_screen.dart';
import 'profile/presentation/screens/basics/how_heard_screen.dart';
import 'profile/presentation/screens/basics/intentions_screen.dart';
import 'profile/presentation/screens/lifestyle_personality/interests_screen.dart';
import 'profile/presentation/screens/lifestyle_personality/lifestyle_preferences_screen.dart';
import 'entry/presentation/screens/login_screen.dart';
import 'profile/presentation/screens/background_faith/marital_status_screen.dart';
import 'profile/presentation/screens/background_faith/marriage_screen.dart';
import 'profile/presentation/screens/basics/nationality_screen.dart';
import 'entry/presentation/screens/onboarding_intro_screen.dart';
import 'profile/presentation/screens/lifestyle_personality/personality_screen.dart';
import 'verification/presentation/screens/phone_number_screen.dart';
import 'verification/presentation/screens/phone_verification_code_screen.dart';
import 'profile/presentation/screens/background_faith/profession_screen.dart';
import 'profile/presentation/screens/background_faith/religious_practice_screen.dart';
import 'entry/presentation/screens/splash_screen.dart';
import 'signup/presentation/screens/verification_code_screen.dart';
import 'entry/presentation/screens/welcome_screen.dart';

/// Path constants + route table for the pre-app flow: splash through
/// sign-up and the profile-info wizard. Kept separate from
/// `core/router/app_router.dart` so that file doesn't balloon — merged in
/// there via `OnboardingRoutes.routes`.
class OnboardingRoutes {
  OnboardingRoutes._();

  static const splash = '/splash';
  static const introCarousel = '/onboarding/intro';
  static const login = '/login';
  static const welcome = '/welcome';
  static const emailAddress = '/signup/email';
  static const verificationCode = '/signup/verification-code';
  static const createPassword = '/signup/create-password';
  static const getStarted = '/get-started';

  // Profile-info wizard — order matches the reference mockups exactly.
  static const accountType = '/onboarding/account-type';
  static const intentions = '/onboarding/intentions';
  static const howHeard = '/onboarding/how-heard';
  static const nationality = '/onboarding/nationality';
  static const country = '/onboarding/country';
  static const ethnicity = '/onboarding/ethnicity';
  static const height = '/onboarding/height';
  static const education = '/onboarding/education';
  static const profession = '/onboarding/profession';
  static const maritalStatus = '/onboarding/marital-status';
  static const marriage = '/onboarding/marriage';
  static const faith = '/onboarding/faith';
  static const religiousPractice = '/onboarding/religious-practice';
  static const lifestylePreferences = '/onboarding/lifestyle-preferences';
  static const aboutYou = '/onboarding/about-you';
  static const personality = '/onboarding/personality';
  static const interests = '/onboarding/interests';
  static const bio = '/onboarding/bio';
  static const addPhotos = '/onboarding/photos';
  static const phoneNumber = '/onboarding/phone-number';
  static const phoneVerificationCode = '/onboarding/phone-verification-code';

  /// Every path in this flow — used by the app router's redirect guard to
  /// treat all of these as "public" (no auth required to view them).
  static const List<String> all = [
    splash,
    introCarousel,
    login,
    welcome,
    emailAddress,
    verificationCode,
    createPassword,
    getStarted,
    accountType,
    intentions,
    howHeard,
    nationality,
    country,
    ethnicity,
    height,
    education,
    profession,
    maritalStatus,
    marriage,
    faith,
    religiousPractice,
    lifestylePreferences,
    aboutYou,
    personality,
    interests,
    bio,
    addPhotos,
    phoneNumber,
    phoneVerificationCode,
  ];

  /// The Profile part's 3 progress-bar sections (Account type → Bio), in
  /// flow order. Single source of truth for the persistent
  /// [OnboardingWizardShell] header — screens no longer pass title/step.
  /// Photos / phone / OTP belong to the Verification part — see
  /// [verificationRoutes] and `core/router/verification_routes.dart`.
  static const WizardSections wizardSections = [
    // 1. Basics
    [
      (accountType, 'Choose account type'),
      (intentions, 'About Find A Nikah'),
      (howHeard, 'About Find A Nikah'),
      (nationality, 'Nationality'),
      (country, 'Country'),
      (ethnicity, 'Ethnicity'),
      (height, 'Height'),
    ],
    // 2. Background & faith
    [
      (education, 'Education'),
      (profession, 'Profession'),
      (maritalStatus, 'Marital Status'),
      (marriage, 'Marital Status'),
      (faith, 'Faith'),
      (religiousPractice, 'Religious practice'),
    ],
    // 3. Lifestyle & personality
    [
      (lifestylePreferences, 'Lifestyle preferences'),
      (aboutYou, 'About you'),
      (personality, 'Personality'),
      (interests, 'Interests'),
      (bio, 'Bio'),
    ],
    // 4. Photos & contact — moved to the separate Verification part.
    // [
    //   (addPhotos, 'Photos'),
    //   (phoneNumber, 'Phone number'),
    //   (phoneVerificationCode, 'Phone verification'),
    // ],
  ];

  /// Header title + progress for a wizard [path], or null if [path] isn't
  /// one of the wizard steps.
  static WizardProgress? wizardProgressFor(String path) =>
      WizardProgress.forPath(wizardSections, path);
  // Previous inline lookup — now shared via WizardProgress.forPath.
  // static WizardProgress? wizardProgressFor(String path) {
  //   for (var s = 0; s < wizardSections.length; s++) {
  //     final section = wizardSections[s];
  //     for (var i = 0; i < section.length; i++) {
  //       if (section[i].$1 == path) {
  //         return WizardProgress(
  //           title: section[i].$2,
  //           section: s,
  //           step: i + 1,
  //           sectionLength: section.length,
  //         );
  //       }
  //     }
  //   }
  //   return null;
  // }

  static List<RouteBase> routes = [
    GoRoute(path: splash, builder: (_, _) => const SplashScreen()),
    GoRoute(
      path: introCarousel,
      builder: (_, _) => const OnboardingIntroScreen(),
    ),
    GoRoute(path: login, builder: (_, _) => const LoginScreen()),
    GoRoute(path: welcome, builder: (_, _) => const WelcomeScreen()),
    GoRoute(path: emailAddress, builder: (_, _) => const EmailAddressScreen()),
    GoRoute(
      path: verificationCode,
      builder: (_, _) => const VerificationCodeScreen(),
    ),
    GoRoute(
      path: createPassword,
      builder: (_, _) => const CreatePasswordScreen(),
    ),
    GoRoute(path: getStarted, builder: (_, _) => const GetStartedScreen()),
    // Profile-info wizard: one persistent header + progress bar; only the
    // page body below it transitions between these routes.
    ShellRoute(
      builder: (_, _, child) => OnboardingWizardShell(child: child),
      routes: [
        GoRoute(
          path: accountType,
          builder: (_, _) => const AccountTypeScreen(),
        ),
        GoRoute(path: intentions, builder: (_, _) => const IntentionsScreen()),
        GoRoute(path: howHeard, builder: (_, _) => const HowHeardScreen()),
        GoRoute(
          path: nationality,
          builder: (_, _) => const NationalityScreen(),
        ),
        GoRoute(path: country, builder: (_, _) => const CountryScreen()),
        GoRoute(path: ethnicity, builder: (_, _) => const EthnicityScreen()),
        GoRoute(path: height, builder: (_, _) => const HeightScreen()),
        GoRoute(path: education, builder: (_, _) => const EducationScreen()),
        GoRoute(path: profession, builder: (_, _) => const ProfessionScreen()),
        GoRoute(
          path: maritalStatus,
          builder: (_, _) => const MaritalStatusScreen(),
        ),
        GoRoute(path: marriage, builder: (_, _) => const MarriageScreen()),
        GoRoute(path: faith, builder: (_, _) => const FaithScreen()),
        GoRoute(
          path: religiousPractice,
          builder: (_, _) => const ReligiousPracticeScreen(),
        ),
        GoRoute(
          path: lifestylePreferences,
          builder: (_, _) => const LifestylePreferencesScreen(),
        ),
        GoRoute(path: aboutYou, builder: (_, _) => const AboutYouScreen()),
        GoRoute(
          path: personality,
          builder: (_, _) => const PersonalityScreen(),
        ),
        GoRoute(path: interests, builder: (_, _) => const InterestsScreen()),
        GoRoute(path: bio, builder: (_, _) => const BioScreen()),
        // Photos / phone / OTP moved to [verificationRoutes].
      ],
    ),
  ];

  /// Onboarding's steps of the Verification part. Not registered here —
  /// `core/router/verification_routes.dart` puts them in one ShellRoute
  /// with the face-verification routes from `features/auth` (features
  /// can't import each other, so the shared shell lives in core/router).
  static List<GoRoute> verificationRoutes = [
    GoRoute(path: phoneNumber, builder: (_, _) => const PhoneNumberScreen()),
    GoRoute(
      path: phoneVerificationCode,
      builder: (_, _) => const PhoneVerificationCodeScreen(),
    ),
    GoRoute(path: addPhotos, builder: (_, _) => const AddPhotosScreen()),
  ];
}
