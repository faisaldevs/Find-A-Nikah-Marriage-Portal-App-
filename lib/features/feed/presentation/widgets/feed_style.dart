import 'package:find_a_nikah/core/ui/ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

// Colours from the Figma "feed" frame's styles (Foundation/Grey/*, etc.).
// Local until the design's tokens land in assets/color/colors.xml.
const kFeedPageBackground = Color(0xFFF9FAFB);
const kFeedGrey950 = Color(0xFF0A0A0A);
const kFeedGrey700 = Color(0xFF404040);
const kFeedGrey500 = Color(0xFF737373);
const kFeedGrey300 = Color(0xFFD4D4D4);
const kFeedGrey200 = Color(0xFFE5E5E5);
const kFeedGrey100 = Color(0xFFF5F5F5);
const kFeedGrey900 = Color(0xFF171717);
const kFeedGrey600 = Color(0xFF525252);
const kFeedGrey400 = Color(0xFFA3A3A3);
const kFeedTopicRed = Color(0xFFE35151);
const kFeedReadMoreGreen = Color(0xFF16A34A);
const kFeedNavy = Color(0xFF012C5D);
const kFeedSheetBackground = Color(0xFFFAFAFA);

/// Barrier behind the post-actions and sort sheets (Figma: black at 60%).
const kFeedScrim = Color(0x99000000);

/// Horizontal page margin (Figma: 20 on 390).
double get kFeedGutter => 20.w;

/// Shared [figmaText] in the Feed's default colour.
TextStyle feedText(
  double fontSize,
  double lineHeight, {
  FontWeight weight = FontWeight.w400,
  Color color = kFeedGrey950,
}) => figmaText(fontSize, lineHeight, weight: weight, color: color);
