import 'package:find_a_nikah/core/ui/ui.dart';
import 'package:find_a_nikah/features/explore/presentation/widgets/explore_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

/// Section title + a trailing 20pt badge (a plain count, or the gold
/// premium crown), then an optional grey subtitle. The title row is always
/// 20pt high so every section's spacing is the same with or without a
/// badge.
class ExploreSectionHeader extends StatelessWidget {
  const ExploreSectionHeader({
    required this.title,
    super.key,
    this.subtitle,
    this.count,
    this.showCrown = false,
  });

  final String title;
  final String? subtitle;
  final int? count;
  final bool showCrown;

  /// Gap from the header's bottom to the section's cards.
  double get bottomGap => (subtitle == null ? 23 : 25.3).w;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: kExploreGutter),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 20.r,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: TextFontStyle.headline20w700textDarkStyleSatoshi
                      .copyWith(
                        fontSize: 18.sp,
                        letterSpacing: -0.06,
                        height: kExploreTightHeight,
                      ),
                ),
                if (showCrown) ...[
                  SizedBox(width: 9.5.w),
                  Container(
                    width: 20.r,
                    height: 20.r,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: kExploreGold,
                      shape: BoxShape.circle,
                    ),
                    child: CrownIcon(width: 10.5.r, color: Colors.white),
                  ),
                ] else if (count != null) ...[
                  SizedBox(width: 7.w),
                  Container(
                    width: 20.r,
                    height: 20.r,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: kExploreBadgeGrey,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '$count',
                      style: TextFontStyle.headline13w600textMutedStyleSatoshi
                          .copyWith(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w500,
                            height: kExploreTightHeight,
                            color: AppColors.textDark,
                          ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (subtitle != null) ...[
            SizedBox(height: 13.1.w),
            Text(
              subtitle!,
              style: TextFontStyle.headline14w400textMutedStyleSatoshi.copyWith(
                fontSize: 13.5.sp,
                height: 20 / 13.5,
                color: kExploreSubtitleGrey,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
