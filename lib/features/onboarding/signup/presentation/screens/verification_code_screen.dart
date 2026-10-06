import 'dart:async';
import 'package:find_a_nikah/core/constants/text_font_style.dart';

import 'package:find_a_nikah/gen/colors.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../../../../../core/router/app_navigator.dart';
import '../widgets/auth_step_scaffold.dart';

const _codeLength = 6;
const _resendSeconds = 60;

/// Second step of the sign-up sub-flow. No backend exists yet — any 6
/// digits are accepted, and "resend" just restarts the local countdown.
class VerificationCodeScreen extends ConsumerStatefulWidget {
  const VerificationCodeScreen({super.key});

  @override
  ConsumerState<VerificationCodeScreen> createState() =>
      _VerificationCodeScreenState();
}

class _VerificationCodeScreenState
    extends ConsumerState<VerificationCodeScreen> {
  final _controllers = List.generate(
    _codeLength,
    (_) => TextEditingController(),
  );
  final _focusNodes = List.generate(_codeLength, (_) => FocusNode());
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

  @override
  Widget build(BuildContext context) {
    return AuthStepScaffold(
      title: 'Enter verification code',
      onContinue: _isComplete
          ? () => ref.read(appNavigatorProvider).toCreatePassword()
          : null,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
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
                  style: TextFontStyle.headline22w400textDarkStyleSatoshi,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onChanged: (value) => _onDigitChanged(i, value),
                  decoration: const InputDecoration(
                    counterText: '',
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColors.textMuted),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColors.primaryColor),
                    ),
                  ),
                ),
              );
            }),
          ),
          SizedBox(height: 20.h),
          _secondsLeft > 0
              ? Text(
                  'You can request a new code in $_secondsLeft seconds',
                  style: TextFontStyle.headline13w400textMutedStyleSatoshi,
                )
              : GestureDetector(
                  onTap: _startCountdown,
                  child: Text(
                    'Resend code',
                    style: TextFontStyle.headline13w600primaryColorStyleSatoshi,
                  ),
                ),
        ],
      ),
    );
  }
}
