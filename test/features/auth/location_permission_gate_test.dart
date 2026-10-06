import 'package:find_a_nikah/features/auth/location/presentation/screens/location_filter_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

/// Location is mandatory on the Location step. Stubs geolocator's platform
/// channel so the user denies the system prompt.
void main() {
  const channel = MethodChannel('flutter.baseflow.com/geolocator');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
          return switch (call.method) {
            'isLocationServiceEnabled' => true,
            'checkPermission' => 0, // denied
            'requestPermission' => 1, // deniedForever (user said no)
            _ => null,
          };
        });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  testWidgets('denied location shows the mandatory popup; Go back leaves', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final router = GoRouter(
      initialLocation: '/prev',
      routes: [
        GoRoute(
          path: '/prev',
          builder: (_, _) => const Scaffold(body: Text('previous step')),
        ),
        GoRoute(
          path: '/location',
          builder: (_, _) => const LocationFilterScreen(isOnboardingStep: true),
        ),
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
    router.push('/location');
    // Not pumpAndSettle: the spinner animates until the permission check
    // resolves, so pump frames until the popup shows.
    for (
      var i = 0;
      i < 20 && find.text('Open settings').evaluate().isEmpty;
      i++
    ) {
      await tester.pump(const Duration(milliseconds: 100));
    }

    expect(find.text('Location is required'), findsOneWidget);
    expect(find.text('Open settings'), findsOneWidget);
    // Header + tabs stay visible behind the popup; tab content is gated.
    expect(find.text('Distance'), findsOneWidget);

    // Not dismissible by tapping outside.
    await tester.tapAt(const Offset(10, 10));
    await tester.pumpAndSettle();
    expect(find.text('Location is required'), findsOneWidget);

    await tester.tap(find.text('Go back'));
    await tester.pumpAndSettle();
    expect(find.text('Location is required'), findsNothing);
    expect(find.text('previous step'), findsOneWidget);
  });

  testWidgets('app bar: back / title / Clear never overlap', (tester) async {
    for (final (width, scale) in [(320.0, 1.0), (390.0, 1.0), (320.0, 2.0)]) {
      tester.view.physicalSize = Size(width, 844);
      tester.view.devicePixelRatio = 1;
      tester.platformDispatcher.textScaleFactorTestValue = scale;
      addTearDown(tester.view.reset);
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
      await tester.pumpWidget(
        ProviderScope(
          child: ScreenUtilPlusInit(
            designSize: const Size(390, 844),
            minTextAdapt: true,
            builder: (_, _) => const MaterialApp(home: LocationFilterScreen()),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 300));

      final back = tester.getRect(
        find.widgetWithIcon(IconButton, Icons.arrow_back),
      );
      final title = tester.getRect(find.text('Location'));
      final clear = tester.getRect(find.widgetWithText(TextButton, 'Clear'));
      expect(back.overlaps(title), isFalse, reason: 'w=$width s=$scale');
      expect(title.overlaps(clear), isFalse, reason: 'w=$width s=$scale');
      if (scale == 1.0) {
        expect(tester.getCenter(find.text('Location')).dx, width / 2);
      }
      // Close the permission popup before the next size.
      await tester.pumpWidget(const SizedBox());
      await tester.pump();
    }
  });
}
