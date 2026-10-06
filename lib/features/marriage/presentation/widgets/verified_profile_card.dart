import 'package:find_a_nikah/core/constants/text_font_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import 'marriage_intentions_card.dart';
import 'profile_style.dart';

const _rowTextColor = Color(0xFF7C7481);

/// "Verified profile" card: one badge row per completed check (main photo
/// in green, age and ID in blue — as in the mockup).
class VerifiedProfileCard extends StatelessWidget {
  const VerifiedProfileCard({
    super.key,
    required this.name,
    required this.photo,
    required this.age,
    required this.id,
    this.onInfo,
  });

  final String name;
  final bool photo;
  final bool age;
  final bool id;
  final VoidCallback? onInfo;

  @override
  Widget build(BuildContext context) {
    final rows = [
      if (photo)
        _Row(kProfileVerifiedGreen, '$name’s main photo has been verified.'),
      if (age) _Row(kProfileVerifiedBlue, '$name’s age has been verified.'),
      if (id)
        _Row(kProfileVerifiedBlue, 'We\'ve verified $name’s ID documents.'),
    ];
    return ProfileCard(
      title: 'Verified profile',
      onInfo: onInfo,
      child: Padding(
        padding: EdgeInsets.only(top: 14.2.h),
        child: Column(children: rows),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row(this.color, this.text);

  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          // Badge centre sits ~3 above the text baseline.
          padding: EdgeInsets.only(top: 7.6.h),
          child: Icon(Icons.verified, size: 17.5.r, color: color),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            text,
            // Mockup: regular 14 (was 15).
            style: TextFontStyle.headline14w400textMutedStyleSatoshi
                .copyWith(color: _rowTextColor)
                .lh(27),
          ),
        ),
      ],
    );
  }
}
