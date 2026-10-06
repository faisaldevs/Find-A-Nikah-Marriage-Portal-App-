import 'package:find_a_nikah/gen/colors.gen.dart';
import 'package:find_a_nikah/gen/fonts.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

/// Every text style used in the app, in one place.
///
/// Naming: `headline{fontSize}w{fontWeight}{color}Style{fontFamily}`.
/// Styles with no color segment deliberately leave `color` unset so the text
/// inherits it from its parent (e.g. a button's `foregroundColor`).
///
/// These are getters, not `static final`, so `.sp` is re-evaluated on each
/// access and stays correct after rotation / window resize. Per-site tweaks
/// like `height` or `decoration` go through `.copyWith()` at the call site.
///
/// Satoshi only ships 300/400/500/700/900 — `w600` renders as Bold (700).
class TextFontStyle {
  TextFontStyle._();

  static TextStyle _satoshi(
    double fontSize,
    FontWeight fontWeight, [
    Color? color,
  ]) => TextStyle(
    fontFamily: FontFamily.satoshi,
    fontSize: fontSize.sp,
    fontWeight: fontWeight,
    color: color,
  );

  // 11
  static TextStyle get headline11w400textMutedStyleSatoshi =>
      _satoshi(11, FontWeight.w400, AppColors.textMuted);

  // 11
  static TextStyle get headline11w400white70StyleSatoshi =>
      _satoshi(11, FontWeight.w400, Colors.white70);
  static TextStyle get headline11w500primaryColorStyleSatoshi =>
      _satoshi(11, FontWeight.w500, AppColors.primaryColor);
  static TextStyle get headline11w500textMutedStyleSatoshi =>
      _satoshi(11, FontWeight.w500, AppColors.textMuted);

  // 12
  static TextStyle get headline12w400textMutedStyleSatoshi =>
      _satoshi(12, FontWeight.w400, AppColors.textMuted);
  static TextStyle get headline12w400white70StyleSatoshi =>
      _satoshi(12, FontWeight.w400, Colors.white70);
  static TextStyle get headline12w500textWhiteStyleSatoshi =>
      _satoshi(12, FontWeight.w500, AppColors.textWhite);

  // 13
  static TextStyle get headline13w400textDarkStyleSatoshi =>
      _satoshi(13, FontWeight.w400, AppColors.textDark);
  static TextStyle get headline13w400textMutedStyleSatoshi =>
      _satoshi(13, FontWeight.w400, AppColors.textMuted);
  static TextStyle get headline13w400errorColorStyleSatoshi =>
      _satoshi(13, FontWeight.w400, AppColors.errorColor);
  static TextStyle get headline13w400textWhiteStyleSatoshi =>
      _satoshi(13, FontWeight.w400, AppColors.textWhite);
  static TextStyle get headline13w400white70StyleSatoshi =>
      _satoshi(13, FontWeight.w400, Colors.white70);
  static TextStyle get headline13w600textMutedStyleSatoshi =>
      _satoshi(13, FontWeight.w600, AppColors.textMuted);
  static TextStyle get headline13w600primaryColorStyleSatoshi =>
      _satoshi(13, FontWeight.w600, AppColors.primaryColor);
  static TextStyle get headline13w700primaryColorStyleSatoshi =>
      _satoshi(13, FontWeight.w700, AppColors.primaryColor);

  // 14
  static TextStyle get headline14w400textDarkStyleSatoshi =>
      _satoshi(14, FontWeight.w400, AppColors.textDark);
  static TextStyle get headline14w400textMutedStyleSatoshi =>
      _satoshi(14, FontWeight.w400, AppColors.textMuted);
  static TextStyle get headline14w400textWhiteStyleSatoshi =>
      _satoshi(14, FontWeight.w400, AppColors.textWhite);
  static TextStyle get headline14w500textDarkStyleSatoshi =>
      _satoshi(14, FontWeight.w500, AppColors.textDark);
  static TextStyle get headline14w500textWhiteStyleSatoshi =>
      _satoshi(14, FontWeight.w500, AppColors.textWhite);
  static TextStyle get headline14w600StyleSatoshi =>
      _satoshi(14, FontWeight.w600);

