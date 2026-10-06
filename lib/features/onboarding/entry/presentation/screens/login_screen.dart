import 'package:find_a_nikah/gen/assets.gen.dart';
import 'package:find_a_nikah/core/constants/text_font_style.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../../../../../core/router/app_navigator.dart';
// import '../widgets/app_primary_button.dart'; // moved to core/ui/components (shared with features/auth)
import '../../../../../core/ui/components/app_primary_button.dart';
import '../../../widgets/app_text_field.dart';
import '../widgets/auth_backdrop.dart';

/// Email/password sign-in — reached from [WelcomeScreen]'s "Continue with
/// email". No backend exists yet, so Sign In / Forgot password / social
/// buttons / Sign up now are UI-only for now; only the password-visibility
/// toggle is functional (pure local state, no network involved).
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  late final _signUpRecognizer = TapGestureRecognizer()
    ..onTap = () => ref.read(appNavigatorProvider).toEmailAddress();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _signUpRecognizer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The background photo must never resize/stretch when the keyboard
      // opens — let the SingleChildScrollView below handle keyboard avoidance
      // instead of the whole body shrinking (which squished the image).
      resizeToAvoidBottomInset: false,
      body: AuthBackdrop(
        child: LayoutBuilder(
          builder: (context, constraints) {
            // resizeToAvoidBottomInset is off (see above), so the scroll
            // view has to make its own room for the keyboard instead of
            // Scaffold doing it — otherwise fields near the bottom end up
            // hidden behind the keyboard with no way to scroll to them.
            final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
            return SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, keyboardHeight),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        SizedBox(height: 48.h),
                        BrandLogo(width: 172.w),
                        SizedBox(height: 32.h),
                      ],
                    ),
                    Column(
                      children: [
                        AppTextField(
                          controller: _emailController,
                          hint: 'Enter your email',
                          icon: Icons.mail_outline,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        SizedBox(height: 14.h),
                        AppTextField(
                          controller: _passwordController,
                          hint: 'Enter your password',
                          icon: Icons.lock_outline,
                          obscureText: _obscurePassword,
                          trailing: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              color: Colors.black45,
                              size: 20.r,
                            ),
                            onPressed: () => setState(
                              () => _obscurePassword = !_obscurePassword,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            // TODO(auth): wire password-reset once backend exists.
                            onPressed: () {},
                            child: Text(
                              'Forgot Password?',
                              style: TextFontStyle
                                  .headline14w500textWhiteStyleSatoshi,
                            ),
                          ),
                        ),
                        SizedBox(height: 8.h),
                        AppPrimaryButton(
                          label: 'Sign In',
                          height: 52.h,
                          borderRadius: 14.r,
                          // TODO(auth): wire real sign-in once backend exists.
                          onPressed: () {},
                        ),
                        SizedBox(height: 20.h),
                        Row(
                          children: [
                            const Expanded(
                              child: Divider(color: Colors.white38),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12.w),
                              child: Text(
                                'or continue with',
                                style: TextFontStyle
                                    .headline13w400white70StyleSatoshi,
                              ),
                            ),
                            const Expanded(
                              child: Divider(color: Colors.white38),
                            ),
                          ],
                        ),
                        SizedBox(height: 20.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _CircleSocialButton(
                              // TODO(auth): wire google_sign_in once backend
                              // exists; for now just go to the post-signup screen.
                              onTap: () =>
                                  ref.read(appNavigatorProvider).toGetStarted(),
                              child: Image.asset(
                                Assets.images.googleIcon,
                                height: 24.h,
                                width: 24.w,
                              ),
                            ),
                            SizedBox(width: 16.w),
                            _CircleSocialButton(
                              // TODO(auth): wire Sign in with Apple once
                              // backend exists; for now just go to the
                              // post-signup screen.
                              onTap: () =>
                                  ref.read(appNavigatorProvider).toGetStarted(),
                              child: Image.asset(
                                Assets.images.appleIcon,
                                height: 24.h,
                                width: 24.w,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 28.h),
                        Text.rich(
                          TextSpan(
                            text: "Don't have an account? ",
                            style:
                                TextFontStyle.headline13w400white70StyleSatoshi,
                            children: [
                              TextSpan(
                                text: 'Sign up now',
                                style: TextFontStyle
                                    .headline13w700primaryColorStyleSatoshi,
                                recognizer: _signUpRecognizer,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 24.h),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _CircleSocialButton extends StatelessWidget {
  const _CircleSocialButton({required this.child, required this.onTap});

  final Widget child;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: Container(
        width: 48.r,
        height: 48.r,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: Center(child: child),
      ),
    );
  }
}
