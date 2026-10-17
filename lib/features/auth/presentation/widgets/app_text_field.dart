import 'package:find_a_nikah/core/ui/ui.dart';
import 'package:find_a_nikah/features/auth/presentation/presentation.dart'
    show CreatePasswordPage, LoginPage;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

/// Icon-prefixed text field used across the auth screens — [LoginPage]'s
/// email/password fields and [CreatePasswordPage]'s password fields.
/// [filled] switches between the two visual contexts they appear in:
/// solid white (over a photo background) or outlined (already on white).
class AppTextField extends StatelessWidget {
  const AppTextField({
    required this.controller,
    required this.hint,
    required this.icon,
    super.key,
    this.obscureText = false,
    this.trailing,
    this.keyboardType,
    this.onChanged,
    this.filled = true,
    this.fontSize = 16,
  });

  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final bool obscureText;
  final Widget? trailing;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;
  final bool filled;

  /// Text/hint size of the [filled] variant (Figma: 16 login, 15 password).
  final double fontSize;

  // Figma 883:3895 (login, filled): white, 1px #E5E7EB border, 8pt radius,
  // 48pt tall, 24pt #121212 icon, Satoshi Medium 16 #121212.
  static const _figmaInk = Color(0xFF121212);
  static const _figmaBorder = Color(0xFFE5E7EB);

  @override
  Widget build(BuildContext context) {
    // final iconColor = filled ? Colors.black45 : AppColors.textMuted;
    final iconColor = filled ? _figmaInk : AppColors.textMuted;
    // final filledText = TextFontStyle.headline16w500textDarkStyleSatoshi
    //     .copyWith(color: _figmaInk, height: 1.5);
    final filledText = figmaText(
      fontSize,
      24,
      weight: FontWeight.w500,
      color: _figmaInk,
    );
    return Container(
      decoration: BoxDecoration(
        color: filled ? Colors.white : null,
        // border: filled
        //     ? null
        //     : Border.all(color: AppColors.textMuted.withValues(alpha: 0.4)),
        // borderRadius: BorderRadius.circular(14.r),
        border: filled
            ? Border.all(color: _figmaBorder)
            : Border.all(color: AppColors.textMuted.withValues(alpha: 0.4)),
        borderRadius: BorderRadius.circular(filled ? 8.r : 14.r),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        onChanged: onChanged,
        // style: filled
        //     ? TextFontStyle.headline15w400black87StyleSatoshi
        //     : TextFontStyle.headline15w400textDarkStyleSatoshi,
        style: filled
            ? filledText
            : TextFontStyle.headline15w400textDarkStyleSatoshi,
        decoration: InputDecoration(
          hintText: hint,
          // hintStyle: filled
          //     ? null
          //     : TextFontStyle.headline15w400textMutedStyleSatoshi,
          hintStyle: filled
              ? filledText
              : TextFontStyle.headline15w400textMutedStyleSatoshi,
          // prefixIcon: Icon(icon, color: iconColor, size: 20.r),
          prefixIcon: filled
              ? Padding(
                  padding: EdgeInsets.only(left: 16.w, right: 12.w),
                  child: Icon(icon, color: iconColor, size: 24.r),
                )
              : Icon(icon, color: iconColor, size: 20.r),
          prefixIconConstraints: filled ? const BoxConstraints() : null,
          suffixIcon: trailing,
          border: InputBorder.none,
          isDense: filled,
          // contentPadding: EdgeInsets.symmetric(vertical: 16.h),
          contentPadding: EdgeInsets.symmetric(vertical: filled ? 12.h : 16.h),
        ),
      ),
    );
  }
}
