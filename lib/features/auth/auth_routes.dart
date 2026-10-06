import 'package:go_router/go_router.dart';

import 'face_verification/presentation/screens/photo_verification_screen.dart';
import 'face_verification/presentation/screens/scan_your_face_screen.dart';
import 'face_verification/presentation/screens/start_verification_screen.dart';
import 'location/presentation/screens/add_filters_screen.dart';
import 'location/presentation/screens/location_filter_screen.dart';

/// Path constants + route table for `features/auth`: the post-phone-OTP
/// steps (face verification → discovery filters) that sit between the
/// onboarding wizard and the app shell. Same shape as [OnboardingRoutes];
/// merged into the app router via `AuthRoutes.routes`.
class AuthRoutes {
  AuthRoutes._();

  // face_verification — order matches the reference mockups.
  static const scanYourFace = '/verification/scan-your-face';
  static const startVerification = '/verification/start';
  static const photoVerification = '/verification/photo';

  // location (discovery filters),
  /// Standalone step after Photo verification, before Add filters.
  static const location = '/location';
  static const addFilters = '/filters';
  static const locationFilter = '/filters/location';

  /// Public (pre-login) paths — the redirect guard treats these like
  /// onboarding since the user has no session yet at this point.
  static const List<String> all = [
    scanYourFace,
    startVerification,
    photoVerification,
    location,
    addFilters,
    locationFilter,
  ];

  /// Face-verification steps of the Verification part. Not registered in
  /// [routes] — `core/router/verification_routes.dart` puts them in one
  /// ShellRoute with onboarding's photos / phone / OTP steps.
  static List<GoRoute> faceVerificationRoutes = [
    GoRoute(
      path: scanYourFace,
      // `extra` carries the first onboarding photo path — features can't
      // import each other's state, so it travels through the route.
      builder: (_, state) =>
          ScanYourFaceScreen(profilePhotoPath: state.extra as String?),
    ),
    GoRoute(
      path: startVerification,
      builder: (_, _) => const StartVerificationScreen(),
    ),
    GoRoute(
      path: photoVerification,
      builder: (_, _) => const PhotoVerificationScreen(),
    ),
  ];

  /// Standalone routes (own header, outside any wizard shell).
  static List<GoRoute> routes = [
    GoRoute(
      path: location,
      builder: (_, _) => const LocationFilterScreen(isOnboardingStep: true),
    ),
    GoRoute(path: addFilters, builder: (_, _) => const AddFiltersScreen()),
    GoRoute(
      path: locationFilter,
      builder: (_, _) => const LocationFilterScreen(),
    ),
  ];
}
