import 'package:find_a_nikah/core/ui/theme/text_font_style.dart';
import 'package:find_a_nikah/gen/colors.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

/// Full-width pink CTA button used across the onboarding/sign-up flow
/// (intro carousel, email/verification/create-password steps, get-started,
/// login). `onPressed: null` renders the disabled (faded) state.
class AppPrimaryButton extends StatelessWidget {
  const AppPrimaryButton({
    required this.label,
    required this.onPressed,
    super.key,
    this.height,
    this.borderRadius,
    this.isLoading = false,
    this.loadingLabel = 'Please wait...',
    this.labelStyle,
  });

  final String label;
  final VoidCallback? onPressed;

  /// Defaults to 54.h — the size used everywhere except the login screen, which
  /// passes 52.h to match its own field/circle-button radius language.
  final double? height;
  final double? borderRadius;
  final bool isLoading;
  final String loadingLabel;

  /// Overrides the label's text style (default Satoshi 16 w600 white) —
  /// for screens whose Figma frame specifies a different label.
  final TextStyle? labelStyle;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height ?? 54.h,
      child: FilledButton(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primaryColor,
          disabledBackgroundColor: isLoading
              ? AppColors.primaryColor
              : AppColors.primaryColor.withValues(alpha: 0.35),
          disabledForegroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 16.r),
          ),
        ),
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox.square(
                    dimension: 18.r,
                    child: const CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Flexible(
                    child: Text(
                      loadingLabel,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextFontStyle.headline16w600StyleSatoshi,
                    ),
                  ),
                ],
              )
            : Text(
                label,
                style: labelStyle ?? TextFontStyle.headline16w600StyleSatoshi,
              ),
      ),
    );
  }
}
