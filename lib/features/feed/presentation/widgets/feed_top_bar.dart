import 'package:find_a_nikah/core/ui/ui.dart';
import 'package:find_a_nikah/features/feed/presentation/widgets/feed_circle_button.dart';
import 'package:find_a_nikah/features/feed/presentation/widgets/feed_search_field.dart';
import 'package:find_a_nikah/features/feed/presentation/widgets/feed_style.dart';
import 'package:find_a_nikah/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// "Feed" title centred on the screen, with search + notifications circles
/// on the right (Figma: 38pt circles, 10pt apart, 20pt from the edge).
/// While [searching], it turns into back · search field — the profile
/// search bar's layout — sliding in from the search button's side.
class FeedTopBar extends StatelessWidget {
  const FeedTopBar({
    required this.searching,
    required this.searchController,
    required this.onSearch,
    required this.onCloseSearch,
    required this.onQueryChanged,
    required this.onNotifications,
    super.key,
  });

  final bool searching;
  final TextEditingController searchController;
  final VoidCallback onSearch;
  final VoidCallback onCloseSearch;
  final ValueChanged<String> onQueryChanged;
  final VoidCallback onNotifications;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(kFeedGutter, 13.h, kFeedGutter, 0),
      // Fixed at the title row's 38pt so the chips below don't jump; the
      // 42pt search field overhangs it by 2pt each side.
      child: SizedBox(
        height: 38.w,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 220),
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeInCubic,
          transitionBuilder: (child, animation) => FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween(
                begin: Offset(
                  child.key == const ValueKey('search') ? 0.15 : -0.15,
                  0,
                ),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            ),
          ),
          child: searching ? _searchBar() : _titleBar(),
        ),
      ),
    );
  }

  Widget _titleBar() {
    Widget circle(String icon, String tooltip, VoidCallback onTap) =>
        CircleIconButton(
          // 40.r renders Figma's 38pt (`.r` ≈ 0.95 on phones).
          size: 40,
          icon: SvgPicture.asset(icon, width: 16.w, height: 16.w),
          tooltip: tooltip,
          onTap: onTap,
        );
    return Stack(
      key: const ValueKey('title'),
      alignment: Alignment.center,
      children: [
        Text('Feed', style: feedText(20, 28, weight: FontWeight.w700)),
        Align(
          alignment: Alignment.centerRight,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              circle(Assets.icons.feedSearch, 'Search', onSearch),
              SizedBox(width: 10.w),
              circle(Assets.icons.feedBell, 'Notifications', onNotifications),
            ],
          ),
        ),
      ],
    );
  }

  Widget _searchBar() {
    return OverflowBox(
      key: const ValueKey('search'),
      maxHeight: 42.w,
      child: Row(
        children: [
          FeedCircleButton(
            asset: Assets.icons.feedBack,
            iconSize: 24,
            iconColor: kFeedGrey900,
            tooltip: 'Close search',
            onTap: onCloseSearch,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: FeedSearchField(
              controller: searchController,
              hint: 'Search posts',
              autofocus: true,
              onChanged: onQueryChanged,
            ),
          ),
        ],
      ),
    );
  }
}
