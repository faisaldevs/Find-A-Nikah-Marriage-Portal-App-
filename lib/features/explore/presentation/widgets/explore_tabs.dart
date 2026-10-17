import 'package:find_a_nikah/core/ui/ui.dart';
import 'package:find_a_nikah/features/explore/presentation/widgets/explore_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

enum ExploreTab { forYou, myHistory }

/// "For you" / "My history" as two screen halves: labels inset 40pt from
/// their outer edge, the active one in red, and a pink bar under the whole
/// active half (mockup: x 0→190 on 390, just below the white header).
/// Two different mockup reds, sampled as-is (`errorColor` for the text,
/// `primaryColor` for the bar). Sits on the white header; the bar row is
/// the header's bottom edge.
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
    final forYou = selected == ExploreTab.forYou;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(
              child: _Tab(
                label: 'For you',
                active: forYou,
                alignment: Alignment.centerLeft,
                onTap: () => onChanged(ExploreTab.forYou),
              ),
            ),
            Expanded(
              child: _Tab(
                label: 'My history',
                active: !forYou,
                alignment: Alignment.centerRight,
                onTap: () => onChanged(ExploreTab.myHistory),
              ),
            ),
          ],
        ),
        ColoredBox(
          color: kExplorePageBackground,
          child: Row(
            children: [
              Expanded(
                child: _Bar(
                  visible: forYou,
                  inner: EdgeInsets.only(right: 5.w),
                ),
              ),
              Expanded(
                child: _Bar(
                  visible: !forYou,
                  inner: EdgeInsets.only(left: 5.w),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Tab extends StatelessWidget {
  const _Tab({
    required this.label,
    required this.active,
    required this.alignment,
    required this.onTap,
  });

  final String label;
  final bool active;
  final Alignment alignment;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: EdgeInsets.fromLTRB(40.w, 0, 40.w, 21.h),
        child: Align(
          alignment: alignment,
          child: Text(
            label,
            style: TextFontStyle.headline17w500textDarkStyleSatoshi.copyWith(
              fontSize: 17.5.sp,
              height: kExploreTightHeight,
              color: active ? AppColors.errorColor : AppColors.textDark,
            ),
          ),
        ),
      ),
    );
  }
}

class _Bar extends StatelessWidget {
  const _Bar({required this.visible, required this.inner});

  final bool visible;
  final EdgeInsets inner;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: inner,
      child: Container(
        height: 2.h,
        margin: EdgeInsets.only(top: 1.h),
        color: visible ? AppColors.primaryColor : Colors.transparent,
      ),
    );
  }
}
