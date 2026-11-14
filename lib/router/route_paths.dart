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

  /// Family flow only — "Who are you creating this profile for?"
  static const relationship = '/onboarding/relationship';
  static const basicInformation = '/onboarding/basic-information';
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

  /// Guided-liveness capture (`livenessEnabled`) — reached from
  /// [startVerification] instead of the old single-selfie capture.
  static const livenessCapture = '/verification/liveness';
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

  // Feed flow, pushed over the tabs (no bottom nav). Post and member pages
  // are opened **by id** (so links and notifications work); the object that
  // was tapped may travel as go_router `extra` to draw the page at once.
  static const feedPost = '/feed/post';
  static const feedProfile = '/feed/profile';

  /// The signed-in member's own Feed profile (opened from the Menu).
  static const feedMe = '/feed/me';
  static const feedCompose = '/feed/compose';
  static const feedPostPattern = '$feedPost/:postId';
  static const feedProfilePattern = '$feedProfile/:userId';

  /// The share-link spelling of a member (`/feed/u/:userId`); redirects to
  /// [feedProfilePattern].
  static const feedMemberLinkPattern = '/feed/u/:userId';
  static const feedProfileSearchPattern = '$feedProfile/:userId/search';

  static String feedPostPath(String postId) => '$feedPost/$postId';
  static String feedProfilePath(String userId) => '$feedProfile/$userId';
  static String feedProfileSearchPath(String userId) =>
      '$feedProfile/$userId/search';

  /// True for any signed-in app location, including the id-based Feed pages
  /// (which are not in [app] because their path carries an id).
  /// A shared Feed link (post, member) — remembered across splash / login so
  /// a cold start still lands on it.
  static bool isFeedLink(String location) =>
      location.startsWith('$feedPost/') ||
      location.startsWith('/feed/u/') ||
      (location.startsWith('$feedProfile/') && !location.endsWith('/search'));

  static bool isAppLocation(String location) =>
      app.contains(location) ||
      location.startsWith('$feedPost/') ||
      location.startsWith('/feed/u/') ||
      location == feedMe ||
      location.startsWith('$feedProfile/');

  /// Inside the Chat tab (bottom nav stays).
  static const chatUnmatched = '/chat/unmatched';

  /// Menu flow. Help sits inside the Menu tab (bottom nav stays); Settings
  /// and Edit profile are pushed over the tabs (no bottom nav), per Figma.
  static const menuHelp = '/menu/help';
  static const settings = '/settings';
  static const editProfile = '/profile/edit';

  /// One Edit profile field (which one travels as `extra`). A fixed path,
  /// because the redirect only allows exact app paths.
  static const editProfileField = '/profile/edit/field';

  /// Over the tabs (no bottom nav).
  static const chatArchived = '/chat/archived';

  /// A chat peer's profile (`ChatPeer` as `extra`), over the tabs.
  static const peerProfile = '/chat/profile';

  /// Settings → Profiles I've blocked, over the tabs.
  static const blockedProfiles = '/settings/blocked';

  /// One conversation, over the tabs (no bottom nav). The peer
  /// (`ChatPeer`) travels as go_router `extra`.
  static const chatRoom = '/chat/room';

  /// A voice call, over everything; the peer (`ChatPeer`) as `extra`.
  static const call = '/call';

  /// Dev only: the same call screen, ringing as an incoming call.
  static const incomingCall = '/call/incoming';

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
    livenessCapture,
    photoVerification,
  };

  static const Set<String> onboarding = {
    getStarted,
    accountType,
    relationship,
    basicInformation,
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
    // Filters are opened from Marriage only (app routes below).
    // addFilters,
    // locationFilter,
  };

  static const Set<String> app = {
    marriage,
    explore,
    feed,
    chat,
    menu,
    addFilters,
    locationFilter,
    feedCompose,
    chatUnmatched,
    chatArchived,
    peerProfile,
    blockedProfiles,
    chatRoom,
    call,
    incomingCall,
    menuHelp,
    settings,
    editProfile,
    editProfileField,
  };
}
