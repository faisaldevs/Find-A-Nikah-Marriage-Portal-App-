import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/auth_routes.dart';
import '../../features/marriage/marriage_routes.dart';
import '../../features/onboarding/onboarding_routes.dart';
import 'app_router.dart';

/// Typed navigation surface over [GoRouter]. Screens call
/// `ref.read(appNavigatorProvider).toX()` instead of `context.push(path)` —
/// route strings stay confined to [OnboardingRoutes]/[RoutePaths], and
/// navigation works from anywhere holding a [WidgetRef] (no BuildContext
/// needed), which also makes it mockable in tests.
class AppNavigator {
  AppNavigator(this._router);

  final GoRouter _router;

  void toOnboardingIntro() => _router.go(OnboardingRoutes.introCarousel);
  void toLogin() => _router.push(OnboardingRoutes.login);
  void toWelcome() => _router.push(OnboardingRoutes.welcome);
  void toEmailAddress() => _router.push(OnboardingRoutes.emailAddress);
  void toVerificationCode() => _router.push(OnboardingRoutes.verificationCode);
  void toCreatePassword() => _router.push(OnboardingRoutes.createPassword);
  void toGetStarted() => _router.push(OnboardingRoutes.getStarted);

  // Profile-info wizard — order matches the reference mockups exactly.
  void toAccountType() => _router.push(OnboardingRoutes.accountType);
  void toIntentions() => _router.push(OnboardingRoutes.intentions);
  void toHowHeard() => _router.push(OnboardingRoutes.howHeard);
  void toNationality() => _router.push(OnboardingRoutes.nationality);
  void toCountry() => _router.push(OnboardingRoutes.country);
  void toEthnicity() => _router.push(OnboardingRoutes.ethnicity);
  void toHeight() => _router.push(OnboardingRoutes.height);
  void toEducation() => _router.push(OnboardingRoutes.education);
  void toProfession() => _router.push(OnboardingRoutes.profession);
  void toMaritalStatus() => _router.push(OnboardingRoutes.maritalStatus);
  void toMarriage() => _router.push(OnboardingRoutes.marriage);
  void toFaith() => _router.push(OnboardingRoutes.faith);
  void toReligiousPractice() =>
      _router.push(OnboardingRoutes.religiousPractice);
  void toLifestylePreferences() =>
      _router.push(OnboardingRoutes.lifestylePreferences);
  void toAboutYou() => _router.push(OnboardingRoutes.aboutYou);
  void toPersonality() => _router.push(OnboardingRoutes.personality);
  void toInterests() => _router.push(OnboardingRoutes.interests);
  void toBio() => _router.push(OnboardingRoutes.bio);
  void toAddPhotos() => _router.push(OnboardingRoutes.addPhotos);
  void toPhoneNumber() => _router.push(OnboardingRoutes.phoneNumber);
  void toPhoneVerificationCode() =>
      _router.push(OnboardingRoutes.phoneVerificationCode);

  // features/auth — face verification, then discovery filters.
  /// [profilePhotoPath] is the first onboarding photo; passed as route
  /// `extra` because features can't import each other's providers.
  void toScanYourFace({String? profilePhotoPath}) =>
      _router.push(AuthRoutes.scanYourFace, extra: profilePhotoPath);
  void toStartVerification() => _router.push(AuthRoutes.startVerification);
  void toPhotoVerification() => _router.push(AuthRoutes.photoVerification);
  void toLocation() => _router.push(AuthRoutes.location);
  void toAddFilters() => _router.push(AuthRoutes.addFilters);
  void toLocationFilter() => _router.push(AuthRoutes.locationFilter);

  /// Main app, first tab. `go` (not push): clears the sign-up / filters
  /// stack so back doesn't return into onboarding.
  void toMarriageTab() => _router.go(MarriageRoutes.marriage);
  // void toDiscovery() => _router.go(RoutePaths.discovery);
}

final appNavigatorProvider = Provider<AppNavigator>((ref) {
  return AppNavigator(ref.watch(appRouterProvider));
});
