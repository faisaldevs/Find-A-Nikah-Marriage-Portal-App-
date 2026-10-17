import 'package:find_a_nikah/core/ui/ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

/// The 4 filters on the "My history" tab. Order is fixed — selecting one
/// only changes which chip is filled, chips never reorder.
enum ExploreHistoryFilter {
  // liked('Liked'),
  // favourited('Favourited'),
  // passed('Passed'),
  // complimented('Complimented');
  // Figma 1157:6861 order.
  liked('Liked'),
  passed('Passed'),
  favourited('Favourited'),
  complimented('Complimented');

  const ExploreHistoryFilter(this.label);

  final String label;
}

/// "Liked / Favourited / Passed / Complimented" pill row above the "My
/// history" grid. Selected = filled `primaryColor` pill, white text;
/// unselected = white pill, grey outline, dark text.
class ExploreHistoryFilterBar extends StatelessWidget {
  const ExploreHistoryFilterBar({
    required this.selected,
    required this.onChanged,
    super.key,
  });

  final ExploreHistoryFilter selected;
  final ValueChanged<ExploreHistoryFilter> onChanged;

  @override
  Widget build(BuildContext context) {
    // return Wrap(
    // spacing: 8.w,
    // runSpacing: 8.h,
    // children: [
    // for (final filter in ExploreHistoryFilter.values)
    // _Chip(
    // label: filter.label,
    // active: filter == selected,
    // onTap: () => onChanged(filter),
    // ),
    // ],
    // );
    // Figma: one centred row, 14pt apart.
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (final (i, filter) in ExploreHistoryFilter.values.indexed) ...[
          if (i > 0) SizedBox(width: 14.w),
          _Chip(
            label: filter.label,
            active: filter == selected,
            onTap: () => onChanged(filter),
          ),
        ],
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.label, required this.active, required this.onTap});

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      // child: Container(
      // padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      // decoration: BoxDecoration(
      // color: active ? AppColors.primaryColor : Colors.white,
      // borderRadius: BorderRadius.circular(999),
      // border: active ? null : Border.all(color: kExploreCircleBorder),
      // ),
      // child: Text(
      // label,
      // style: TextFontStyle.headline14w500textDarkStyleSatoshi.copyWith(
      // color: active ? Colors.white : AppColors.textDark,
      // ),
      // ),
      // ),
      // Figma 1157:6862: 10×4 padding, 4pt radius, Medium 13 / 20,
      // #D4D4D4 border when idle.
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
        decoration: BoxDecoration(
          color: active ? AppColors.primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(4.r),
          border: active ? null : Border.all(color: const Color(0xFFD4D4D4)),
        ),
        child: Text(
          label,
          style: figmaText(
            13,
            20,
            weight: FontWeight.w500,
            color: active ? Colors.white : const Color(0xFF0A0A0A),
          ),
        ),
      ),
    );
  }
}
