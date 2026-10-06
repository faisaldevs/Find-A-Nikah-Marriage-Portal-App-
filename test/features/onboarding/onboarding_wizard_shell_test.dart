import 'package:find_a_nikah/core/router/verification_routes.dart';
import 'package:find_a_nikah/core/ui/components/wizard_progress_bar.dart';
import 'package:find_a_nikah/core/ui/components/wizard_shell.dart';
import 'package:find_a_nikah/features/auth/auth_routes.dart';
import 'package:find_a_nikah/features/onboarding/onboarding_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

/// Sign-up runs as two wizard parts, each a `ShellRoute` with one
/// persistent header + progress bar whose title/progress follow the top
/// route, while only the page body transitions:
/// Profile (Account type → Bio) and Verification (phone → photos → face).
void main() {
  late GoRouter router;

  Future<void> pumpWizard(WidgetTester tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    router = GoRouter(
      initialLocation: OnboardingRoutes.accountType,
      routes: [
        ...OnboardingRoutes.routes,
        verificationShellRoute,
        ...AuthRoutes.routes,
      ],
    );
    await tester.pumpWidget(
      ProviderScope(
        child: ScreenUtilPlusInit(
          designSize: const Size(390, 844),
          minTextAdapt: true,
          builder: (_, _) => MaterialApp.router(routerConfig: router),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  /// The app-bar title only — page bodies may repeat the same words.
  Finder headerTitle(String text) =>
      find.descendant(of: find.byType(WizardHeader), matching: find.text(text));

  WizardProgressBar bar(WidgetTester tester) =>
      tester.widget<WizardProgressBar>(find.byType(WizardProgressBar));

  testWidgets('header stays single and follows pushed steps', (tester) async {
    await pumpWizard(tester);
    expect(find.byType(WizardHeader), findsOneWidget);
    expect(headerTitle('Choose account type'), findsOneWidget);
    expect(bar(tester).activeSegment, 0);
    expect(bar(tester).step, 1);
    expect(bar(tester).segmentCount, 3);

    router.push(OnboardingRoutes.intentions);
    await tester.pumpAndSettle();
    // Still exactly one header — the page body swapped, not the chrome.
    expect(find.byType(WizardHeader), findsOneWidget);
    expect(find.byType(WizardShell), findsOneWidget);
    expect(headerTitle('About Find A Nikah'), findsOneWidget);
    expect(bar(tester).step, 2);

    // Crossing into section 2.
    router.push(OnboardingRoutes.education);
    await tester.pumpAndSettle();
    expect(headerTitle('Education'), findsOneWidget);
    expect(bar(tester).activeSegment, 1);
    expect(bar(tester).step, 1);

    // Back pops one step and the header follows.
    router.pop();
    await tester.pumpAndSettle();
    expect(headerTitle('About Find A Nikah'), findsOneWidget);
    expect(bar(tester).activeSegment, 0);
  });

  testWidgets('Bio hands off to the separate Verification part', (
    tester,
  ) async {
    await pumpWizard(tester);
    router.push(OnboardingRoutes.bio);
    await tester.pumpAndSettle();
    expect(headerTitle('Bio'), findsOneWidget);
    expect(bar(tester).activeSegment, 2);
    expect(bar(tester).step, bar(tester).totalSteps);

    // New part: a different shell, bar restarts at its first section.
    router.push(OnboardingRoutes.phoneNumber);
    await tester.pumpAndSettle();
    expect(find.byType(WizardHeader), findsOneWidget);
    expect(headerTitle('Phone number'), findsOneWidget);
    expect(bar(tester).segmentCount, 3);
    expect(bar(tester).activeSegment, 0);
    expect(bar(tester).step, 1);

    router.push(OnboardingRoutes.phoneVerificationCode);
    await tester.pumpAndSettle();
    expect(headerTitle('Phone verification'), findsOneWidget);
    expect(find.text('Enter verification code'), findsOneWidget);
    expect(bar(tester).step, 2);

    // Face verification (features/auth) shares the Verification shell.
    router.push(AuthRoutes.startVerification);
    await tester.pumpAndSettle();
    expect(find.byType(WizardHeader), findsOneWidget);
    expect(headerTitle('Start Verification'), findsOneWidget);
    expect(bar(tester).activeSegment, 2);
    expect(bar(tester).step, 2);

    // Back out of the Verification part returns to the Profile part.
    for (var i = 0; i < 3; i++) {
      router.pop();
      await tester.pumpAndSettle();
    }
    expect(headerTitle('Bio'), findsOneWidget);
    expect(bar(tester).activeSegment, 2);
  });

  test('every wizard step has progress, non-wizard paths do not', () {
    for (final section in OnboardingRoutes.wizardSections) {
      for (final (path, _) in section) {
        expect(OnboardingRoutes.wizardProgressFor(path), isNotNull);
      }
    }
    expect(OnboardingRoutes.wizardProgressFor(OnboardingRoutes.login), isNull);
    // Photos / phone / OTP left the Profile part.
    expect(
      OnboardingRoutes.wizardProgressFor(OnboardingRoutes.addPhotos),
      isNull,
    );
    expect(
      WizardProgress.forPath(verificationSections, OnboardingRoutes.addPhotos),
      isNotNull,
    );
  });
}
