import 'package:find_a_nikah/app/di.dart';
import 'package:find_a_nikah/core/ui/ui.dart';
import 'package:find_a_nikah/features/auth/domain/domain.dart';
import 'package:find_a_nikah/features/auth/presentation/bloc/sign_in_bloc.dart';
import 'package:find_a_nikah/features/auth/presentation/presentation.dart'
    show LoginPage;
import 'package:find_a_nikah/features/auth/presentation/view/login_page.dart'
    show LoginPage;
import 'package:find_a_nikah/features/auth/presentation/widgets/auth_backdrop.dart';
import 'package:find_a_nikah/gen/assets.gen.dart';
import 'package:find_a_nikah/router/route_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:go_router/go_router.dart';

/// First auth-choice screen — sits between the intro carousel and the
/// email/password [LoginPage]. Google/Apple go through the auth repository
/// (a fake provider in dev until the OAuth SDKs are added).
class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<SignInBloc>(),
      child: BlocListener<SignInBloc, SignInState>(
        listenWhen: (prev, next) => prev.status != next.status,
        listener: (context, state) => onSignInStateChanged(
          (failure) => showFailureToast(context, failure),
          () => context.push<void>(RoutePaths.getStarted).ignore(),
          state,
        ),
        child: const _WelcomeView(),
      ),
    );
  }
}

class _WelcomeView extends StatelessWidget {
  const _WelcomeView();

  @override
  Widget build(BuildContext context) {
    final busy = context.select<SignInBloc, bool>(
      (b) => b.state.status == SignInStatus.submitting,
    );
    void social(SocialProvider p) =>
        context.read<SignInBloc>().add(SignInSocialRequested(p));
    return Scaffold(
      body: AuthBackdrop(
        child: Column(
          children: [
            // Padding(
            //   padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       // TODO(i18n): wire a real language picker.
            //       const _GhostPill(icon: Icons.language, label: 'English'),
            //       _GhostIcon(icon: Icons.help_outline, onTap: () {}),
            //     ],
            //   ),
            // ),
            // SizedBox(height: 20.h),
            // BrandLogo(width: 175.w),
            // const Spacer(flex: 4),
            // Figma 883:3805: plain white globe + 'English' and a bare (?)
            // icon — no pill/circle backgrounds.
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 32.h, 20.w, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // TODO(i18n): wire a real language picker.
                  const _GhostPill(icon: Icons.language, label: 'English'),
                  _GhostIcon(icon: Icons.help_outline, onTap: () {}),
                ],
              ),
            ),
            SizedBox(height: 46.h),
            BrandLogo(width: 172.w),
            const Spacer(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                children: [
                  _SocialButton(
                    label: 'Continue with Google',
                    onPressed: busy
                        ? null
                        : () => social(SocialProvider.google),
                    leading: Image.asset(
                      Assets.images.googleIcon,
                      height: 24.h,
                      width: 24.w,
                    ),
                  ),
                  SizedBox(height: 18.h),
                  _SocialButton(
                    label: 'Continue with Apple',
                    onPressed: busy ? null : () => social(SocialProvider.apple),
                    leading: Image.asset(
                      Assets.images.appleIcon,
                      height: 24.h,
                      width: 24.w,
                    ),
                  ),
                  SizedBox(height: 18.h),
                  SizedBox(
                    width: double.infinity,
                    // height: 52.h,
                    height: 48.h,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        // side: const BorderSide(color: Colors.white70),
                        side: const BorderSide(color: Color(0xFFE5E7EB)),
                        shape: RoundedRectangleBorder(
                          // borderRadius: BorderRadius.circular(14.r),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      onPressed: () =>
                          context.push<void>(RoutePaths.login).ignore(),
                      child: Text(
                        'Continue with email',
                        // style: TextFontStyle
                        //     .headline15w600textWhiteStyleSatoshi,
                        style: TextFontStyle.headline16w700textDarkStyleSatoshi
                            .copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(height: 46.h),
                  // const LegalFooterText(
                  //   light: true,
                  //   textAlign: TextAlign.center,
                  // ),
                  // Figma keeps this on one line; scale down rather than wrap.
                  const FittedBox(
                    fit: BoxFit.scaleDown,
                    child: LegalFooterText(
                      light: true,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  // SizedBox(height: 16.h),
                  SizedBox(height: 12.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  const _SocialButton({
    required this.label,
    required this.leading,
    required this.onPressed,
  });

  final String label;
  final Widget leading;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      // height: 52.h,
      height: 48.h,
      child: FilledButton(
        style: FilledButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          shape: RoundedRectangleBorder(
            // borderRadius: BorderRadius.circular(14.r),
            borderRadius: BorderRadius.circular(8.r),
          ),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            leading,

            Expanded(
              child: Center(
                child: Text(
                  label,
                  // style: TextFontStyle.headline15w600StyleSatoshi,
                  style: TextFontStyle.headline16w700textDarkStyleSatoshi,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GhostPill extends StatelessWidget {
  const _GhostPill({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    // return Container(
    //   padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
    //   decoration: BoxDecoration(
    //     color: Colors.black.withValues(alpha: 0.3),
    //     borderRadius: BorderRadius.circular(20.r),
    //   ),
    //   child: Row(
    //     mainAxisSize: MainAxisSize.min,
    //     children: [
    //       Icon(icon, color: Colors.white, size: 18.r),
    //       SizedBox(width: 6.w),
    //       Text(label,
    //           style: TextFontStyle.headline14w400textWhiteStyleSatoshi),
    //     ],
    //   ),
    // );
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white, size: 20.r),
        SizedBox(width: 10.w),
        Text(label, style: TextFontStyle.headline16w500textWhiteStyleSatoshi),
      ],
    );
  }
}

class _GhostIcon extends StatelessWidget {
  const _GhostIcon({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      // child: Container(
      //   padding: EdgeInsets.all(8.r),
      //   decoration: BoxDecoration(
      //     color: Colors.black.withValues(alpha: 0.3),
      //     shape: BoxShape.circle,
      //   ),
      //   child: Icon(icon, color: Colors.white, size: 18.r),
      // ),
      child: Padding(
        padding: EdgeInsets.all(4.r),
        child: Icon(icon, color: Colors.white, size: 18.r),
      ),
    );
  }
}
