import 'package:find_a_nikah/core/ui/ui.dart';
import 'package:find_a_nikah/features/explore/presentation/widgets/explore_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

/// Section title + a trailing badge (a plain count, or the gold premium
/// crown), then a grey subtitle line.
class ExploreSectionHeader extends StatelessWidget {
  const ExploreSectionHeader({
    required this.title,
    required this.subtitle,
    super.key,
    this.count,
    this.showCrown = false,
  });

  final String title;
  final String subtitle;
  final int? count;
  final bool showCrown;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: kExploreGutter),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: TextFontStyle.headline20w700textDarkStyleSatoshi,
              ),
              SizedBox(width: 8.w),
              if (showCrown)
                Container(
                  width: 30.r,
                  height: 30.r,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: kExploreGold,
                    shape: BoxShape.circle,
                  ),
                  child: CrownIcon(width: 14.r, color: Colors.white),
                )
              else if (count != null)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 3.h),
                  decoration: const BoxDecoration(
                    color: kExploreBadgeGrey,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '$count',
                    style: TextFontStyle.headline13w600textMutedStyleSatoshi
                        .copyWith(color: AppColors.textDark),
                  ),
                ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            subtitle,
            style: TextFontStyle.headline14w400textMutedStyleSatoshi,
          ),
        ],
      ),
    );
  }
}
