import 'package:find_a_nikah/gen/colors.gen.dart';
import 'package:find_a_nikah/core/constants/text_font_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/router/app_navigator.dart';
import '../widgets/auth_step_scaffold.dart';

/// First step of the sign-up sub-flow, reached from [LoginScreen]'s
/// "Sign up now". No backend exists yet — the email is only used to decide
/// whether Continue is enabled, never sent anywhere.
class EmailAddressScreen extends ConsumerStatefulWidget {
  const EmailAddressScreen({super.key});

  @override
  ConsumerState<EmailAddressScreen> createState() => _EmailAddressScreenState();
}

class _EmailAddressScreenState extends ConsumerState<EmailAddressScreen> {
  final _controller = TextEditingController();
  bool _looksValid = false;

  static final _emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    final valid = _emailPattern.hasMatch(value.trim());
    if (valid != _looksValid) setState(() => _looksValid = valid);
  }

  @override
  Widget build(BuildContext context) {
    return AuthStepScaffold(
      title: "What's your email address?",
      subtitle: "We'll email you a code to verify your identity.",
      onContinue: _looksValid
          ? () => ref.read(appNavigatorProvider).toVerificationCode()
          : null,
      body: TextField(
        controller: _controller,
        onChanged: _onChanged,
        keyboardType: TextInputType.emailAddress,
        style: TextFontStyle.headline16w400textDarkStyleSatoshi,
        decoration: InputDecoration(
          hintText: 'Email address',
          hintStyle: TextFontStyle.headline16w400textMutedStyleSatoshi,
          border: const UnderlineInputBorder(
            borderSide: BorderSide(color: AppColors.textMuted),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: AppColors.textMuted),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: AppColors.primaryColor),
          ),
        ),
      ),
    );
  }
}
