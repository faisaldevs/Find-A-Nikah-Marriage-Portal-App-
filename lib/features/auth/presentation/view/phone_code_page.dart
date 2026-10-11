import 'dart:async';

import 'package:find_a_nikah/core/ui/ui.dart';
import 'package:find_a_nikah/features/auth/domain/domain.dart';
import 'package:find_a_nikah/features/auth/presentation/bloc/phone_verification_bloc.dart';
import 'package:find_a_nikah/features/auth/presentation/presentation.dart'
    show SignUpCodePage;
import 'package:find_a_nikah/features/auth/presentation/view/sign_up_code_page.dart'
    show SignUpCodePage;
import 'package:find_a_nikah/router/route_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:go_router/go_router.dart';

const int _codeLength = CredentialsPolicy.codeLength;
const _resendSeconds = 60;

/// WhatsApp OTP step of the Verification part (the email code at sign-up is
/// [SignUpCodePage]).
class PhoneCodePage extends StatefulWidget {
  const PhoneCodePage({super.key});

  @override
  State<PhoneCodePage> createState() => _PhoneCodePageState();
}

class _PhoneCodePageState extends State<PhoneCodePage> {
  final List<TextEditingController> _controllers = List.generate(
    _codeLength,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(
    _codeLength,
    (_) => FocusNode(),
  );
  int _secondsLeft = _resendSeconds;
  Timer? _timer;

  bool get _isComplete => _controllers.every((c) => c.text.trim().isNotEmpty);

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    _timer?.cancel();
    setState(() => _secondsLeft = _resendSeconds);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft <= 1) {
        timer.cancel();
        setState(() => _secondsLeft = 0);
      } else {
        setState(() => _secondsLeft -= 1);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _onDigitChanged(int index, String value) {
    if (value.isNotEmpty && index < _codeLength - 1) {
      _focusNodes[index + 1].requestFocus();
    }
    if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
    setState(() {});
  }

  // ignore: unused_element — only used by the commented-out API call below.
  String get _code => _controllers.map((c) => c.text.trim()).join();

  void _submit() {
    // TODO(phone-api): no phone verification API yet — skip straight to
    // photos. Re-enable once it exists.
    // context.read<PhoneVerificationBloc>().add(PhoneCodeSubmitted(_code));
    context.push<void>(RoutePaths.addPhotos).ignore();
  }

  void _resend() {
    context.read<PhoneVerificationBloc>().add(const PhoneCodeResendRequested());
    _startCountdown();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<PhoneVerificationBloc>().state;
    final phone = state.phoneNumber;
    final busy = state.status == PhoneVerificationStatus.submitting;
    return BlocListener<PhoneVerificationBloc, PhoneVerificationState>(
      listenWhen: (prev, next) => prev.status != next.status,
      listener: (context, state) => switch (state.status) {
        // Phone verified → profile photos (then face verification).
        PhoneVerificationStatus.verified => context.push<void>(
          RoutePaths.addPhotos,
        ),
        PhoneVerificationStatus.failure => showFailureToast(
          context,
          state.failure!,
        ),
        _ => null,
      },
      child: WizardScaffold(
        onContinue: _isComplete && !busy ? _submit : null,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            WizardHeadline(
              text: 'Enter verification code',
              subtitle: 'Enter the 6-digit code sent to $phone via WhatsApp.',
            ),
            SizedBox(height: 28.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(_codeLength, (i) {
                      return SizedBox(
                        width: 42.w,
                        child: TextField(
                          controller: _controllers[i],
                          focusNode: _focusNodes[i],
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          maxLength: 1,
                          style:
                              TextFontStyle.headline22w400textDarkStyleSatoshi,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          onChanged: (value) => _onDigitChanged(i, value),
                          decoration: const InputDecoration(
                            counterText: '',
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: AppColors.textMuted,
                              ),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: AppColors.primaryColor,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                  SizedBox(height: 20.h),
                  if (_secondsLeft > 0)
                    Text(
                      'You can request a new code in $_secondsLeft seconds',
                      style: TextFontStyle.headline13w400textMutedStyleSatoshi,
                    )
                  else
                    GestureDetector(
                      onTap: _resend,
                      child: Text(
                        'Resend code',
                        style: TextFontStyle
                            .headline13w600primaryColorStyleSatoshi,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
    // Previously a standalone AuthStepScaffold page (big title, no progress
    // bar). Moved into the onboarding wizard shell so it shares the
    // persistent header + progress bar.
    // return AuthStepScaffold(
    //   title: 'Enter verification code',
    //   subtitle: 'Enter the 6-digit code sent to $phone via WhatsApp.',
    //   showLegalFooter: false,
    //   onContinue: _isComplete ? _next : null,
    //   // onContinue: _isComplete   // superseded: face verification now sits between OTP and discovery
    //   //     ? () => context.push<void>(RoutePaths.discovery)
    //   //     : null,
    //   body: Column(
    //     crossAxisAlignment: CrossAxisAlignment.center,
    //     children: [
    //       Row(
    //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //         children: List.generate(_codeLength, (i) {
    //           return SizedBox(
    //             width: 42.w,
    //             child: TextField(
    //               controller: _controllers[i],
    //               focusNode: _focusNodes[i],
    //               textAlign: TextAlign.center,
    //               keyboardType: TextInputType.number,
    //               maxLength: 1,
    //               style: TextFontStyle.headline22w400textDarkStyleSatoshi,
    //               inputFormatters: [FilteringTextInputFormatter.digitsOnly],
    //               onChanged: (value) => _onDigitChanged(i, value),
    //               decoration: const InputDecoration(
    //                 counterText: '',
    //                 enabledBorder: UnderlineInputBorder(
    //                   borderSide: BorderSide(color: AppColors.textMuted),
    //                 ),
    //                 focusedBorder: UnderlineInputBorder(
    //                   borderSide: BorderSide(color: AppColors.primaryColor),
    //                 ),
    //               ),
    //             ),
    //           );
    //         }),
    //       ),
    //       SizedBox(height: 20.h),
    //       _secondsLeft > 0
    //           ? Text(
    //               'You can request a new code in $_secondsLeft seconds',
    //               style: TextFontStyle.headline13w400textMutedStyleSatoshi,
    //             )
    //           : GestureDetector(
    //               onTap: _startCountdown,
    //               child: Text(
    //                 'Resend code',
    //                 style: TextFontStyle
    //                     .headline13w600primaryColorStyleSatoshi,
    //               ),
    //             ),
    //     ],
    //   ),
    //     );
  }
}
