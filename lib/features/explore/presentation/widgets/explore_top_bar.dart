import 'package:find_a_nikah/core/ui/ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

/// Filters circle · "Explore" title, centred on the screen (not between
/// the buttons). Mockup: 34pt circle.
class ExploreTopBar extends StatelessWidget {
  const ExploreTopBar({required this.onFilters, super.key});

  final VoidCallback onFilters;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 13.h, 20.w, 24.1.h),
      // padding: EdgeInsets.fromLTRB(19.5.w, 13.h, 20.5.w, 17.h),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Mockup centres the title 3.5pt left of the screen centre.
          Transform.translate(
            offset: Offset(-3.5.w, 0.3.h),
            child: Text(
              'Explore',
              style: TextFontStyle.headline22w700textDarkStyleSatoshi.copyWith(
                fontSize: 19.5.sp,
              ),
            ),
          ),
          Row(
            children: [
              CircleIconButton(
                // 36.r renders the mockup's 34pt (`.r` ≈ 0.95 on phones).
                size: 36,
                icon: FiltersIcon(
                  size: Size(16.6.r, 14.r),
                  color: AppColors.textDark,
                ),
                tooltip: 'Filters',
                onTap: onFilters,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
