import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

// Colours sampled from the Explore "For you" mockup. Local until the
// design's colour tokens are added to assets/color/colors.xml — same
// situation `profile_style.dart` documents for the Marriage tab (several
// of these values are identical to that file's, sampled independently).
const kExplorePageBackground = Color(0xFFF9FAFC);
const kExploreGold = Color(0xFF9C752A);
const kExploreVerifiedBlue = Color(0xFF2563EB);
const kExploreActiveGreen = Color(0xFF17A34A);
const kExploreBadgeGrey = Color(0xFFE6E7EB);
const kExploreCircleBorder = Color(0xFFE6E7EB);

/// Every portrait card on the tab (big, small and grid) shares this aspect
/// ratio — sampled from the mockup's three card sizes (290×400, 120×168,
/// 90×126), all height = 1.4 × width.
const kExploreCardAspect = 1.4;

/// Horizontal page margin (mockup: 20 on 390).
double get kExploreGutter => 20.w;
