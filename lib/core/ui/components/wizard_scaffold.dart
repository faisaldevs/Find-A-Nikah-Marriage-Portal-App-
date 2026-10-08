import 'package:find_a_nikah/core/ui/components/app_primary_button.dart';
import 'package:find_a_nikah/core/ui/components/wizard_progress_bar.dart';
import 'package:find_a_nikah/core/ui/components/wizard_shell.dart';
import 'package:find_a_nikah/core/ui/theme/text_font_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

/// Chrome shared by every profile-info wizard screen (and the face
/// verification / filters screens in `features/auth`): back arrow + title +
/// help icon, the 4-segment progress bar, a content slot, and a pinned
/// bottom Continue/Confirm button with an optional secondary text link
/// ("Skip", "Change photo", ...) and an optional footer below it.
///
/// Inside a [WizardShell] (the onboarding wizard's `ShellRoute`) the shell
/// owns the header + progress bar, so this renders only the body and the
/// bottom buttons, and [title]/[step]/[totalSteps] are not needed. Outside a
/// shell (face verification, filters) they're required and the full chrome
/// is drawn here.
class WizardScaffold extends StatelessWidget {
  const WizardScaffold({
    required this.body,
    required this.onContinue,
    super.key,
    this.title,
    this.step,
    this.totalSteps,
    this.continueLabel = 'Continue',
    this.showSkip = false,
    this.onSkip,
    this.secondaryLabel,
    this.onSecondary,
    this.footer,
    this.onHelp,
  });

  final String? title;
  final int? step;
  final int? totalSteps;
  final Widget body;
  final VoidCallback? onContinue;
  final String continueLabel;

  /// Legacy "Skip" link — kept so existing onboarding screens keep working.
  /// New screens should prefer [secondaryLabel]/[onSecondary].
  final bool showSkip;
  final VoidCallback? onSkip;

  /// Text link rendered under the primary button (e.g. "Change photo").
  final String? secondaryLabel;
  final VoidCallback? onSecondary;

  /// Small print rendered under the buttons (e.g. the verification legal
  /// footer). Caller supplies its own text style/alignment.
  final Widget? footer;

  /// Tap handler for the top-right "?" icon. Purely decorative when null,
  /// matching the original onboarding behaviour.
  final VoidCallback? onHelp;

  @override
  Widget build(BuildContext context) {
    final content = [
      Expanded(child: body),
      Padding(
        padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 8.h),
        child: Column(
          children: [
            AppPrimaryButton(label: continueLabel, onPressed: onContinue),
            // Secondary link: explicit [secondaryLabel] wins, else the
            // legacy Skip flag.
            if (secondaryLabel != null || showSkip) ...[
              SizedBox(height: 8.h),
              TextButton(
                onPressed: secondaryLabel != null ? onSecondary : onSkip,
                child: Text(
                  secondaryLabel ?? 'Skip',
                  style: secondaryLabel != null
                      ? TextFontStyle.headline16w500textDarkStyleSatoshi
                      : TextFontStyle.headline14w500textDarkStyleSatoshi,
                ),
              ),
            ],
            // if (showSkip) ...[   // superseded by the secondaryLabel/showSkip branch above
            //   SizedBox(height: 8.h),
            //   TextButton(
            //     onPressed: onSkip,
            //     child: Text(
            //       'Skip',
            //       style: TextStyle(
            //         color: AppColors.textDark,
            //         fontWeight: FontWeight.w500,
            //         fontSize: 14.sp,
            //       ),
            //     ),
            //   ),
            // ],
            if (footer != null) ...[SizedBox(height: 12.h), footer!],
          ],
        ),
      ),
    ];