  // 15
  static TextStyle get headline15w400textDarkStyleSatoshi =>
      _satoshi(15, FontWeight.w400, AppColors.textDark);
  static TextStyle get headline15w400textMutedStyleSatoshi =>
      _satoshi(15, FontWeight.w400, AppColors.textMuted);
  static TextStyle get headline15w400black87StyleSatoshi =>
      _satoshi(15, FontWeight.w400, Colors.black87);
  static TextStyle get headline15w500textDarkStyleSatoshi =>
      _satoshi(15, FontWeight.w500, AppColors.textDark);
  static TextStyle get headline15w500textWhiteStyleSatoshi =>
      _satoshi(15, FontWeight.w500, AppColors.textWhite);
  static TextStyle get headline15w500primaryColorStyleSatoshi =>
      _satoshi(15, FontWeight.w500, AppColors.primaryColor);
  static TextStyle get headline15w600StyleSatoshi =>
      _satoshi(15, FontWeight.w600);
  static TextStyle get headline15w600textDarkStyleSatoshi =>
      _satoshi(15, FontWeight.w600, AppColors.textDark);
  static TextStyle get headline15w600textWhiteStyleSatoshi =>
      _satoshi(15, FontWeight.w600, AppColors.textWhite);

  // 16
  static TextStyle get headline16w400textDarkStyleSatoshi =>
      _satoshi(16, FontWeight.w400, AppColors.textDark);
  static TextStyle get headline16w400textMutedStyleSatoshi =>
      _satoshi(16, FontWeight.w400, AppColors.textMuted);
  static TextStyle get headline16w500textDarkStyleSatoshi =>
      _satoshi(16, FontWeight.w500, AppColors.textDark);
  static TextStyle get headline16w500textWhiteStyleSatoshi =>
      _satoshi(16, FontWeight.w500, AppColors.textWhite);
  static TextStyle get headline16w600StyleSatoshi =>
      _satoshi(16, FontWeight.w600);
  static TextStyle get headline16w600textDarkStyleSatoshi =>
      _satoshi(16, FontWeight.w600, AppColors.textDark);
  static TextStyle get headline16w600primaryColorStyleSatoshi =>
      _satoshi(16, FontWeight.w600, AppColors.primaryColor);
  static TextStyle get headline16w700textDarkStyleSatoshi =>
      _satoshi(16, FontWeight.w700, AppColors.textDark);
  static TextStyle get headline16w700primaryColorStyleSatoshi =>
      _satoshi(16, FontWeight.w700, AppColors.primaryColor);

  // 17
  static TextStyle get headline17w500textDarkStyleSatoshi =>
      _satoshi(17, FontWeight.w500, AppColors.textDark);
  static TextStyle get headline17w600textDarkStyleSatoshi =>
      _satoshi(17, FontWeight.w600, AppColors.textDark);

  // 18
  static TextStyle get headline18w500textWhiteStyleSatoshi =>
      _satoshi(18, FontWeight.w500, AppColors.textWhite);
  static TextStyle get headline18w700StyleSatoshi =>
      _satoshi(18, FontWeight.w700);

  // 20
  static TextStyle get headline20w700textDarkStyleSatoshi =>
      _satoshi(20, FontWeight.w700, AppColors.textDark);

  // 22
  static TextStyle get headline22w400textDarkStyleSatoshi =>
      _satoshi(22, FontWeight.w400, AppColors.textDark);
  static TextStyle get headline22w700textDarkStyleSatoshi =>
      _satoshi(22, FontWeight.w700, AppColors.textDark);

  // 26
  static TextStyle get headline26w700textDarkStyleSatoshi =>
      _satoshi(26, FontWeight.w700, AppColors.textDark);
  static TextStyle get headline26w700primaryColorStyleSatoshi =>
      _satoshi(26, FontWeight.w700, AppColors.primaryColor);

  // 28
  static TextStyle get headline28w700textWhiteStyleSatoshi =>
      _satoshi(28, FontWeight.w700, AppColors.textWhite);
  static TextStyle get headline28w500textDarkStyleSatoshi =>
      _satoshi(28, FontWeight.w500, AppColors.textDark);
  static TextStyle get headline28w500primaryColorStyleSatoshi =>
      _satoshi(28, FontWeight.w500, AppColors.primaryColor);

  // 30
  static TextStyle get headline30w500textDarkStyleSatoshi =>
      _satoshi(30, FontWeight.w500, AppColors.textDark);
  static TextStyle get headline30w500primaryColorStyleSatoshi =>
      _satoshi(30, FontWeight.w500, AppColors.primaryColor);
  static TextStyle get headline30w700textDarkStyleSatoshi =>
      _satoshi(30, FontWeight.w700, AppColors.textDark);

  /// Country flag emoji in list tiles. Rendered by the platform emoji font,
  /// not Satoshi, and intentionally not `.sp`-scaled.
  static const flagEmoji22 = TextStyle(fontSize: 22);
}
