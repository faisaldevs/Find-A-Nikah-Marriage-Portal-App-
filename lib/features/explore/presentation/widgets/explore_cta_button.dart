import 'package:find_a_nikah/core/ui/ui.dart';
import 'package:find_a_nikah/features/explore/presentation/widgets/explore_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

/// "See who likes you" — a gold pill that shrinks to a crown-only circle
/// while the page scrolls down, and expands back on scroll-up (per the
/// user: an animated max/min state, not a plain floating button).
class ExploreCtaButton extends StatelessWidget {
  const ExploreCtaButton({
    required this.expanded,
    required this.onTap,
    super.key,
  });

  final bool expanded;
  final VoidCallback onTap;

  static const _height = 52.0;
  static const _expandedWidth = 224.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeOutCubic,
        height: _height.h,
        width: (expanded ? _expandedWidth : _height).w,
        alignment: Alignment.center,
        // The label's Row is laid out against whatever width the
        // container happens to be mid-animation, which is narrower than
        // the label needs for part of the shrink — clip rather than
        // overflow during that window.
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: kExploreGold,
          borderRadius: BorderRadius.circular(999),
          boxShadow: [
            BoxShadow(
              color: kExploreGold.withValues(alpha: 0.35),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 180),
          child: expanded
              ? Row(
                  key: const ValueKey('expanded'),
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Flexible, not a bare Text: mid-animation the
                    // container is narrower than the full label needs,
                    // and a Row doesn't shrink a plain child to fit —
                    // it throws. Ellipsis for that brief window beats
                    // a RenderFlex overflow.
                    Flexible(
                      child: Text(
                        'See who likes you',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextFontStyle.headline15w600StyleSatoshi
                            .copyWith(color: Colors.white),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    CrownIcon(width: 18.r, color: Colors.white),
                  ],
                )
              : CrownIcon(
                  key: const ValueKey('collapsed'),
                  width: 18.r,
                  color: Colors.white,
                ),
        ),
      ),
    );
  }
}
