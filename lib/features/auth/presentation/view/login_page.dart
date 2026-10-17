import 'package:find_a_nikah/app/di.dart';
import 'package:find_a_nikah/core/ui/ui.dart';
import 'package:find_a_nikah/features/auth/domain/domain.dart';
import 'package:find_a_nikah/features/auth/presentation/bloc/sign_in_bloc.dart';
import 'package:find_a_nikah/features/auth/presentation/presentation.dart'
    show WelcomePage;
import 'package:find_a_nikah/features/auth/presentation/view/welcome_page.dart'
    show WelcomePage;
import 'package:find_a_nikah/features/auth/presentation/widgets/app_text_field.dart';
import 'package:find_a_nikah/features/auth/presentation/widgets/auth_backdrop.dart';
import 'package:find_a_nikah/gen/assets.gen.dart';
import 'package:find_a_nikah/router/route_paths.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:go_router/go_router.dart';

/// Email/password sign-in — reached from [WelcomePage]'s "Continue with
/// email". On success the auth status changes and the router moves on.
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

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
        child: const _LoginView(),
      ),
    );
  }
}

class _LoginView extends StatefulWidget {
  const _LoginView();

  @override
  State<_LoginView> createState() => _LoginPageState();
}

class _LoginPageState extends State<_LoginView> {
  // Hard-coded dev credentials shipped in every build type (audit #6).
  // final _emailController = TextEditingController(text: 'user@gmail.com');
  // final _passwordController = TextEditingController(text: '12345678');
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  late final _signUpRecognizer = TapGestureRecognizer()
    ..onTap = () => context.push<void>(RoutePaths.signUpEmail).ignore();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _signUpRecognizer.dispose();
    super.dispose();
  }

  void _submit() => context.read<SignInBloc>().add(
    SignInEmailSubmitted(
      email: _emailController.text,
      password: _passwordController.text,
    ),
  );

  void _social(SocialProvider provider) =>
      context.read<SignInBloc>().add(SignInSocialRequested(provider));

  @override
  Widget build(BuildContext context) {
    final busy = context.select<SignInBloc, bool>(
      (b) => b.state.status == SignInStatus.submitting,
    );
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
                //   child: Column(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       Column(
                //         children: [
                //           SizedBox(height: 48.h),
                //           BrandLogo(width: 172.w),
                //           SizedBox(height: 32.h),
                //         ],
                //       ),
                //       Column(
                //         children: [
                //           AppTextField(
                //             controller: _emailController,
                //             hint: 'Enter your email',
                //             icon: Icons.mail_outline,
                //             keyboardType: TextInputType.emailAddress,
                //           ),
                //           SizedBox(height: 14.h),
                //           AppTextField(
                //             controller: _passwordController,
                //             hint: 'Enter your password',
                //             icon: Icons.lock_outline,
                //             obscureText: _obscurePassword,
                //             trailing: IconButton(
                //               icon: Icon(
                //                 _obscurePassword
                //                     ? Icons.visibility_outlined
                //                     : Icons.visibility_off_outlined,
                //                 color: Colors.black45,
                //                 size: 20.r,
                //               ),
                //               onPressed: () => setState(
                //                 () => _obscurePassword = !_obscurePassword,
                //               ),
                //             ),
                //           ),
                //           Align(
                //             alignment: Alignment.centerRight,
                //             child: TextButton(
                //               // TODO(auth): password reset.
                //               onPressed: () {},
                //               child: Text(
                //                 'Forgot Password?',
                //                 style: TextFontStyle
                //                     .headline14w500textWhiteStyleSatoshi,
                //               ),
                //             ),
                //           ),
                //           SizedBox(height: 8.h),
                //           AppPrimaryButton(
                //             label: 'Sign In',
                //             height: 52.h,
                //             borderRadius: 14.r,
                //             isLoading: busy,
                //             loadingLabel: 'Signing in...',
                //             onPressed: _submit,
                //           ),
                //           SizedBox(height: 20.h),
                //           Row(
                //             children: [
                //               const Expanded(
                //                 child: Divider(color: Colors.white38),
                //               ),
                //               Padding(
                //                 padding:
                //                     EdgeInsets.symmetric(horizontal: 12.w),
                //                 child: Text(
                //                   'or continue with',
                //                   style: TextFontStyle
                //                       .headline13w400white70StyleSatoshi,
                //                 ),
                //               ),
                //               const Expanded(
                //                 child: Divider(color: Colors.white38),
                //               ),
                //             ],
                //           ),
                //           SizedBox(height: 20.h),
                //           Row(
                //             mainAxisAlignment: MainAxisAlignment.center,
                //             children: [
                //               _CircleSocialButton(
                //                 onTap: busy
                //                     ? null
                //                     : () => _social(SocialProvider.google),
                //                 child: Image.asset(
                //                   Assets.images.googleIcon,
                //                   height: 24.h,
                //                   width: 24.w,
                //                 ),
                //               ),
                //               SizedBox(width: 16.w),
                //               _CircleSocialButton(
                //                 onTap: busy
                //                     ? null
                //                     : () => _social(SocialProvider.apple),
                //                 child: Image.asset(
                //                   Assets.images.appleIcon,
                //                   height: 24.h,
                //                   width: 24.w,
                //                 ),
                //               ),
                //             ],
                //           ),
                //           SizedBox(height: 28.h),
                //           Text.rich(
                //             TextSpan(
                //               text: "Don't have an account? ",
                //               style:
                //                   TextFontStyle
                //                       .headline13w400white70StyleSatoshi,
                //               children: [
                //                 TextSpan(
                //                   text: 'Sign up now',
                //                   style: TextFontStyle
                //                 .headline13w700primaryColorStyleSatoshi,
                //                   recognizer: _signUpRecognizer,
                //                 ),
                //               ],
                //             ),
                //           ),
                //           SizedBox(height: 24.h),
                //         ],
                //       ),
                //     ],
                //   ),
                // ),
                // Figma 883:3856: logo 102pt below the status bar, form 90pt
                // under it (fields 24 apart, Sign In 32 below "Forgot", 40 to
                // the divider, 40 to the social row), footer 20pt off the
                // bottom.
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        SizedBox(height: 102.h),
                        BrandLogo(width: 172.w),
                        SizedBox(height: 90.h),
                        AppTextField(
                          controller: _emailController,
                          hint: 'Enter your email',
                          icon: Icons.mail_outline,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        SizedBox(height: 24.h),
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
                              color: AppColors.greyColor,
                              size: 20.r,
                            ),
                            onPressed: () => setState(
                              () => _obscurePassword = !_obscurePassword,
                            ),
                          ),
                        ),
                        SizedBox(height: 14.h),
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            // TODO(auth): password reset.
                            onTap: () {},
                            child: Text(
                              'Forgot Password?',
                              style: TextFontStyle
                                  .headline14w500textWhiteStyleSatoshi
                                  .copyWith(height: 1.3),
                            ),
                          ),
                        ),
                        SizedBox(height: 32.h),
                        AppPrimaryButton(
                          label: 'Sign In',
                          height: 48.h,
                          borderRadius: 8.r,
                          isLoading: busy,
                          loadingLabel: 'Signing in...',
                          onPressed: _submit,
                        ),
                        SizedBox(height: 40.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 70.w,
                              height: 1,
                              color: Colors.white,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10.w),
                              child: Text(
                                'or continue with',
                                style: TextFontStyle
                                    .headline16w500textWhiteStyleSatoshi,
                              ),
                            ),
                            Container(
                              width: 70.w,
                              height: 1,
                              color: Colors.white,
                            ),
                          ],
                        ),
                        SizedBox(height: 40.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _CircleSocialButton(
                              onTap: busy
                                  ? null
                                  : () => _social(SocialProvider.google),
                              child: Image.asset(
                                Assets.images.googleIcon,
                                height: 30.r,
                                width: 30.r,
                              ),
                            ),
                            SizedBox(width: 14.w),
                            _CircleSocialButton(
                              onTap: busy
                                  ? null
                                  : () => _social(SocialProvider.apple),
                              child: Image.asset(
                                Assets.images.appleIcon,
                                height: 31.5.r,
                                width: 31.5.r,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 24.h),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 20.h),
                      child: Text.rich(
                        TextSpan(
                          text: "Don't have an account? ",
                          style: TextFontStyle
                              .headline14w400textWhiteStyleSatoshi
                              .copyWith(height: 1.75),
                          children: [
                            TextSpan(
                              text: 'Sign up now',
                              style: TextFontStyle
                                  .headline14w500textWhiteStyleSatoshi
                                  .copyWith(
                                    color: AppColors.errorColor,
                                    height: 1.75,
                                  ),
                              recognizer: _signUpRecognizer,
                            ),
                          ],
                        ),
                      ),
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
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      // child: Container(
      //   width: 48.r,
      //   height: 48.r,
      //   decoration: const BoxDecoration(
      //     color: Colors.white,
      //     shape: BoxShape.circle,
      //   ),
      //   child: Center(child: child),
      // ),
      // Figma 883:3910: 57pt white circle, 0.5px #E5E7EB border.
      child: Container(
        width: 57.r,
        height: 57.r,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFFE5E7EB), width: 0.5),
        ),
        child: Center(child: child),
      ),
    );
  }
}
