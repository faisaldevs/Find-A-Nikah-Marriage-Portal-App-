import 'package:find_a_nikah/features/auth/face_verification/presentation/screens/photo_verification_screen.dart';
import 'package:find_a_nikah/features/auth/face_verification/presentation/screens/scan_your_face_screen.dart';
import 'package:find_a_nikah/features/auth/face_verification/presentation/screens/start_verification_screen.dart';
import 'package:find_a_nikah/features/auth/location/presentation/screens/add_filters_screen.dart';
import 'package:find_a_nikah/features/auth/location/presentation/widgets/country_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_test/flutter_test.dart';

/// Renders each new `features/auth` screen once so layout/build errors
/// surface in CI. The distance map tab is excluded — it fetches OSM tiles,
/// which the test HTTP stub rejects; verify that one on a device.
///
/// Mirrors `main.dart`'s ScreenUtil setup (design size + minTextAdapt) —
/// without it `.sp` and `.r` scale differently on the 800×600 test surface
/// and produce overflows that never happen on a phone.
Widget _host(Widget child) {
  return ProviderScope(
    child: ScreenUtilPlusInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      builder: (_, _) => MaterialApp(home: child),
    ),
  );
}

void _usePhoneSurface(WidgetTester tester) {
  tester.view.physicalSize = const Size(390, 844);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
}

void main() {
  testWidgets('ScanYourFaceScreen renders without a photo', (tester) async {
    _usePhoneSurface(tester);
    await tester.pumpWidget(_host(const ScanYourFaceScreen()));
    expect(
      find.text("Confirm it's you in this photo to get verified"),
      findsOneWidget,
    );
    expect(find.text('Verify photo'), findsOneWidget);
    expect(find.text('Add photo'), findsOneWidget);
  });

  testWidgets('StartVerificationScreen shows empty selfie circle', (
    tester,
  ) async {
    _usePhoneSurface(tester);
    await tester.pumpWidget(_host(const StartVerificationScreen()));
    expect(find.text("Won't be shown\non your profile"), findsOneWidget);
    // App-bar title now comes from the Verification shell
    // (core/router/verification_routes.dart), not the screen itself.
    // expect(find.text('Start Verification'), findsOneWidget); // app bar
    expect(find.text('Start verification'), findsOneWidget); // CTA
  });

  testWidgets('PhotoVerificationScreen greets generically without a name', (
    tester,
  ) async {
    _usePhoneSurface(tester);
    await tester.pumpWidget(_host(const PhotoVerificationScreen()));
    expect(find.textContaining('Jazakallah'), findsOneWidget);
    expect(find.text('Continue'), findsOneWidget);
  });

  testWidgets('AddFiltersScreen shows defaults', (tester) async {
    _usePhoneSurface(tester);
    await tester.pumpWidget(_host(const AddFiltersScreen()));
    expect(find.text('Any age'), findsOneWidget);
    expect(find.text('Anywhere'), findsOneWidget);
    expect(find.text('No preference'), findsOneWidget);
    expect(find.text('Discover profiles'), findsOneWidget);
  });

  testWidgets('CountryTab disables Confirm until a country is picked', (
    tester,
  ) async {
    _usePhoneSurface(tester);
    await tester.pumpWidget(
      _host(Scaffold(body: CountryTab(onConfirmed: () {}))),
    );
    final button = tester.widget<FilledButton>(find.byType(FilledButton));
    expect(button.onPressed, isNull);

    await tester.tap(find.text('Bangladesh').first);
    await tester.pump();
    final enabled = tester.widget<FilledButton>(find.byType(FilledButton));
    expect(enabled.onPressed, isNotNull);
  });
}
