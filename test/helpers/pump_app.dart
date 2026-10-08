import 'package:find_a_nikah/app/app.dart' show designSize;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:find_a_nikah/core/ui/ui.dart';

extension PumpApp on WidgetTester {
  /// Phone-sized surface at the design canvas, 1:1 pixels.
  void usePhoneSurface() {
    view
      ..physicalSize = designSize
      ..devicePixelRatio = 1;
    addTearDown(view.reset);
  }

  /// Hosts [router] the way `App` does (theme + ScreenUtil).
  Future<void> pumpRouter(GoRouter router) async {
    usePhoneSurface();
    await pumpWidget(
      ScreenUtilPlusInit(
        designSize: designSize,
        minTextAdapt: true,
        builder: (_, _) => MaterialApp.router(
          theme: AppTheme.light(),
          routerConfig: router,
        ),
      ),
    );
    await pumpAndSettle();
  }

  /// Hosts a single widget.
  Future<void> pumpPage(Widget page) async {
    usePhoneSurface();
    await pumpWidget(
      ScreenUtilPlusInit(
        designSize: designSize,
        minTextAdapt: true,
        builder: (_, _) => MaterialApp(theme: AppTheme.light(), home: page),
      ),
    );
    await pump();
  }
}
