import 'package:find_a_nikah/features/auth/domain/domain.dart';
import 'package:find_a_nikah/router/app_router.dart';
import 'package:find_a_nikah/router/route_paths.dart';
import 'package:flutter_test/flutter_test.dart';

const _newUser = AuthStatus.authenticated(
  UserSession(userId: 'u1', onboardingComplete: false),
);
const _member = AuthStatus.authenticated(
  UserSession(userId: 'u1', onboardingComplete: true),
);

String? _redirect(
  String location,
  AuthStatus auth, {
  bool updateRequired = false,
  bool faceVerificationEnabled = true,
}) => appRedirect(
  location: location,
  auth: auth,
  updateRequired: updateRequired,
  faceVerificationEnabled: faceVerificationEnabled,
);

void main() {
  group('appRedirect', () {
    test('force update wins over everything', () {
      expect(
        _redirect(RoutePaths.marriage, _member, updateRequired: true),
        RoutePaths.updateRequired,
      );
      expect(
        _redirect(RoutePaths.updateRequired, _member, updateRequired: true),
        isNull,
      );
      // Once the floor drops, leave the update page.
      expect(
        _redirect(RoutePaths.updateRequired, _member),
        RoutePaths.splash,
      );
    });

    test('unknown status holds on splash', () {
      const unknown = AuthStatus.unknown();
      expect(_redirect(RoutePaths.splash, unknown), isNull);
      expect(_redirect(RoutePaths.marriage, unknown), RoutePaths.splash);
    });

    test('signed out: public routes only', () {
      const out = AuthStatus.unauthenticated();
      for (final path in RoutePaths.public) {
        expect(_redirect(path, out), isNull, reason: path);
      }
      expect(_redirect(RoutePaths.marriage, out), RoutePaths.splash);
      expect(_redirect(RoutePaths.getStarted, out), RoutePaths.splash);
      expect(_redirect(RoutePaths.addFilters, out), RoutePaths.splash);
    });

    test('new user: onboarding routes only, public → get started', () {
      for (final path in RoutePaths.onboarding) {
        expect(_redirect(path, _newUser), isNull, reason: path);
      }
      // Registration happens on create-password; the router moves on.
      expect(
        _redirect(RoutePaths.createPassword, _newUser),
        RoutePaths.getStarted,
      );
      expect(_redirect(RoutePaths.marriage, _newUser), RoutePaths.getStarted);
    });

    test('member: app routes only, everything else → Marriage', () {
      for (final path in RoutePaths.app) {
        expect(_redirect(path, _member), isNull, reason: path);
      }
      expect(_redirect(RoutePaths.splash, _member), RoutePaths.marriage);
      expect(_redirect(RoutePaths.login, _member), RoutePaths.marriage);
      expect(_redirect(RoutePaths.accountType, _member), RoutePaths.marriage);
    });

    test('returning incomplete user resumes at their wizard section', () {
      const atBackgroundFaith = AuthStatus.authenticated(
        UserSession(userId: 'u1', onboardingComplete: false, resumeStep: 5),
      );
      const atLifestyle = AuthStatus.authenticated(
        UserSession(userId: 'u1', onboardingComplete: false, resumeStep: 6),
      );
      const atBio = AuthStatus.authenticated(
        UserSession(userId: 'u1', onboardingComplete: false, resumeStep: 7),
      );
      const atPhoneUnverified = AuthStatus.authenticated(
        UserSession(userId: 'u1', onboardingComplete: false, resumeStep: 8),
      );
      const atPhotos = AuthStatus.authenticated(
        UserSession(
          userId: 'u1',
          onboardingComplete: false,
          resumeStep: 8,
          isPhoneVerified: true,
        ),
      );

      expect(
        _redirect(RoutePaths.marriage, atBackgroundFaith),
        RoutePaths.education,
      );
      expect(
        _redirect(RoutePaths.marriage, atLifestyle),
        RoutePaths.lifestylePreferences,
      );
      expect(_redirect(RoutePaths.marriage, atBio), RoutePaths.bio);
      // Past Bio, not backend-tracked yet — phone must be verified first,
      // and stays locked once it is (see `wizard_sections.dart`).
      expect(
        _redirect(RoutePaths.marriage, atPhoneUnverified),
        RoutePaths.phoneNumber,
      );
      expect(_redirect(RoutePaths.marriage, atPhotos), RoutePaths.addPhotos);
      // Data-derived steps (see `resumeStep`): 11 location, 12 filters.
      expect(
        _redirect(
          RoutePaths.marriage,
          const AuthStatus.authenticated(
            UserSession(
              userId: 'u1',
              onboardingComplete: false,
              resumeStep: 11,
              isPhoneVerified: true,
            ),
          ),
        ),
        RoutePaths.location,
      );
      expect(
        _redirect(
          RoutePaths.marriage,
          const AuthStatus.authenticated(
            UserSession(
              userId: 'u1',
              onboardingComplete: false,
              resumeStep: 12,
              isPhoneVerified: true,
            ),
          ),
        ),
        RoutePaths.addFilters,
      );

      // Already inside the wizard: free to navigate, no step-lock.
      expect(_redirect(RoutePaths.accountType, atBio), isNull);
    });

    test('face verification kill switch skips to Location', () {
      for (final path in RoutePaths.faceVerification) {
        expect(
          _redirect(path, _newUser, faceVerificationEnabled: false),
          RoutePaths.location,
        );
      }
      expect(
        _redirect(
          RoutePaths.addPhotos,
          _newUser,
          faceVerificationEnabled: false,
        ),
        isNull,
      );
    });
  });
}
