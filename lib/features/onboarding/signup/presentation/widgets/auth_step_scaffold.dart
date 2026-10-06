import 'package:find_a_nikah/gen/colors.gen.dart';
import 'package:find_a_nikah/core/constants/text_font_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:go_router/go_router.dart';

// import 'app_primary_button.dart'; // moved to core/ui/components (shared with features/auth)
import '../../../../../core/ui/components/app_primary_button.dart';
// import 'legal_footer_text.dart'; // moved to core/ui/components (shared with features/auth)
import '../../../../../core/ui/components/legal_footer_text.dart';

/// Chrome shared by the sign-up sub-flow (email → verification code →
/// create password): back chevron, help icon, headline, optional subtitle,
/// a content slot, a pink Continue button, and the Terms/Privacy footer.
class AuthStepScaffold extends StatelessWidget {
  const AuthStepScaffold({
    super.key,
    required this.title,
    this.subtitle,
    required this.body,
    required this.onContinue,
    this.continueLabel = 'Continue',
    this.showLegalFooter = true,
  });

  final String title;
  final String? subtitle;
  final Widget body;
  final VoidCallback? onContinue;
  final String continueLabel;
  final bool showLegalFooter;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // Same fix as LoginScreen: let the scroll view make room for the
      // keyboard itself instead of Scaffold shrinking the whole body — with
      // resizeToAvoidBottomInset on, the fixed-height content (header +
      // title + body + button + footer) no longer fit in the reduced height
      // and overflowed once the keyboard opened.
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
            return SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, keyboardHeight),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 8.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              padding: EdgeInsets.zero,
                              onPressed: () => context.pop(),
                              icon: Icon(
                                Icons.arrow_back,
                                color: AppColors.textDark,
                                size: 24.r,
                              ),
                            ),
                            Container(
                              width: 32.r,
                              height: 32.r,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: AppColors.textMuted),
                              ),
                              child: Icon(
                                Icons.help_outline,
                                size: 18.r,
                                color: AppColors.textDark,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 24.h),
                        Text(
                          title,
                          style: TextFontStyle
                              .headline26w700textDarkStyleSatoshi
                              .copyWith(height: 1.2),
                        ),
                        if (subtitle != null) ...[
                          SizedBox(height: 10.h),
                          Text(
                            subtitle!,
                            style: TextFontStyle
                                .headline14w400textMutedStyleSatoshi
                                .copyWith(height: 1.4),
                          ),
                        ],
                        SizedBox(height: 28.h),
                        body,
                      ],
                    ),
                    Column(
                      children: [
                        SizedBox(height: 28.h),
                        AppPrimaryButton(
                          label: continueLabel,
                          onPressed: onContinue,
                        ),
                        if (showLegalFooter) ...[
                          SizedBox(height: 14.h),
                          const LegalFooterText(),
                        ],
                        SizedBox(height: 20.h),
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
