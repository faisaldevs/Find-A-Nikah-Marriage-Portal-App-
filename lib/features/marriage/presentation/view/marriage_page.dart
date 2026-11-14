import 'package:find_a_nikah/app/di.dart';
import 'package:find_a_nikah/core/ui/ui.dart';
import 'package:find_a_nikah/features/marriage/domain/domain.dart';
import 'package:find_a_nikah/features/marriage/presentation/bloc/marriage_feed_bloc.dart';
import 'package:find_a_nikah/features/marriage/presentation/view/compliment_page.dart';
// import 'package:find_a_nikah/features/marriage/presentation/widgets/compliment_sent_strip.dart'; // now used by profile_scroll.dart
import 'package:find_a_nikah/features/marriage/presentation/widgets/marriage_top_bar.dart';
import 'package:find_a_nikah/features/marriage/presentation/widgets/profile_action_buttons.dart';
// import 'package:find_a_nikah/features/marriage/presentation/widgets/profile_details.dart'; // now used by profile_scroll.dart
// import 'package:find_a_nikah/features/marriage/presentation/widgets/profile_hero.dart'; // now used by profile_scroll.dart
import 'package:find_a_nikah/features/marriage/presentation/widgets/profile_photo.dart';
import 'package:find_a_nikah/features/marriage/presentation/widgets/profile_scroll.dart';
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

  /// Middle button: write the compliment on its own screen, then send it
  /// (the profile shows it above the photo while it goes out).
  Future<void> _compose(BuildContext context, MarriageProfile profile) async {
    final feed = context.read<MarriageFeedBloc>();
    // One compliment per profile: it already counts as a like.
    if (feed.state.isComplimented(profile.id)) {
      CustomToast.showInfo(
        context,
        'Compliment already sent',
        description: 'You already sent ${profile.name} a compliment.',
      );
      return;
    }
    final text = await showComplimentPage(
      context,
      name: profile.name,
      initialText: feed.state.complimentDrafts[profile.id],
    );
    if (text != null) feed.add(MarriageComplimentSubmitted(text));
  }

  /// Footer Block: confirm, then block and move on to the next profile.
  Future<void> _block(BuildContext context, MarriageProfile profile) async {
    final feed = context.read<MarriageFeedBloc>();
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Block ${profile.name}?'),
        content: const Text(
          "They won't be able to see or message you, and you won't see "
          'them again.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text(
              'Block',
              style: TextStyle(color: AppColors.errorColor),
            ),
          ),
        ],
      ),
    );
    if (ok ?? false) feed.add(const MarriageProfileBlocked());
  }

  /// Footer Report: pick a reason, then report (stays on the profile).
  Future<void> _report(BuildContext context, MarriageProfile profile) async {
    final feed = context.read<MarriageFeedBloc>();
    final reason = await showModalBottomSheet<String>(
      context: context,
      useRootNavigator: true,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Text(
                'Report ${profile.name}',
                style: TextFontStyle.headline16w700textDarkStyleSatoshi,
              ),
            ),
            for (final (code, label) in kReportReasons)
              ListTile(
                title: Text(label),
                onTap: () => Navigator.of(context).pop(code),
              ),
          ],
        ),
      ),
    );
    if (reason != null) feed.add(MarriageProfileReported(reason));
  }

  /// A like turned into a match: offer to go and say salaam.
  Future<void> _showMatch(
    BuildContext context, {
    String? name,
    String? photoUrl,
  }) async {
    final chat = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("It's a match!"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (photoUrl != null) ...[
              ClipOval(
                child: SizedBox.square(
                  dimension: 88.r,
                  child: ProfilePhoto(url: photoUrl),
                ),
              ),
              SizedBox(height: 12.h),
            ],
            Text(
              'You and ${name ?? 'they'} liked each other.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Keep browsing'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Send a message'),
          ),
        ],
      ),
    );
    if ((chat ?? false) && context.mounted) context.go(RoutePaths.chat);
  }

  /// After a report: it doesn't hide the profile, so offer to block too.
  Future<void> _offerBlock(BuildContext context) async {
    final feed = context.read<MarriageFeedBloc>();
    final name = feed.state.current?.name ?? 'this member';
    final block = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Report sent'),
        content: Text('Thanks — our team will take a look. Block $name too?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Not now'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text(
              'Block',
              style: TextStyle(color: AppColors.errorColor),
            ),
          ),
        ],
      ),
    );
    if (block ?? false) feed.add(const MarriageProfileBlocked());
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
        MarriageFeedNotice.matched => _showMatch(
          context,
          name: state.matchedName,
          photoUrl: state.matchedPhotoUrl,
        ).ignore(),
        MarriageFeedNotice.blocked => CustomToast.showSuccess(
          context,
          'Member blocked',
        ),
        MarriageFeedNotice.reported => _offerBlock(context).ignore(),
        MarriageFeedNotice.alreadyReported => CustomToast.showInfo(
          context,
          'Already reported',
          description: 'You already have an open report about them.',
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
                      AppMessageView(
                        icon: Icons.inbox_outlined,
                        title: 'No profiles yet',
                        message: 'Try widening your filters.',
                        actionLabel: 'Change filters',
                        onAction: () =>
                            context.push<void>(RoutePaths.addFilters).ignore(),
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
                        // child: ProfileScroll(
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
                        //   child: ProfileScroll(
                        //     key: ValueKey(profile!.id),
                        //     profile: profile,
                        //     heroHeight: heroHeight,
                        //     heroBottomInset: 23.6.h,
                        //     bottomPadding: 24.h,
                        //     actions: ProfileActionButtons(...),
                        //     onComingSoon: (what) =>
                        //         _comingSoon(context, what),
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
                                child: ProfileScroll(
                                  key: ValueKey(profile!.id),
                                  profile: profile,
                                  compliment: state.compliments[profile.id],
                                  complimentDraft:
                                      state.complimentDrafts[profile.id],
                                  onBlock: () => _block(context, profile),
                                  onReport: () => _report(context, profile),
                                  onCompliment: (text) => feed.add(
                                    MarriageComplimentSubmitted(text),
                                  ),
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
                                //     feed.add(
                                //       const MarriageProfileAdvanced()),
                                onCancel: () =>
                                    feed.add(const MarriageProfilePassed()),
                                // Always full colour, per the mockup; no-op
                                // on the first profile.
                                onPrevious: () =>
                                    feed.add(const MarriagePreviousRequested()),
                                // onMessage: () =>
                                //     _comingSoon(context, 'Messaging'),
                                onMessage: () => _compose(context, profile),
                                // onSave: () =>
                                //     feed.add(
                                //       const MarriageProfileAdvanced()),
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

// `_ProfileScroll` moved to widgets/profile_scroll.dart as `ProfileScroll`
// so other screens can show the same profile layout.
