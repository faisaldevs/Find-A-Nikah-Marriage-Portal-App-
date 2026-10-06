import 'dart:async';

import 'package:find_a_nikah/gen/assets.gen.dart';
import 'package:find_a_nikah/gen/colors.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../../../../../core/router/app_navigator.dart';

/// Brief branded loading screen — auto-navigates into the intro carousel.
/// No real init work happens here yet (no auth/session bootstrap exists);
/// this is purely the visual beat before the flow starts.
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 1200), () {
      if (mounted) ref.read(appNavigatorProvider).toOnboardingIntro();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: AppColors.primaryColor,
        height: double.infinity,
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 59.w),
        child: Image.asset(Assets.images.findANikahFullLogoImage4x),
      ),
    );
  }
}
