import 'package:find_a_nikah/core/constants/text_font_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../../../../core/router/app_navigator.dart';
import '../state/marriage_feed_controller.dart';
import '../state/marriage_profile.dart';
import '../widgets/marriage_top_bar.dart';
import '../widgets/profile_action_buttons.dart';
import '../widgets/profile_hero.dart';
import '../widgets/profile_style.dart';
import '../widgets/profile_details.dart';
// import '../widgets/profile_photo.dart';

/// Page background above and below the photo (sampled from the mockup).
const _pageBackground = kProfilePageBackground;
// const _pageBackground = Color(0xFFF9FAFC);

/// First bottom-nav tab: one profile at a time. The main photo fills the
/// first screen down to a short strip above the navbar; scrolling reveals
/// the rest of the profile. The 4 action buttons float across the photo's
/// bottom edge.
class MarriageScreen extends ConsumerWidget {
  const MarriageScreen({super.key});

  void _comingSoon(BuildContext context, String what) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text('$what — coming soon')));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(currentMarriageProfileProvider);
    final feed = ref.read(marriageFeedControllerProvider.notifier);
    // Watch the index so the Previous button's enabled state updates.
    // final canGoBack = ref.watch(marriageFeedControllerProvider) > 0;  // Previous is always enabled now

    // Transparent status bar with dark icons, so it blends into the light
    // top bar like the mockup (Android otherwise draws a grey scrim).
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: _pageBackground,
        // backgroundColor: Colors.white,
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              MarriageTopBar(
                onFilters: () => ref.read(appNavigatorProvider).toAddFilters(),
                onSort: () => _comingSoon(context, 'Sort'),
                onNotifications: () => _comingSoon(context, 'Notifications'),
              ),
              Expanded(
                child: profile == null
                    ? Center(
                        child: Text(
                          'No profiles yet',
                          style:
                              TextFontStyle.headline15w400textMutedStyleSatoshi,
                        ),
                      )
                    : LayoutBuilder(
                        builder: (context, constraints) {
                          // Geometry from the full-profile mockup (390×844):
                          // the main photo stops 48 above the navbar (the
                          // cream filters band peeks out below it) and the
                          // buttons float with their bottom 7 above the
                          // photo's bottom edge. The whole profile scrolls
                          // under them.
                          final viewport = constraints.maxHeight;
                          final heroHeight = viewport - 48.h;
                          final button = kProfileActionButtonSize.r;
                          final buttonsTop = heroHeight - 65.h;
                          return Stack(
                            children: [
                              Positioned.fill(
                                child: AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 250),
                                  // New key per profile → fresh scroll
                                  // position (back at the top) on
                                  // Cancel/Save/Previous.
                                  child: _ProfileScroll(
                                    key: ValueKey(profile.id),
                                    profile: profile,
                                    heroHeight: heroHeight,
                                    // Details end just above the buttons.
                                    heroBottomInset: 23.6.h,
                                    // Last row (Favourite · Block · Report)
                                    // scrolls clear of the buttons.
                                    bottomPadding: viewport - buttonsTop + 16.h,
                                    onComingSoon: (what) =>
                                        _comingSoon(context, what),
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 0,
                                right: 0,
                                top: buttonsTop,
                                height: button,
                                child: ProfileActionButtons(
                                  onCancel: feed.next,
                                  // Always full colour, per the mockup; no-op on the first profile.
                                  onPrevious: feed.previous,
                                  // onPrevious: canGoBack ? feed.previous : null,
                                  onMessage: () =>
                                      _comingSoon(context, 'Messaging'),
                                  onSave: feed.next,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                // Previous layout (first-screen mockup): photo stopped 48 above
                // the navbar over an empty strip with a shadow; buttons straddled
                // the photo's bottom edge; only extra photos below.
                //     : LayoutBuilder(
                //         builder: (context, constraints) {
                //           // Geometry measured from the mockup (390-wide):
                //           // the photo stops 48 above the navbar, and the
                //           // buttons straddle its bottom edge with their
                //           // centre 8 below it.
                //           final strip = 48.h;
                //           final button = kProfileActionButtonSize.r;
                //           final viewport = constraints.maxHeight - strip;
                //           final buttonsTop = viewport - button / 2 + 8.h;
                //           return Stack(
                //             children: [
                //               Positioned(
                //                 top: 0,
                //                 left: 0,
                //                 right: 0,
                //                 height: viewport,
                //                 child: AnimatedSwitcher(
                //                   duration: const Duration(milliseconds: 250),
                //                   // New key per profile → fresh scroll
                //                   // position (back at the top) on
                //                   // Cancel/Save/Previous.
                //                   child: _ProfileScroll(
                //                     key: ValueKey(profile.id),
                //                     profile: profile,
                //                     heroHeight: viewport,
                //                     // Details end just above the buttons.
                //                     heroBottomInset: 28.h,
                //                     // Last content clears the buttons'
                //                     // overlap with the viewport.
                //                     bottomPadding: button / 2 + 8.h,
                //                   ),
                //                 ),
                //               ),
                //               // Soft shadow under the photo's bottom edge.
                //               Positioned(
                //                 top: viewport,
                //                 left: 0,
                //                 right: 0,
                //                 height: 16.h,
                //                 child: const DecoratedBox(
                //                   decoration: BoxDecoration(
                //                     gradient: LinearGradient(
                //                       begin: Alignment.topCenter,
                //                       end: Alignment.bottomCenter,
                //                       colors: [
                //                         Color(0x14000000),
                //                         Color(0x00000000),
                //                       ],
                //                     ),
                //                   ),
                //                 ),
                //               ),
                //               Positioned(
                //                 left: 0,
                //                 right: 0,
                //                 top: buttonsTop,
                //                 child: ProfileActionButtons(
                //                   onCancel: feed.next,
                //                   // Always full colour, per the mockup; no-op on the first profile.
                //                   onPrevious: feed.previous,
                //                   // onPrevious: canGoBack ? feed.previous : null,
                //                   onMessage: () =>
                //                       _comingSoon(context, 'Messaging'),
                //                   onSave: feed.next,
                //                 ),
                //               ),
                //             ],
                //           );
                //         },
                //       ),
                // Previous layout: photo ran down to the navbar with the
                // buttons fully on top of it.
                // : LayoutBuilder(
                //     builder: (context, constraints) {
                //       final buttonsBottom = 16.h;
                //       final buttonsHeight = 54.r;
                //       return Stack(
                //         children: [
                //           AnimatedSwitcher(
                //             duration: const Duration(milliseconds: 250),
                //             // New key per profile → fresh scroll position
                //             // (back at the top) on Cancel/Save/Previous.
                //             child: _ProfileScroll(
                //               key: ValueKey(profile.id),
                //               profile: profile,
                //               heroHeight: constraints.maxHeight,
                //               buttonsClearance:
                //                   buttonsBottom + buttonsHeight + 16.h,
                //             ),
                //           ),
                //           Positioned(
                //             left: 0,
                //             right: 0,
                //             bottom: buttonsBottom,
                //             child: ProfileActionButtons(
                //               onCancel: feed.next,
                //               onPrevious: canGoBack ? feed.previous : null,
                //               onMessage: () =>
                //                   _comingSoon(context, 'Messaging'),
                //               onSave: feed.next,
                //             ),
                //           ),
                //         ],
                //       );
                //     },
                //   ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileScroll extends StatelessWidget {
  const _ProfileScroll({
    super.key,
    required this.profile,
    required this.heroHeight,
    required this.heroBottomInset,
    required this.bottomPadding,
    required this.onComingSoon,
  });

  final MarriageProfile profile;
  final double heroHeight;

  /// Gap between the details and the photo's bottom edge.
  final double heroBottomInset;
  final double bottomPadding;

  /// Snackbar for actions that aren't wired up yet.
  final ValueChanged<String> onComingSoon;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ProfileHero(
            profile: profile,
            height: heroHeight,
            bottomInset: heroBottomInset,
          ),
          ProfileDetails(
            profile: profile,
            bottomPadding: bottomPadding,
            onCheckFilters: () => onComingSoon('Filter match'),
            onCompliment: (_) => ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(content: Text('Compliment sent to ${profile.name}')),
              ),
            onShare: () => onComingSoon('Share profile'),
            onFavourite: () => onComingSoon('Favourite'),
            onBlock: () => onComingSoon('Block'),
            onReport: () => onComingSoon('Report'),
          ),
        ],
      ),
    );
    // Before the full-profile design: only the extra photos, as rounded
    // cards, under the hero.
    // return SingleChildScrollView(
    //   padding: EdgeInsets.only(bottom: bottomPadding),
    //   child: Column(
    //     children: [
    //       ProfileHero(
    //         profile: profile,
    //         height: heroHeight,
    //         bottomInset: heroBottomInset,
    //       ),
    //       for (final url in profile.photoUrls.skip(1))
    //         Padding(
    //           padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 0),
    //           child: ClipRRect(
    //             borderRadius: BorderRadius.circular(16.r),
    //             child: SizedBox(
    //               height: heroHeight * 0.75,
    //               child: ProfilePhoto(url: url),
    //             ),
    //           ),
    //         ),
    //     ],
    //   ),
    // );
  }
}
