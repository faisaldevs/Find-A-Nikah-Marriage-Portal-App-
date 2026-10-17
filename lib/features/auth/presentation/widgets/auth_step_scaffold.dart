import 'package:find_a_nikah/core/ui/ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:go_router/go_router.dart';

/// Chrome shared by the sign-up sub-flow (email → verification code →
/// create password): back chevron, help icon, headline, optional subtitle,
/// a content slot, a pink Continue button, and the Terms/Privacy footer.
class AuthStepScaffold extends StatelessWidget {
  const AuthStepScaffold({
    required this.title,
    required this.body,
    required this.onContinue,
    super.key,
    this.subtitle,
    this.continueLabel = 'Continue',
    this.isLoading = false,
    this.loadingLabel = 'Please wait...',
    this.showLegalFooter = true,
    this.titleSize = 28,
    this.bodyGap = 40,
  });

  final String title;
  final String? subtitle;
  final Widget body;
  final VoidCallback? onContinue;
  final String continueLabel;
  final bool isLoading;
  final String loadingLabel;
  final bool showLegalFooter;

  /// Figma title size: 30 on the email step, 28 on the others.
  final double titleSize;

  /// Gap between the title block and [body] (Figma: 40 email, 100 code,
  /// 60 password).
  final double bodyGap;

  static const _ink = Color(0xFF0A0A0A);
  static const _grey500 = Color(0xFF737373);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // Same fix as LoginPage: let the scroll view make room for the
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
              // padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, keyboardHeight),
              padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, keyboardHeight),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // SizedBox(height: 8.h),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   children: [
                        //     IconButton(
                        //       padding: EdgeInsets.zero,
                        //       onPressed: () => context.pop(),
                        //       icon: Icon(
                        //         Icons.arrow_back,
                        //         color: AppColors.textDark,
                        //         size: 24.r,
                        //       ),
                        //     ),
                        //     Container(
                        //       width: 32.r,
                        //       height: 32.r,
                        //       decoration: BoxDecoration(
                        //         shape: BoxShape.circle,
                        //         border:
                        //             Border.all(color: AppColors.textMuted),
                        //       ),
                        //       child: Icon(
                        //         Icons.help_outline,
                        //         size: 18.r,
                        //         color: AppColors.textDark,
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        // SizedBox(height: 24.h),
                        // Text(
                        //   title,
                        //   style: TextFontStyle
                        //       .headline26w700textDarkStyleSatoshi
                        //       .copyWith(height: 1.2),
                        // ),
                        // if (subtitle != null) ...[
                        //   SizedBox(height: 10.h),
                        //   Text(
                        //     subtitle!,
                        //     style: TextFontStyle
                        //         .headline14w400textMutedStyleSatoshi
                        //         .copyWith(height: 1.4),
                        //   ),
                        // ],
                        // SizedBox(height: 28.h),
                        // Figma 883:6033: plain 20pt back arrow + 18pt (?) —
                        // no outlined circle — 40pt above a centred Medium
                        // 30 title and grey 15pt subtitle, 40pt to the body.
                        SizedBox(height: 16.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () => context.pop(),
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 4.h),
                                child: Icon(
                                  Icons.arrow_back,
                                  color: _ink,
                                  size: 20.r,
                                ),
                              ),
                            ),
                            Icon(Icons.help_outline, size: 18.r, color: _ink),
                          ],
                        ),
                        SizedBox(height: 40.h),
                        SizedBox(
                          width: double.infinity,
                          child: Text(
                            title,
                            textAlign: TextAlign.center,
                            style: figmaText(
                              titleSize,
                              titleSize * 1.3,
                              weight: FontWeight.w500,
                            ),
                          ),
                        ),
                        if (subtitle != null) ...[
                          SizedBox(height: 10.h),
                          SizedBox(
                            width: double.infinity,
                            child: Text(
                              subtitle!,
                              textAlign: TextAlign.center,
                              style: figmaText(15, 21, color: _grey500),
                            ),
                          ),
                        ],
                        SizedBox(height: bodyGap.h),
                        body,
                      ],
                    ),
                    Column(
                      children: [
                        SizedBox(height: 28.h),
                        // AppPrimaryButton(
                        //   label: continueLabel,
                        //   onPressed: onContinue,
                        //   isLoading: isLoading,
                        //   loadingLabel: loadingLabel,
                        // ),
                        // if (showLegalFooter) ...[
                        //   SizedBox(height: 14.h),
                        //   const LegalFooterText(),
                        // ],
                        // Figma: 48pt / 8pt-radius button, Medium 18 label;
                        // footer 20pt padding above and below.
                        AppPrimaryButton(
                          label: continueLabel,
                          onPressed: onContinue,
                          isLoading: isLoading,
                          loadingLabel: loadingLabel,
                          height: 48.h,
                          borderRadius: 8.r,
                          labelStyle: figmaText(
                            18,
                            23.4,
                            weight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                        if (showLegalFooter) ...[
                          SizedBox(height: 20.h),
                          const LegalFooterText(textAlign: TextAlign.center),
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
