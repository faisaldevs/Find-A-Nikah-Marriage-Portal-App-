import 'package:find_a_nikah/gen/colors.gen.dart';
import 'package:find_a_nikah/core/constants/text_font_style.dart';
import 'package:flutter/material.dart';

/// "By continuing you agree to our Terms and Privacy Policy" footer shown
/// on [WelcomeScreen] and every [AuthStepScaffold] step. [light] switches
/// between white text (over a photo background) and dark text (on white).
class LegalFooterText extends StatelessWidget {
  const LegalFooterText({
    super.key,
    this.light = false,
    this.textAlign = TextAlign.start,
  });

  final bool light;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    final baseColor = light ? Colors.white70 : AppColors.textMuted;
    final linkColor = light ? Colors.white : AppColors.textDark;
    return Text.rich(
      TextSpan(
        text: 'By continuing you agree to our ',
        style: TextFontStyle.headline12w400textMutedStyleSatoshi.copyWith(
          color: baseColor,
        ),
        children: [
          TextSpan(
            text: 'Terms',
            style: TextFontStyle.headline12w400textMutedStyleSatoshi.copyWith(
              decoration: TextDecoration.underline,
              color: linkColor,
            ),
          ),
          const TextSpan(text: ' and '),
          TextSpan(
            text: 'Privacy Policy',
            style: TextFontStyle.headline12w400textMutedStyleSatoshi.copyWith(
              decoration: TextDecoration.underline,
              color: linkColor,
            ),
          ),
        ],
      ),
      textAlign: textAlign,
    );
  }
}
