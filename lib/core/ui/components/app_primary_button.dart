import 'package:find_a_nikah/gen/colors.gen.dart';
import 'package:find_a_nikah/core/constants/text_font_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

/// Full-width pink CTA button used across the onboarding/sign-up flow
/// (intro carousel, email/verification/create-password steps, get-started,
/// login). `onPressed: null` renders the disabled (faded) state.
class AppPrimaryButton extends StatelessWidget {
  const AppPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.height,
    this.borderRadius,
  });

  final String label;
  final VoidCallback? onPressed;

  /// Defaults to 54.h — the size used everywhere except [LoginScreen], which
  /// passes 52.h to match its own field/circle-button radius language.
  final double? height;
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height ?? 54.h,
      child: FilledButton(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primaryColor,
          disabledBackgroundColor: AppColors.primaryColor.withValues(
            alpha: 0.35,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 16.r),
          ),
        ),
        onPressed: onPressed,
        child: Text(label, style: TextFontStyle.headline16w600StyleSatoshi),
      ),
    );
  }
}
