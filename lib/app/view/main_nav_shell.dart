import 'dart:math' as math;

import 'package:find_a_nikah/core/ui/ui.dart';
import 'package:find_a_nikah/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:go_router/go_router.dart';

/// Placeholder avatar for the "Menu" tab until the signed-in user's photo
/// is available.
const _menuAvatarUrl = 'https://i.pravatar.cc/100?img=12';

/// Bottom-nav frame for the main app: Marriage · Explore · Feed · Chat ·
/// Menu. Hosted by a go_router `StatefulShellRoute.indexedStack`, so each
/// tab keeps its own navigation stack and state when switching.
class MainNavShell extends StatelessWidget {
  const MainNavShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  void _onTap(int index) => navigationShell.goBranch(
    index,
    // Tapping the active tab again returns it to its first page.
    initialLocation: index == navigationShell.currentIndex,
  );

  @override
  Widget build(BuildContext context) {
    final current = navigationShell.currentIndex;
    Widget item(
      int index,
      String label,
      Widget Function({required Color color, required bool active}) icon,
    ) => _NavItem(
      label: label,
      selected: current == index,
      icon: icon,
      onTap: () => _onTap(index),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: navigationShell,
      bottomNavigationBar: DecoratedBox(
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Color(0xFFE9EAEC))),
          // border: Border(top: BorderSide(color: Colors.grey.shade200)),
        ),
        // Sized by its content (icon + label) rather than a fixed `.h`
        // height, which shrinks on short screens while `.r`/`.sp` don't.
        // Full-profile mockup (390×844): 20 above the icons, 19 under the
        // labels — the labels sit partly in the iPhone's 34 home-indicator
        // inset, so only an inset bigger than that pushes them up.
        // (Was: SafeArea + 14 top / 10 bottom.)
        child: Padding(
          padding: EdgeInsets.only(
            top: 16.h,
            bottom: math.max(
              19.h,
              MediaQuery.viewPaddingOf(context).bottom - 15.h,
            ),
            left: 8.w,
            right: 8.w,
          ),
          child: Row(
            children: [
              item(
                0,
                'Marriage',
                ({required color, required active}) => Image.asset(
                  active
                      ? Assets.images.marriageNavIconActive
                      : Assets.images.marriageNavIconInactive,
                  width: 28.r,
                  height: 28.r,
                ),
              ),
              item(
                1,
                'Explore',
                ({required color, required active}) => Image.asset(
                  active
                      ? Assets.images.exploreNavIconActive
                      : Assets.images.exploreNavIconInactive,
                  width: 28.r,
                  height: 28.r,
                ),
              ),
              item(
                2,
                'Feed',
                ({required color, required active}) => Image.asset(
                  active
                      ? Assets.images.feedNavIconActive
                      : Assets.images.feedNavIconInactive,
                  width: 28.r,
                  height: 28.r,
                ),
              ),
              item(
                3,
                'Chat',
                ({required color, required active}) => Image.asset(
                  active
                      ? Assets.images.chatNavIconActive
                      : Assets.images.chatNavIconInactive,
                  width: 28.r,
                  height: 28.r,
                ),
              ),
              item(
                4,
                'Menu',
                ({required color, required active}) =>
                    _MenuAvatar(borderColor: color),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Unselected icon/label grey, sampled from the full-profile mockup.
const _inactiveColor = Color(0xFF727272);

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.label,
    required this.selected,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final Widget Function({required Color color, required bool active}) icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.primaryColor : _inactiveColor;
    // final color = selected ? AppColors.primaryColor : AppColors.textMuted;
    return Expanded(
      child: InkResponse(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Fixed 24-high slot (mockup); glyphs may draw slightly past it.
            SizedBox(
              height: 24.h,
              child: OverflowBox(
                maxHeight: 32.h,
                child: icon(color: color, active: selected),
              ),
            ),
            SizedBox(height: 5.h),
            Text(
              label,
              // Mockup: bold 12, line 16.
              style: TextFontStyle.headline12w500textWhiteStyleSatoshi.copyWith(
                color: color,
                fontWeight: FontWeight.w700,
                height: 16 / 12,
                leadingDistribution: TextLeadingDistribution.even,
              ),
            ),
            // icon(color),
            // SizedBox(height: 4.h),
            // Text(
            //   label,
            //   style: selected
            //       ? TextFontStyle.headline11w500primaryColorStyleSatoshi
            //       : TextFontStyle.headline11w500textMutedStyleSatoshi,
            // ),
          ],
        ),
      ),
    );
  }
}

class _MenuAvatar extends StatelessWidget {
  const _MenuAvatar({required this.borderColor});

  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28.r,
      height: 28.r,
      padding: const EdgeInsets.all(1.5),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        // Mockup: plain avatar; ring only when the Menu tab is selected.
        border: borderColor == AppColors.primaryColor
            ? Border.all(color: borderColor)
            : null,
        // border: Border.all(color: borderColor),
      ),
      child: ClipOval(
        child: Image.network(
          _menuAvatarUrl,
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) => ColoredBox(
            color: Colors.grey.shade300,
            child: Icon(Icons.person, size: 14.r, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
