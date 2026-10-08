/// Every URL in the app. Typed routes in `routes.dart` use these; the
/// redirect guard and the wizard shells group them.
abstract final class RoutePaths {
  // ── Public (signed out) ──────────────────────────────────────────────
  static const splash = '/splash';
  static const intro = '/onboarding/intro';
  static const welcome = '/welcome';
  static const login = '/login';
  static const signUpEmail = '/signup/email';
  static const signUpCode = '/signup/verification-code';
  static const createPassword = '/signup/create-password';

  // ── Onboarding (signed in, profile incomplete) ───────────────────────
  static const getStarted = '/get-started';

  // Profile wizard — order matches the reference mockups exactly.
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
  static const marriageTimeline = '/onboarding/marriage';
  static const faith = '/onboarding/faith';
  static const religiousPractice = '/onboarding/religious-practice';
  static const lifestylePreferences = '/onboarding/lifestyle-preferences';
  static const aboutYou = '/onboarding/about-you';
  static const personality = '/onboarding/personality';
  static const interests = '/onboarding/interests';
  static const bio = '/onboarding/bio';

  // Verification part: phone → photos → face.
  static const phoneNumber = '/onboarding/phone-number';
  static const phoneCode = '/onboarding/phone-verification-code';
  static const addPhotos = '/onboarding/photos';
  static const scanYourFace = '/verification/scan-your-face';
  static const startVerification = '/verification/start';
  static const photoVerification = '/verification/photo';

  /// Location step between face verification and Add filters.
  static const location = '/location';

  // ── Discovery filters (onboarding and app) ───────────────────────────
  static const addFilters = '/filters';
  static const locationFilter = '/filters/location';

  // ── App (signed in, onboarding complete) ─────────────────────────────
  static const marriage = '/marriage';
  static const explore = '/explore';
  static const feed = '/feed';
  static const chat = '/chat';
  static const menu = '/menu';

  /// Shown in place of everything while this build is too old.
  static const updateRequired = '/update-required';

  // ── Groups for the redirect guard ────────────────────────────────────
  static const Set<String> public = {
    splash,
    intro,
    welcome,
    login,
    signUpEmail,
    signUpCode,
    createPassword,
  };

  /// Public routes a just-registered user may still go back to.
  static const Set<String> signUpFlow = {
    welcome,
    login,
    signUpEmail,
    signUpCode,
    createPassword,
  };

  static const Set<String> faceVerification = {
    scanYourFace,
    startVerification,
    photoVerification,
  };

  static const Set<String> onboarding = {
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
    marriageTimeline,
    faith,
    religiousPractice,
    lifestylePreferences,
    aboutYou,
    personality,
    interests,
    bio,
    phoneNumber,
    phoneCode,
    addPhotos,
    ...faceVerification,
    location,
    addFilters,
    locationFilter,
  };

  static const Set<String> app = {
    marriage,
    explore,
    feed,
    chat,
    menu,
    addFilters,
    locationFilter,
  };
}
