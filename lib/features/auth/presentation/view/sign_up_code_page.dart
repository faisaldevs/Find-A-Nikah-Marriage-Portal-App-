import 'dart:async';

import 'package:find_a_nikah/core/ui/ui.dart';
import 'package:find_a_nikah/features/auth/domain/domain.dart';
import 'package:find_a_nikah/features/auth/presentation/bloc/sign_up_bloc.dart';
import 'package:find_a_nikah/features/auth/presentation/widgets/auth_step_scaffold.dart';
import 'package:find_a_nikah/router/route_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:go_router/go_router.dart';

const int _codeLength = CredentialsPolicy.codeLength;
const _resendSeconds = 60;

/// Second step of the sign-up sub-flow: the emailed one-time code.
class SignUpCodePage extends StatefulWidget {
  const SignUpCodePage({super.key});

  @override
  State<SignUpCodePage> createState() => _SignUpCodePageState();
}

class _SignUpCodePageState extends State<SignUpCodePage> {
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
  bool _isResending = false;

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

  String get _code => _controllers.map((c) => c.text.trim()).join();

  void _resend() {
    setState(() => _isResending = true);
    context.read<SignUpBloc>().add(const SignUpCodeResendRequested());
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<SignUpBloc>().state;
    final busy = state.status == SignUpStatus.submitting;
    return BlocListener<SignUpBloc, SignUpState>(
      listenWhen: (prev, next) =>
          prev.status != next.status &&
          (next.operation == SignUpOperation.verifyCode ||
              next.operation == SignUpOperation.resendCode),
      listener: (context, state) {
        switch (state.status) {
          case SignUpStatus.emailVerified
              when state.operation == SignUpOperation.verifyCode:
            CustomToast.showSuccess(
              context,
              'Email verified successfully',
            );
            context.push<void>(RoutePaths.createPassword);
          case SignUpStatus.failure
              when state.operation == SignUpOperation.verifyCode ||
                  state.operation == SignUpOperation.resendCode:
            _isResending = false;
            showFailureToast(context, state.failure!);
          case SignUpStatus.idle
              when state.operation == SignUpOperation.resendCode:
            _isResending = false;
            _startCountdown();
            CustomToast.showSuccess(
              context,
              'Verification code sent to your email',
            );
          case SignUpStatus.submitting ||
              SignUpStatus.codeSent ||
              SignUpStatus.emailVerified ||
              SignUpStatus.failure ||
              SignUpStatus.idle ||
              SignUpStatus.registered:
            break;
        }
      },
      child: AuthStepScaffold(
        title: 'Enter verification code',
        // Figma's 100pt is title → underline; the digit box above each
        // underline is ~43pt tall, so the gap to the box is 57.
        bodyGap: 57,
        isLoading: busy,
        loadingLabel: _isResending ? 'Sending code...' : 'Verifying...',
        onContinue: _isComplete && !busy
            ? () => context.read<SignUpBloc>().add(SignUpCodeSubmitted(_code))
            : null,
        body: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(_codeLength, (i) {
                return SizedBox(
                  // width: 42.w,
                  width: 40.w,
                  child: TextField(
                    controller: _controllers[i],
                    focusNode: _focusNodes[i],
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    maxLength: 1,
                    // style: TextFontStyle.headline22w400textDarkStyleSatoshi,
                    style: figmaText(22, 28.6),
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onChanged: (value) => _onDigitChanged(i, value),
                    decoration: const InputDecoration(
                      counterText: '',
                      // enabledBorder: UnderlineInputBorder(
                      //   borderSide: BorderSide(color: AppColors.textMuted),
                      // ),
                      // Figma 883:6085: 40pt #D4D4D4 rules.
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFD4D4D4)),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: AppColors.primaryColor),
                      ),
                    ),
                  ),
                );
              }),
            ),
            // SizedBox(height: 20.h),
            SizedBox(height: 24.h),
            if (_secondsLeft > 0)
              Text(
                'You can request a new code in $_secondsLeft seconds',
                // style: TextFontStyle.headline13w400textMutedStyleSatoshi,
                textAlign: TextAlign.center,
                style: figmaText(15, 21, color: const Color(0xFF737373)),
              )
            else
              GestureDetector(
                onTap: busy ? null : _resend,
                child: Text(
                  _isResending ? 'Sending code...' : 'Resend code',
                  // style: busy
                  //     ? TextFontStyle.headline13w400textMutedStyleSatoshi
                  //     : TextFontStyle.headline13w600primaryColorStyleSatoshi,
                  style: figmaText(
                    15,
                    21,
                    weight: busy ? FontWeight.w400 : FontWeight.w500,
                    color: busy
                        ? const Color(0xFF737373)
                        : AppColors.primaryColor,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
