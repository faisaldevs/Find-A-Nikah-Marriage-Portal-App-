import 'dart:async';

import 'package:find_a_nikah/features/auth/domain/domain.dart';
import 'package:find_a_nikah/features/remote_config/domain/domain.dart';
import 'package:find_a_nikah/router/app_route_observer.dart';
import 'package:find_a_nikah/router/route_paths.dart';
import 'package:find_a_nikah/router/routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Where [location] must go given the auth status and remote config, or
/// null to stay. Pure, so it's unit-tested without a widget tree.
///
/// - Build too old → the force-update page, nothing else.
/// - Status unknown (credentials still loading) → splash.
/// - Signed out → public routes only.
/// - Signed in, onboarding incomplete → sign-up + onboarding routes.
/// - Signed in, onboarding complete → app routes only.
/// - Face verification turned off remotely → skip to the Location step.
String? appRedirect({
  required String location,
  required AuthStatus auth,
  required bool updateRequired,
  required bool faceVerificationEnabled,
}) {
  if (updateRequired) {
    return location == RoutePaths.updateRequired
        ? null
        : RoutePaths.updateRequired;
  }
  if (location == RoutePaths.updateRequired) return RoutePaths.splash;

  final target = switch (auth) {
    AuthUnknown() => location == RoutePaths.splash ? null : RoutePaths.splash,
    Unauthenticated() =>
      RoutePaths.public.contains(location) ? null : RoutePaths.splash,
    // New account: sign-up screens stay reachable (back from "Get started"
    // returns into sign-up, as before); splash/intro move on.
    Authenticated(:final session) when !session.onboardingComplete =>
      RoutePaths.onboarding.contains(location) ||
              RoutePaths.signUpFlow.contains(location)
          ? null
          : RoutePaths.getStarted,
    Authenticated() =>
      RoutePaths.app.contains(location) ? null : RoutePaths.marriage,
  };
  if (target != null) return target;

  if (!faceVerificationEnabled &&
      RoutePaths.faceVerification.contains(location)) {
    return RoutePaths.location;
  }
  return null;
}

/// Builds the app's [GoRouter]. Re-evaluates [appRedirect] whenever
/// [authStatus] or [remoteConfig] emits, so a logout or a forced update
/// takes effect on the current screen, not only on the next navigation.
GoRouter createAppRouter({
  required AuthStatus Function() currentAuth,
  required Stream<Object?> authStatus,
  required bool Function() updateRequired,
  required bool Function(FeatureFlag) isEnabled,
  required Stream<Object?> remoteConfig,
}) {
  return GoRouter(
    initialLocation: RoutePaths.splash,
    routes: appRoutes,
    observers: [AppRouteObserver()],
    refreshListenable: StreamListenable([authStatus, remoteConfig]),
    redirect: (context, state) => appRedirect(
      location: state.matchedLocation,
      auth: currentAuth(),
      updateRequired: updateRequired(),
      faceVerificationEnabled: isEnabled(FeatureFlag.faceVerification),
    ),
    errorBuilder: (_, state) =>
        Scaffold(body: Center(child: Text('Route not found: ${state.uri}'))),
  );
}

/// A [Listenable] that fires whenever any of `streams` emits — go_router's
/// `refreshListenable` for bloc streams.
class StreamListenable extends ChangeNotifier {
  StreamListenable(List<Stream<Object?>> streams) {
    _subscriptions = [
      for (final s in streams) s.listen((_) => notifyListeners()),
    ];
  }

  late final List<StreamSubscription<Object?>> _subscriptions;

  @override
  void dispose() {
    for (final s in _subscriptions) {
      s.cancel().ignore();
    }
    super.dispose();
  }
}
