import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

// Colours of the full-profile design, sampled from the mockup. Local until
// the design's colour tokens are added to assets/color/colors.xml.
const kProfileInk = Color(0xFF0A0A0A);
const kProfileBodyGrey = Color(0xFF515151);
const kProfileHintGrey = Color(0xFF727272);
const kProfileLabelGrey = Color(0xFFA2A2A2);
const kProfileBorder = Color(0xFFE6E7EB);
const kProfileChipBorder = Color(0xFFD4D4D4);
const kProfileChipFill = Color(0xFFF5F5F5);
const kProfilePageBackground = Color(0xFFF9FAFC);
const kProfileGold = Color(0xFF9C752A);
const kProfileCream = Color(0xFFFDF7EB);
const kProfileNavy = Color(0xFF012D5C);
const kProfileVerifiedBlue = Color(0xFF2563EB);
const kProfileVerifiedGreen = Color(0xFF17A34A);

/// Horizontal page margin of the detail sections (mockup: 19 on 390).
double get kProfileGutter => 19.w;

extension ProfileLineHeight on TextStyle {
  /// Fixed line height in design pixels, with the extra leading split evenly
  /// above and below the glyphs — how Figma places text, so baselines land
  /// where the mockup has them.
  ///
  /// [tracking] is letter spacing in ems. Flutter lays Satoshi out 2–3%
  /// wider than the mockup, which made lines and chip rows wrap earlier
  /// than designed; the default pulls widths back in line (tuned on
  /// device — letter spacing also turns off ligatures, so its effect is
  /// larger than the raw value suggests).
  TextStyle lh(double designLineHeight, {double tracking = -0.0075}) =>
      copyWith(
        height: designLineHeight.sp / fontSize!,
        leadingDistribution: TextLeadingDistribution.even,
        letterSpacing: tracking * fontSize!,
      );
}
