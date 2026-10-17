import 'package:find_a_nikah/gen/fonts.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

/// Satoshi at a Figma size and line height, for screens built to the
/// pixel from Figma. Size goes through `.sp` like the rest of the app, the
/// line box through `.w` so paragraphs keep their proportion with a
/// `.w`-scaled layout.
///
/// The -0.01 letter spacing isn't tracking: any non-zero value makes Skia
/// lay glyphs out at their exact advances instead of rounding each to a
/// device pixel, which otherwise sets long lines ~4% wider than Figma
/// (measured on device).
TextStyle figmaText(
  double fontSize,
  double lineHeight, {
  FontWeight weight = FontWeight.w400,
  Color color = const Color(0xFF0A0A0A),
}) => TextStyle(
  fontFamily: FontFamily.satoshi,
  fontSize: fontSize.sp,
  fontWeight: weight,
  height: lineHeight.w / fontSize.sp,
  letterSpacing: -0.01,
  leadingDistribution: TextLeadingDistribution.even,
  color: color,
);
