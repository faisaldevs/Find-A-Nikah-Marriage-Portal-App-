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
/// the rest of the profile. The 4 action buttons float across the photo's
/// bottom edge.
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
    return AnnotatedRegion<SystemUiOverlayStyle>(
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
                              onCancel: () => feed.add(
                                const MarriageProfileAdvanced(),
                              ),
                              // Always full colour, per the mockup;
                              // no-op on the first profile.
                              onPrevious: () => feed.add(
                                const MarriagePreviousRequested(),
                              ),
                              onMessage: () =>
                                  _comingSoon(context, 'Messaging'),
                              onSave: () => feed.add(
                                const MarriageProfileAdvanced(),
                              ),
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
    super.key,
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
