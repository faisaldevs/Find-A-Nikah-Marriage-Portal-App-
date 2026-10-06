import 'package:find_a_nikah/gen/assets.gen.dart';
import 'package:find_a_nikah/core/constants/text_font_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../../../../../core/router/app_navigator.dart';
// import '../widgets/legal_footer_text.dart'; // moved to core/ui/components (shared with features/auth)
import '../../../../../core/ui/components/legal_footer_text.dart';
import '../widgets/auth_backdrop.dart';

/// First auth-choice screen — sits between the intro carousel and the
/// email/password [LoginScreen]. Google/Apple are UI-only stand-ins (no
/// OAuth wired up yet); only "Continue with email" actually navigates.
class WelcomeScreen extends ConsumerWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: AuthBackdrop(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // TODO(i18n): wire a real language picker.
                  const _GhostPill(icon: Icons.language, label: 'English'),
                  _GhostIcon(icon: Icons.help_outline, onTap: () {}),
                ],
              ),
            ),
            SizedBox(height: 20.h),

            BrandLogo(width: 175.w),
            const Spacer(flex: 4),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                children: [
                  _SocialButton(
                    label: 'Continue with Google',
                    // TODO(auth): wire google_sign_in once backend exists;
                    // for now just take the user to the post-signup screen.
                    onPressed: () =>
                        ref.read(appNavigatorProvider).toGetStarted(),
                    leading: Image.asset(
                      Assets.images.googleIcon,
                      height: 24.h,
                      width: 24.w,
                    ),
                  ),
                  SizedBox(height: 18.h),
                  _SocialButton(
                    label: 'Continue with Apple',
                    // TODO(auth): wire Sign in with Apple once backend exists;
                    // for now just take the user to the post-signup screen.
                    onPressed: () =>
                        ref.read(appNavigatorProvider).toGetStarted(),
                    leading: Image.asset(
                      Assets.images.appleIcon,
                      height: 24.h,
                      width: 24.w,
                    ),
                  ),
                  SizedBox(height: 18.h),
                  SizedBox(
                    width: double.infinity,
                    height: 52.h,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.white70),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                      ),
                      onPressed: () => ref.read(appNavigatorProvider).toLogin(),
                      child: Text(
                        'Continue with email',
                        style:
                            TextFontStyle.headline15w600textWhiteStyleSatoshi,
                      ),
                    ),
                  ),
                  SizedBox(height: 46.h),
                  const LegalFooterText(
                    light: true,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16.h),
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
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52.h,
      child: FilledButton(
        style: FilledButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14.r),
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
                  style: TextFontStyle.headline15w600StyleSatoshi,
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
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 18.r),
          SizedBox(width: 6.w),
          Text(label, style: TextFontStyle.headline14w400textWhiteStyleSatoshi),
        ],
      ),
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
      child: Container(
        padding: EdgeInsets.all(8.r),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.3),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 18.r),
      ),
    );
  }
}
