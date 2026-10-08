import 'dart:developer' as developer;

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Logs every screen entry as `route -> PageWidget`, in one place, so no
/// page has to remember to log itself. Wired into [GoRouter.observers] in
/// `app_router.dart`.
///
/// Covers all three ways a screen becomes visible: pushed on top, replacing
/// the current one, and revealed again when the screen above it pops.
/// Debug builds only — release builds log nothing.
class AppRouteObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _log('PUSH', route);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    if (newRoute != null) _log('REPLACE', newRoute);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    // Popping means the route underneath is the screen being entered.
    if (previousRoute != null) _log('POP', previousRoute);
  }

  void _log(String action, Route<dynamic> route) {
    if (!kDebugMode) return;
    developer.log(
      '$action  ${_routeNameOf(route)}  ->  ${_screenNameOf(route)}',
      name: 'nav',
    );
  }

  /// The configured path (e.g. `/onboarding/country`). go_router puts it on
  /// the page's `name` when building the route.
  String _routeNameOf(Route<dynamic> route) {
    final settings = route.settings;
    final name = settings.name;
    if (name != null && name.isNotEmpty) return name;
    return '(unnamed)';
  }

  /// The page widget's class name (e.g. `CountryPage`), pulled off the
  /// page go_router built for this route.
  String _screenNameOf(Route<dynamic> route) {
    final settings = route.settings;
    final child = switch (settings) {
      MaterialPage(child: final c) => c,
      CupertinoPage(child: final c) => c,
      CustomTransitionPage(child: final c) => c,
      _ => null,
    };
    if (child != null) return child.runtimeType.toString();
    return route.runtimeType.toString();
  }
}
