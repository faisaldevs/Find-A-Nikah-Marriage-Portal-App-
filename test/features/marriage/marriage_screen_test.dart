import 'package:find_a_nikah/core/filters/discovery_filters_controller.dart';
import 'package:find_a_nikah/core/ui/components/main_nav_shell.dart';
import 'package:find_a_nikah/core/ui/placeholder_screen.dart';
import 'package:find_a_nikah/features/marriage/marriage_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

/// Marriage tab (UI-only): Cancel/Save move to the next profile and loop,
/// Previous goes back one, filter changes restart the feed, and the tab
/// keeps its place when switching tabs. Network photos fail in tests and
/// fall back to the grey placeholder.
void main() {
  late ProviderContainer container;

  Future<void> pumpApp(WidgetTester tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    container = ProviderContainer();
    addTearDown(container.dispose);
    final router = GoRouter(
      initialLocation: MarriageRoutes.marriage,
      routes: [
        StatefulShellRoute.indexedStack(
          builder: (_, _, shell) => MainNavShell(navigationShell: shell),
          branches: [
            StatefulShellBranch(routes: MarriageRoutes.routes),
            for (final name in ['Explore', 'Feed', 'Chat', 'Menu'])
              StatefulShellBranch(
                routes: [
                  GoRoute(
                    path: '/${name.toLowerCase()}',
                    builder: (_, _) => PlaceholderScreen(title: name),
                  ),
                ],
              ),
          ],
        ),
      ],
    );
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: ScreenUtilPlusInit(
          designSize: const Size(390, 844),
          minTextAdapt: true,
          builder: (_, _) => MaterialApp.router(routerConfig: router),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> tapTooltip(WidgetTester tester, String tooltip) async {
    await tester.tap(find.byTooltip(tooltip));
    await tester.pumpAndSettle();
  }

  testWidgets('Save/Cancel advance and loop; Previous goes back', (
    tester,
  ) async {
    await pumpApp(tester);
    expect(find.text('Tabassum, 31'), findsOneWidget);
    expect(find.text('Active today'), findsOneWidget);
    expect(find.text('Actively practising'), findsOneWidget);

    await tapTooltip(tester, 'Save');
    expect(find.text('Nusrat, 27'), findsOneWidget);

    await tapTooltip(tester, 'Previous');
    expect(find.text('Tabassum, 31'), findsOneWidget);

    // 5 dummy profiles: 5 × Cancel loops back to the first.
    for (var i = 0; i < 5; i++) {
      await tapTooltip(tester, 'Cancel');
    }
    expect(find.text('Tabassum, 31'), findsOneWidget);
  });

  testWidgets('changing filters restarts the feed', (tester) async {
    await pumpApp(tester);
    await tapTooltip(tester, 'Save');
    await tapTooltip(tester, 'Save');
    expect(find.text('Ayesha, 29'), findsOneWidget);

    container
        .read(discoveryFiltersControllerProvider.notifier)
        .setAgeRange(20, 30);
    await tester.pumpAndSettle();
    expect(find.text('Tabassum, 31'), findsOneWidget);
  });

  testWidgets('tab switch keeps the Marriage position', (tester) async {
    await pumpApp(tester);
    await tapTooltip(tester, 'Save');
    expect(find.text('Nusrat, 27'), findsOneWidget);

    await tester.tap(find.text('Explore'));
    await tester.pumpAndSettle();
    expect(find.text('Explore — coming soon'), findsOneWidget);

    await tester.tap(find.text('Marriage'));
    await tester.pumpAndSettle();
    expect(find.text('Nusrat, 27'), findsOneWidget);
  });
}
