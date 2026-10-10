import 'package:find_a_nikah/core/ui/ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

enum ExploreTab { forYou, myHistory }

/// "For you" / "My history", with the active tab in red and a pink
/// underline beneath it — two different mockup reds, sampled as-is
/// (`errorColor` for the text, `primaryColor` for the bar).
class ExploreTabBar extends StatelessWidget {
  const ExploreTabBar({
    required this.selected,
    required this.onChanged,
    super.key,
  });

  final ExploreTab selected;
  final ValueChanged<ExploreTab> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _Tab(
          label: 'For you',
          active: selected == ExploreTab.forYou,
          onTap: () => onChanged(ExploreTab.forYou),
        ),
        SizedBox(width: 32.w),
        _Tab(
          label: 'My history',
          active: selected == ExploreTab.myHistory,
          onTap: () => onChanged(ExploreTab.myHistory),
        ),
      ],
    );
  }
}

class _Tab extends StatelessWidget {
  const _Tab({required this.label, required this.active, required this.onTap});

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: EdgeInsets.only(bottom: 14.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextFontStyle.headline17w500textDarkStyleSatoshi.copyWith(
                color: active ? AppColors.errorColor : AppColors.textDark,
              ),
            ),
            SizedBox(height: 15.h),
            Container(
              height: 2.h,
              width: active ? null : 0,
              constraints: active ? BoxConstraints(minWidth: 60.w) : null,
              color: active ? AppColors.primaryColor : Colors.transparent,
            ),
          ],
        ),
      ),
    );
  }
}
