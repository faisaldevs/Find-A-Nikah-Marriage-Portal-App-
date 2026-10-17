import 'dart:async';

import 'package:find_a_nikah/core/ui/ui.dart';
import 'package:find_a_nikah/features/auth/domain/domain.dart';
import 'package:find_a_nikah/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:find_a_nikah/gen/assets.gen.dart';
import 'package:find_a_nikah/router/route_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:go_router/go_router.dart';

/// Brief branded loading screen, shown while stored credentials are read.
///
/// Once both the 1.2 s brand beat has passed *and* the auth status is
/// known (a slow Keystore read on first launch must not swallow the
/// navigation), branches on [SignedOutReason]: a fresh install (or a
/// one-shot login screen already shown with no sign-in since) moves on to
/// the intro carousel; logout/expiry skip it, straight to login with a
/// toast — shown once, then the repository resets to [SignedOutReason.
/// freshInstall] for the next open. Signed-in users never see this
/// redirect: the router sends them on as soon as the session is restored.
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  Timer? _timer;
  bool _beatDone = false;
  bool _handledSignedOut = false;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(milliseconds: 1200), () {
      _beatDone = true;
      _maybeContinue(context.read<AuthBloc>().state);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Decode the next screens' full-bleed images while the brand beat
    // plays, so intro/welcome paint them on their first frame instead of
    // flashing an empty background.
    for (final path in [
      Assets.images.onboardingPhoto1,
      Assets.images.onboardingPhoto2,
      Assets.images.onboardingPhoto3,
      Assets.images.authBackground,
      Assets.images.findANikahFullLogoImage4xColored,
    ]) {
      unawaited(precacheImage(AssetImage(path), context));
    }
  }

  void _maybeContinue(AuthStatus status) {
    if (!mounted ||
        !_beatDone ||
        status is! Unauthenticated ||
        _handledSignedOut) {
      return;
    }
    _handledSignedOut = true;
    switch (status.reason) {
      case SignedOutReason.freshInstall:
        context.go(RoutePaths.intro);
      case SignedOutReason.loggedOut:
        CustomToast.showInfo(context, 'Signed out successfully');
        context.go(RoutePaths.login);
      case SignedOutReason.sessionExpired:
        CustomToast.showInfo(context, 'Session expired, please log in again');
        context.go(RoutePaths.login);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthStatus>(
      listener: (_, status) => _maybeContinue(status),
      child: Scaffold(
        body: Container(
          color: AppColors.primaryColor,
          height: double.infinity,
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 59.w),
          child: Image.asset(Assets.images.findANikahFullLogoImage4x),
        ),
      ),
    );
  }
}
