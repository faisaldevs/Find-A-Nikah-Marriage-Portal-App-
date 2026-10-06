import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/auth_routes.dart';
import '../../features/marriage/marriage_routes.dart';
import '../../features/onboarding/onboarding_routes.dart';
import '../providers/session_provider.dart';
import '../ui/components/main_nav_shell.dart';
import '../ui/placeholder_screen.dart';
import 'app_route_observer.dart';
import 'verification_routes.dart';

/// Route path constants for the bottom-nav tabs that don't have a feature
/// yet (placeholders). Marriage's path lives in [MarriageRoutes];
/// onboarding's in [OnboardingRoutes] — avoids magic strings scattered
/// across features.
class RoutePaths {
  RoutePaths._();

  // static const discovery = '/discovery';  // replaced by MarriageRoutes.marriage
  // static const profile = '/profile';      // not a tab in the bottom nav
  static const explore = '/explore';
  static const feed = '/feed';
  static const chat = '/chat';
  static const menu = '/menu';
}

/// Reads the in-memory session stub ([sessionProvider]) — set by the intro's
/// "Skip" and by "Discover profiles". Replace with the real auth state once
/// it exists; the redirect guard below needs no other change.
bool _isLoggedIn(Ref ref) => ref.read(sessionProvider);
// bool _isLoggedIn(Ref ref) => false;  // previous hard-coded "logged out" stub

/// Single source of truth for navigation. Screens must go through this
/// (or a route's own `context.go`/`push`), never duplicate the auth check
/// that lives in [redirect] here.
final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: OnboardingRoutes.splash,
    // Logs `route -> ScreenWidget` on every screen entry (debug builds only).
    observers: [AppRouteObserver()],
    // TODO: once authProvider exists, pass
    // `refreshListenable: GoRouterRefreshStream(ref.watch(authStateProvider.notifier).stream)`
    // so a logout while already on a screen re-triggers this redirect —
    // right now it only re-evaluates on navigation.
    redirect: (context, state) {
      final loggedIn = _isLoggedIn(ref);
      // Verification + filters (features/auth) continue the sign-up flow
      // straight after the phone OTP, so they're public for the same reason
      // onboarding is.
      final isOnboardingRoute =
          OnboardingRoutes.all.contains(state.matchedLocation) ||
          AuthRoutes.all.contains(state.matchedLocation);
      // final isOnboardingRoute = OnboardingRoutes.all.contains(   // superseded: AuthRoutes added
      //   state.matchedLocation,
      // );

      // Onboarding (splash/login/welcome/wizard) is always reachable — it IS
      // the auth flow, so it can't gate itself behind being logged in.
      if (!loggedIn && !isOnboardingRoute) return OnboardingRoutes.splash;
      if (loggedIn &&
          (state.matchedLocation == OnboardingRoutes.splash ||
              state.matchedLocation == OnboardingRoutes.login ||
              state.matchedLocation == OnboardingRoutes.welcome)) {
        return MarriageRoutes.marriage;
        // return RoutePaths.discovery;
      }
      return null;
    },
    routes: [
      ...OnboardingRoutes.routes,
      // Phone → photos → face verification: one wizard shell spanning
      // onboarding + auth routes.
      verificationShellRoute,
      ...AuthRoutes.routes,
      // Main app: bottom nav, each tab keeps its own stack + state.
      StatefulShellRoute.indexedStack(
        builder: (_, _, navigationShell) =>
            MainNavShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(routes: MarriageRoutes.routes),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.explore,
                builder: (_, _) => const PlaceholderScreen(title: 'Explore'),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.feed,
                builder: (_, _) => const PlaceholderScreen(title: 'Feed'),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.chat,
                builder: (_, _) => const PlaceholderScreen(title: 'Chat'),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.menu,
                builder: (_, _) => const PlaceholderScreen(title: 'Menu'),
              ),
            ],
          ),
        ],
      ),
      // Previous flat placeholder routes (no bottom nav):
      // GoRoute(
      //   path: RoutePaths.discovery,
      //   builder: (_, _) => const PlaceholderScreen(title: 'Discovery'),
      // ),
      // GoRoute(
      //   path: RoutePaths.profile,
      //   builder: (_, _) => const PlaceholderScreen(title: 'Profile'),
      // ),
      // GoRoute(
      //   path: RoutePaths.feed,
      //   builder: (_, _) => const PlaceholderScreen(title: 'Feed'),
      // ),
      // GoRoute(
      //   path: RoutePaths.chat,
      //   builder: (_, _) => const PlaceholderScreen(title: 'Chat'),
      // ),
    ],
    errorBuilder: (_, state) =>
        Scaffold(body: Center(child: Text('Route not found: ${state.uri}'))),
  );
});
