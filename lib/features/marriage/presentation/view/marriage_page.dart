import 'package:find_a_nikah/app/di.dart';
import 'package:find_a_nikah/core/ui/ui.dart';
import 'package:find_a_nikah/features/marriage/domain/domain.dart';
import 'package:find_a_nikah/features/marriage/presentation/bloc/marriage_feed_bloc.dart';
import 'package:find_a_nikah/features/marriage/presentation/widgets/marriage_top_bar.dart';
import 'package:find_a_nikah/features/marriage/presentation/widgets/profile_action_buttons.dart';
import 'package:find_a_nikah/features/marriage/presentation/widgets/profile_details.dart';
import 'package:find_a_nikah/features/marriage/presentation/widgets/profile_hero.dart';
import 'package:find_a_nikah/features/marriage/presentation/widgets/profile_style.dart';
import 'package:find_a_nikah/router/route_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:go_router/go_router.dart';

/// Page background above and below the photo (sampled from the mockup).
const Color _pageBackground = kProfilePageBackground;

/// First bottom-nav tab: one profile at a time. The main photo fills the
/// first screen down to a short strip above the navbar; scrolling reveals
/// the rest of the profile. The 4 action buttons are pinned at the bottom
/// of the page (first screen: across the photo's bottom edge) and the
/// profile scrolls under them.
class MarriagePage extends StatelessWidget {
  const MarriagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          getIt<MarriageFeedBloc>()..add(const MarriageFeedSubscribed()),
      child: const _MarriageView(),
    );
  }
}

class _MarriageView extends StatelessWidget {
  const _MarriageView();

