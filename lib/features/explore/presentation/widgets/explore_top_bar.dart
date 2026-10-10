import 'package:find_a_nikah/core/ui/ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

/// Filters circle · "Explore" title, centred on the screen (not between
/// the buttons) — same bar geometry as `MarriageTopBar`.
class ExploreTopBar extends StatelessWidget {
  const ExploreTopBar({required this.onFilters, super.key});

  final VoidCallback onFilters;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(19.5.w, 13.h, 20.5.w, 17.h),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Text(
            'Explore',
            style: TextFontStyle.headline22w700textDarkStyleSatoshi,
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
            ],
          ),
        ],
      ),
    );
  }
}