    // Inside the onboarding WizardShell: header + bar are persistent there,
    // only this part transitions. Material (not ColoredBox) so InkWell
    // splashes paint on the page instead of behind it, and so the outgoing
    // page isn't see-through during the slide.
    if (WizardShellScope.isInShell(context)) {
      return Material(
        color: Colors.white,
        child: Column(children: content),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Screens that normally live in a shell (and so pass no title)
            // can still be rendered on their own, e.g. in widget tests.
            if (title != null) WizardHeader(title: title!, onHelp: onHelp),
            if (step != null && totalSteps != null) ...[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: WizardProgressBar(step: step!, totalSteps: totalSteps!),
              ),
              SizedBox(height: 16.h),
            ],
            // WizardHeader(title: title!, onHelp: onHelp),
            // Padding(
            //   padding: EdgeInsets.symmetric(horizontal: 20.w),
            //   child: WizardProgressBar(step: step!, totalSteps: totalSteps!),
            // ),
            // SizedBox(height: 16.h),
            ...content,
          ],
        ),
      ),
    );
  }
}

// Previous build — header was inlined here; it now lives in [WizardHeader]
// (core/ui/components/wizard_shell.dart) so the onboarding ShellRoute can
// keep it on screen across pages.
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: Column(
//           children: [
//             // SizedBox(height: 16.h),
//             Padding(
//               padding: EdgeInsets.fromLTRB(4.w, 10.h, 16.w, 4.h),
//               child: Row(
//                 children: [
//                   IconButton(
//                     onPressed: () => context.pop(),
//                     icon: Icon(
//                       Icons.arrow_back,
//                       color: AppColors.textDark,
//                       size: 22.r,
//                     ),
//                   ),
//                   Expanded(
//                     child: Text(
//                       title,
//                       style:
//     TextFontStyle.headline16w600textDarkStyleSatoshi,
//                     ),
//                   ),
//                   GestureDetector(
//                     onTap: onHelp,
//                     child: Container(
//                       width: 28.r,
//                       height: 28.r,
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         border: Border.all(color: AppColors.textMuted),
//                       ),
//                       child: Icon(
//                         Icons.help_outline,
//                         size: 16.r,
//                         color: AppColors.textDark,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(height: 0.h),
//             Divider(),
//             SizedBox(height: 16.h),
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: 20.w),
//               child: WizardProgressBar(step: step, totalSteps: totalSteps),
//             ),
//             SizedBox(height: 16.h),
//             Expanded(child: body),
//             // ...bottom buttons unchanged, see [content] above
//           ],
//         ),
//       ),
//     );
//   }

/// Headline + optional pink-highlighted trailing phrase + optional subtitle,
/// used at the top of every wizard screen's body.
class WizardHeadline extends StatelessWidget {
  const WizardHeadline({
    required this.text,
    super.key,
    this.highlight,
    this.subtitle,
    this.padding,
  });

  final String text;
  final String? highlight;
  final String? subtitle;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text.rich(
            TextSpan(
              text: text,
              // Figma: Satoshi 30 / Medium 500 / line height 140%.
              style: TextFontStyle.headline30w500textDarkStyleSatoshi.copyWith(
                height: 1.4,
              ),
              // Previously 26 / w700 / 1.2 — didn't match the design spec.
              // style:
              //     TextFontStyle.headline26w700textDarkStyleSatoshi.copyWith(
              //   height: 1.2,
              // ),
              children: highlight == null
                  ? null
                  : [
                      TextSpan(
                        text: highlight,
                        style: TextFontStyle
                            .headline30w500primaryColorStyleSatoshi
                            .copyWith(height: 1.4),
                        // style: TextFontStyle
                        //     .headline26w700primaryColorStyleSatoshi
                        //     .copyWith(height: 1.2),
                      ),
                    ],
            ),
          ),
          if (subtitle != null) ...[
            SizedBox(height: 10.h),
            Text(
              subtitle!,
              // Figma: Satoshi 16 / Regular 400 / 140%. Design color is
              // Grey/950 #0A0A0A — kept on textMuted until tokens are updated.
              style: TextFontStyle.headline16w400textMutedStyleSatoshi.copyWith(
                height: 1.4,
              ),
              // style:
              //     TextFontStyle.headline14w400textMutedStyleSatoshi.copyWith(
              //   height: 1.4,
              // ),
            ),
          ],
        ],
      ),
    );
  }
}