  void _comingSoon(BuildContext context, String what) {
    CustomToast.showInfo(context, '$what — coming soon');
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<MarriageFeedBloc>().state;
    final profile = state.current;
    final feed = context.read<MarriageFeedBloc>();

    // Transparent status bar with dark icons, so it blends into the light
    // top bar like the mockup (Android otherwise draws a grey scrim).
    return BlocListener<MarriageFeedBloc, MarriageFeedState>(
      listenWhen: (prev, next) => prev.notice != next.notice,
      listener: (context, state) => switch (state.notice) {
        MarriageFeedNotice.matched => CustomToast.showSuccess(
          context,
          "It's a match!",
          description: 'You and ${state.matchedName} liked each other.',
        ),
        MarriageFeedNotice.undoUnavailable => CustomToast.showInfo(
          context,
          "Likes can't be undone",
        ),
        MarriageFeedNotice.actionFailed => showFailureToast(
          context,
          state.actionFailure!,
        ),
        null => null,
      },
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark.copyWith(
          statusBarColor: Colors.transparent,
        ),
        child: Scaffold(
          backgroundColor: _pageBackground,
          body: SafeArea(
            bottom: false,
            child: Column(
              children: [
                MarriageTopBar(
                  onFilters: () =>
                      context.push<void>(RoutePaths.addFilters).ignore(),
                  onSort: () => _comingSoon(context, 'Sort'),
                  onNotifications: () => _comingSoon(context, 'Notifications'),
                ),
                Expanded(
                  child: switch (state.status) {
                    MarriageFeedStatus.initial ||
                    MarriageFeedStatus.loading => const AppLoadingView(),
                    MarriageFeedStatus.failure => AppErrorView(
                      title: state.failure!.title,
                      message: state.failure!.message,
                      retryLabel: 'Try again',
                      onRetry: () => feed.add(const MarriageFeedSubscribed()),
                    ),
                    MarriageFeedStatus.ready when profile == null =>
                      const AppEmptyView(
                        title: 'No profiles yet',
                        message: 'Try widening your filters.',
                      ),
                    MarriageFeedStatus.ready => LayoutBuilder(
                      builder: (context, constraints) {
                        // Geometry from the full-profile mockup (390×844):
                        // the main photo stops 48 above the navbar (the
                        // cream filters band peeks out below it) and the
                        // buttons float with their bottom 7 above the
                        // photo's bottom edge. The whole profile scrolls
                        // under them.
                        // final viewport = constraints.maxHeight;
                        // final heroHeight = viewport - 48.h;
                        // final button = kProfileActionButtonSize.r;
                        // final buttonsTop = heroHeight - 65.h;
                        // return Stack(
                        // children: [
                        // Positioned.fill(
                        // child: AnimatedSwitcher(
                        // duration: const Duration(milliseconds: 250),
                        // // New key per profile → fresh scroll
                        // // position (back at the top) on
                        // // Cancel/Save/Previous.
                        // child: _ProfileScroll(
                        // key: ValueKey(profile!.id),
                        // profile: profile,
                        // heroHeight: heroHeight,
                        // // Details end just above the buttons.
                        // heroBottomInset: 23.6.h,
                        // // Last row (Favourite · Block · Report)
                        // // scrolls clear of the buttons.
                        // bottomPadding: viewport - buttonsTop + 16.h,
                        // onComingSoon: (what) =>
                        // _comingSoon(context, what),
                        // ),
                        // ),
                        // ),
                        // Positioned(
                        // left: 0,
                        // right: 0,
                        // top: buttonsTop,
                        // height: button,
                        // child: ProfileActionButtons(
                        // onCancel: () => feed.add(
                        // const MarriageProfileAdvanced(),
                        // ),
                        // // Always full colour, per the mockup;
                        // // no-op on the first profile.
                        // onPrevious: () => feed.add(
                        // const MarriagePreviousRequested(),
                        // ),
                        // onMessage: () =>
                        // _comingSoon(context, 'Messaging'),
                        // onSave: () => feed.add(
                        // const MarriageProfileAdvanced(),
                        // ),
                        // ),
                        // ),
                        // ],
                        // );
                        // Figma 1157:5788 / 1157:6375: the buttons straddle
                        // the photo card's bottom edge (19pt over it) and
                        // scroll away with it — pinned, they covered the info
                        // grid and every section below (audit #45/#46).
                        // final viewport = constraints.maxHeight;
                        // final heroHeight = viewport - 48.h;
                        // return AnimatedSwitcher(
                        //   duration: const Duration(milliseconds: 250),
                        //   // New key per profile → fresh scroll position.
                        //   child: _ProfileScroll(
                        //     key: ValueKey(profile!.id),
                        //     profile: profile,
                        //     heroHeight: heroHeight,
                        //     heroBottomInset: 23.6.h,
                        //     bottomPadding: 24.h,
                        //     actions: ProfileActionButtons(...),
                        //     onComingSoon: (what) => _comingSoon(context, what),
                        //   ),
                        // );
                        // Pinned again, per the reference app: the buttons
                        // stay at the bottom of the page for the whole
                        // scroll (first screen: across the photo's bottom
                        // edge, as before) and the profile scrolls under
                        // them. "Bottom of the page" is right above the
                        // navbar inside the app shell; shown on its own,
                        // the bottom safe-area inset keeps them off the
                        // home indicator (0 inside the shell — the
                        // navbar's Scaffold already removes it).
                        final viewport = constraints.maxHeight;
                        final bottomInset = MediaQuery.paddingOf(
                          context,
                        ).bottom;
                        final heroHeight = viewport - 48.h - bottomInset;
                        final button = kProfileActionButtonSize.r;
                        // final buttonsTop = heroHeight - 65.h;
                        // Figma 1157:5788: 19pt over the photo's bottom edge
                        // (at 65 they covered the info grid's last row) —
                        // which leaves them ~9pt above the navbar.
                        final buttonsTop = heroHeight - 19.h;
                        return Stack(
                          children: [
                            Positioned.fill(
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 250),
                                // New key per profile → fresh scroll position
                                // (back at the top) on Cancel/Save/Previous.
                                child: _ProfileScroll(
                                  key: ValueKey(profile!.id),
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
                                // onCancel: () =>
                                //     feed.add(const MarriageProfileAdvanced()),
                                onCancel: () =>
                                    feed.add(const MarriageProfilePassed()),
                                // Always full colour, per the mockup; no-op
                                // on the first profile.
                                onPrevious: () =>
                                    feed.add(const MarriagePreviousRequested()),
                                onMessage: () =>
                                    _comingSoon(context, 'Messaging'),
                                // onSave: () =>
                                //     feed.add(const MarriageProfileAdvanced()),
                                onSave: () =>
                                    feed.add(const MarriageProfileLiked()),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ProfileScroll extends StatelessWidget {
  const _ProfileScroll({
    required this.profile,
    required this.heroHeight,
    required this.heroBottomInset,
    required this.bottomPadding,
    required this.onComingSoon,
    // required this.actions,
    super.key,
  });

  final MarriageProfile profile;
  final double heroHeight;

  /// Gap between the details and the photo's bottom edge.
  final double heroBottomInset;
  final double bottomPadding;

  /// Snackbar for actions that aren't wired up yet.
  final ValueChanged<String> onComingSoon;

  // Scrolled with the hero; now pinned by the page instead.
  // /// Pass / undo / message / like row, laid over the hero's bottom edge.
  // final Widget actions;

  @override
  Widget build(BuildContext context) {
    // return SingleChildScrollView(
    // child: Column(
    // children: [
    // ProfileHero(
    // profile: profile,
    // height: heroHeight,
    // bottomInset: heroBottomInset,
    // ),
    // ProfileDetails(
    // profile: profile,
    // bottomPadding: bottomPadding,
    // onCheckFilters: () => onComingSoon('Filter match'),
    // onCompliment: (_) => CustomToast.showSuccess(
    // context,
    // 'Compliment sent',
    // description: 'Your compliment was sent to ${profile.name}.',
    // ),
    // onShare: () => onComingSoon('Share profile'),
    // onFavourite: () => onComingSoon('Favourite'),
    // onBlock: () => onComingSoon('Block'),
    // onReport: () => onComingSoon('Report'),
    // ),
    // ],
    // ),
    // );
    // // Before the full-profile design: only the extra photos, as rounded
    // // cards, under the hero.
    // // return SingleChildScrollView(
    // //   padding: EdgeInsets.only(bottom: bottomPadding),
    // //   child: Column(
    // //     children: [
    // //       ProfileHero(
    // //         profile: profile,
    // //         height: heroHeight,
    // //         bottomInset: heroBottomInset,
    // //       ),
    // //       for (final url in profile.photoUrls.skip(1))
    // //         Padding(
    // //           padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 0),
    // //           child: ClipRRect(
    // //             borderRadius: BorderRadius.circular(16.r),
    // //             child: SizedBox(
    // //               height: heroHeight * 0.75,
    // //               child: ProfilePhoto(url: url),
    // //             ),
    // //           ),
    // //         ),
    // //     ],
    // //   ),
    // // );

    // Buttons straddling the photo's edge and scrolling away with it
    // (replaced: they're pinned by the page now):
    // final button = kProfileActionButtonSize.r;
    // final overlap = 19.h;
    // return SingleChildScrollView(
    //   child: Stack(
    //     clipBehavior: Clip.none,
    //     children: [
    //       Column(
    //         children: [
    //           ProfileHero(...),
    //           // Room for the part of the buttons below the photo.
    //           SizedBox(height: button - overlap + 12.h),
    //           ProfileDetails(...),
    //         ],
    //       ),
    //       Positioned(
    //         left: 0,
    //         right: 0,
    //         top: heroHeight - overlap,
    //         height: button,
    //         child: actions,
    //       ),
    //     ],
    //   ),
    // );
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
            onCompliment: (_) => CustomToast.showSuccess(
              context,
              'Compliment sent',
              description: 'Your compliment was sent to ${profile.name}.',
            ),
            onShare: () => onComingSoon('Share profile'),
            onFavourite: () => onComingSoon('Favourite'),
            onBlock: () => onComingSoon('Block'),
            onReport: () => onComingSoon('Report'),
          ),
        ],
      ),
    );
  }
}
