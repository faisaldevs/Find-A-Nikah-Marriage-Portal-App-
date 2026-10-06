import 'package:find_a_nikah/gen/colors.gen.dart';
import 'package:find_a_nikah/core/constants/text_font_style.dart';
import 'package:flutter/material.dart';

/// Small print under the "Verify photo" button, per the reference mockup.
/// Vendor name is a placeholder until the server-side matching provider is
/// chosen (see `SelfieFaceChecker` doc comment).
class VerificationLegalFooter extends StatelessWidget {
  const VerificationLegalFooter({super.key, this.vendorName = 'this company'});

  final String vendorName;

  @override
  Widget build(BuildContext context) {
    final linkStyle = TextFontStyle.headline11w400textMutedStyleSatoshi
        .copyWith(
          height: 1.4,
          color: AppColors.primaryColor,
          decoration: TextDecoration.underline,
          decorationColor: AppColors.primaryColor,
        );
    return Text.rich(
      TextSpan(
        text:
            'Our verification services are powered by $vendorName and by '
            'continuing you agree to our ',
        style: TextFontStyle.headline11w400textMutedStyleSatoshi.copyWith(
          height: 1.4,
        ),
        children: [
          TextSpan(text: 'Terms', style: linkStyle),
          const TextSpan(text: ' and '),
          TextSpan(text: 'Privacy Policy', style: linkStyle),
          const TextSpan(text: '.'),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }
}
