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
/// Signed-out users move on to the intro carousel once both the 1.2 s brand
/// beat has passed *and* the auth status is known (a slow Keystore read on
/// first launch must not swallow the navigation). Signed-in users never see
/// the intro: the router redirects them as soon as the session is restored.
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  Timer? _timer;
  bool _beatDone = false;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(milliseconds: 1200), () {
      _beatDone = true;
      _maybeContinue(context.read<AuthBloc>().state);
    });
  }

  void _maybeContinue(AuthStatus status) {
    if (mounted && _beatDone && status is Unauthenticated) {
      context.go(RoutePaths.intro);
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
