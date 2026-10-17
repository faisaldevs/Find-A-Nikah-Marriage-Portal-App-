import 'package:find_a_nikah/core/ui/ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

// Colours from the Figma "menu" / "settings" / "menu_edit" frames
// (Foundation/Grey/*, Primary/*). Local until the design's tokens land in
// assets/color/colors.xml — same approach as feed_style.dart.
const kMenuGrey950 = Color(0xFF0A0A0A);
const kMenuGrey900 = Color(0xFF171717);
const kMenuGrey800 = Color(0xFF262626);
const kMenuGrey700 = Color(0xFF404040);
const kMenuGrey500 = Color(0xFF737373);
const kMenuGrey400 = Color(0xFFA3A3A3);
const kMenuGrey300 = Color(0xFFD4D4D4);
const kMenuGrey200 = Color(0xFFE5E5E5);
const kMenuGrey100 = Color(0xFFF5F5F5);
const kMenuGrey50 = Color(0xFFF9FAFB);
const kMenuBorderLine = Color(0xFFE5E7EB);
const kMenuPrimary50 = Color(0xFFFDE6EF);
const kMenuRowTitle = Color(0xFF131416);
const kMenuTextBase = Color(0xFF121212);
const kMenuGold = Color(0xFF9C752A);
const kMenuRed = Color(0xFFE54848);

/// Horizontal page margin (Figma: 20 on 390).
double get kMenuGutter => 20.w;

/// Figma text in Satoshi. The design also uses Outfit (section titles,
/// Edit-profile values) and Plus Jakarta Sans (the member's name); neither
/// is bundled, so they render in Satoshi at the same size/height/weight.
TextStyle menuText(
  double fontSize,
  double lineHeight, {
  FontWeight weight = FontWeight.w400,
  Color color = kMenuGrey950,
}) => figmaText(fontSize, lineHeight, weight: weight, color: color);
