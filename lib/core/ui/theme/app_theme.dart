import 'package:find_a_nikah/core/ui/theme/text_font_style.dart';
import 'package:find_a_nikah/gen/colors.gen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// The app's [ThemeData], built from the design tokens.
abstract final class AppTheme {
  static ThemeData light() => ThemeData(
    colorSchemeSeed: AppColors.primaryColor,
    useMaterial3: true,
    fontFamily: satoshiFontFamily,
    scaffoldBackgroundColor: AppColors.baseWhite,
    // Android's default M3 "Zoom" push transition fades both the outgoing
    // and incoming page's non-Hero content out through a transparent middle
    // stretch before the new page pops in — that dead zone reads as a
    // flicker between screens. The Cupertino slide has no such gap.
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      },
    ),
  );
}
