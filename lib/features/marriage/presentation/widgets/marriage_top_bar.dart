import 'package:find_a_nikah/core/ui/ui.dart';
import 'package:find_a_nikah/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

/// Filters · Find A Nikah logo · Sort · Notifications.
class MarriageTopBar extends StatelessWidget {
  const MarriageTopBar({
    required this.onFilters,
    required this.onSort,
    required this.onNotifications,
    super.key,
  });

  final VoidCallback onFilters;
  final VoidCallback onSort;
  final VoidCallback onNotifications;

  @override
  Widget build(BuildContext context) {
    // Full-profile mockup: 38 circles at 19.5 / 20.5 from the edges, 10
    // apart on the right; the wordmark centred on the screen (not between
    // the buttons); 13 above and 17 below the circles.
    return Padding(
      padding: EdgeInsets.fromLTRB(19.5.w, 13.h, 20.5.w, 17.h),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Wordmark only (navy text, pink ∧) — the full logo's text is
          // white, so on this light bar only its heart showed. Offset by
          // half the asymmetric side padding so it centres on the screen.
          Padding(
            padding: EdgeInsets.only(right: 2.w),
            child: Image.asset(Assets.images.findANikahWordmark, height: 16.h),
          ),
          Row(
            children: [
              CircleIconButton(
                icon: FiltersIcon(
                  size: Size(16.6.r, 14.r),
                  color: AppColors.textDark,
                ),
                tooltip: 'Filters',
                onTap: onFilters,
              ),
              const Spacer(),
              CircleIconButton(
                icon: Icon(
                  Icons.swap_vert,
                  size: 19.r,
                  color: AppColors.textDark,
                ),
                tooltip: 'Sort',
                onTap: onSort,
              ),
              SizedBox(width: 10.w),
              CircleIconButton(
                icon: Icon(
                  Icons.notifications_none,
                  size: 17.5.r,
                  color: AppColors.textDark,
                ),
                tooltip: 'Notifications',
                onTap: onNotifications,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
