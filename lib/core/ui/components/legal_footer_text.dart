import 'package:find_a_nikah/core/ui/theme/figma_text.dart';
import 'package:flutter/material.dart';

/// "By continuing you agree to our Terms and Privacy Policy" footer shown
/// on the welcome screen and every sign-up step. [light] switches
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
    // final baseColor = light ? Colors.white70 : AppColors.textMuted;
    // Figma (welcome): plain white 14pt, line height 1.75, over the photo.
    // final baseColor = light ? Colors.white : AppColors.textMuted;
    final baseColor = light ? Colors.white : const Color(0xFF737373);
    // final linkColor = light ? Colors.white : AppColors.textDark;
    // Figma (sign-up steps): links stay the same grey as the sentence, just
    // underlined; 14pt, line height 1.75 like the light variant.
    final linkColor = light ? Colors.white : const Color(0xFF737373);
    // final baseStyle = light
    //     ? TextFontStyle.headline14w400textWhiteStyleSatoshi.copyWith(
    //         height: 1.75,
    //       )
    //     // : TextFontStyle.headline12w400textMutedStyleSatoshi;
    //     : TextFontStyle.headline14w400textMutedStyleSatoshi.copyWith(
    //         color: const Color(0xFF737373),
    //         height: 1.75,
    //       );
    // figmaText keeps Satoshi at Figma's width so the line fits on one row.
    final baseStyle = figmaText(14, 24.5, color: baseColor);
    return Text.rich(
      TextSpan(
        text: 'By continuing you agree to our ',
        style: baseStyle.copyWith(color: baseColor),
        children: [
          TextSpan(
            text: 'Terms',
            style: baseStyle.copyWith(
              decoration: TextDecoration.underline,
              decorationColor: linkColor,
              color: linkColor,
            ),
          ),
          const TextSpan(text: ' and '),
          TextSpan(
            text: 'Privacy Policy',
            style: baseStyle.copyWith(
              decoration: TextDecoration.underline,
              decorationColor: linkColor,
              color: linkColor,
            ),
          ),
        ],
      ),
      textAlign: textAlign,
    );
  }
}
