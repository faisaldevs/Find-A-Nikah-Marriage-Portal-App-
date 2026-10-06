import 'package:find_a_nikah/gen/colors.gen.dart';
import 'package:find_a_nikah/core/constants/text_font_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

/// Icon-prefixed text field used across the auth screens — [LoginScreen]'s
/// email/password fields and [CreatePasswordScreen]'s password fields.
/// [filled] switches between the two visual contexts they appear in:
/// solid white (over a photo background) or outlined (already on white).
class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.controller,
    required this.hint,
    required this.icon,
    this.obscureText = false,
    this.trailing,
    this.keyboardType,
    this.onChanged,
    this.filled = true,
  });

  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final bool obscureText;
  final Widget? trailing;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    final iconColor = filled ? Colors.black45 : AppColors.textMuted;
    return Container(
      decoration: BoxDecoration(
        color: filled ? Colors.white : null,
        border: filled
            ? null
            : Border.all(color: AppColors.textMuted.withValues(alpha: 0.4)),
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        onChanged: onChanged,
        style: filled
            ? TextFontStyle.headline15w400black87StyleSatoshi
            : TextFontStyle.headline15w400textDarkStyleSatoshi,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: filled
              ? null
              : TextFontStyle.headline15w400textMutedStyleSatoshi,
          prefixIcon: Icon(icon, color: iconColor, size: 20.r),
          suffixIcon: trailing,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 16.h),
        ),
      ),
    );
  }
}
