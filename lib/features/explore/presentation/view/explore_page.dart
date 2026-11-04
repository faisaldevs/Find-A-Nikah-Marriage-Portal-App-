import 'package:find_a_nikah/app/di.dart';
import 'package:find_a_nikah/core/ui/ui.dart';
import 'package:find_a_nikah/features/explore/domain/domain.dart';
import 'package:find_a_nikah/features/explore/presentation/bloc/explore_bloc.dart';
import 'package:find_a_nikah/features/explore/presentation/widgets/explore_big_card.dart';
import 'package:find_a_nikah/features/explore/presentation/widgets/explore_cta_button.dart';
import 'package:find_a_nikah/features/explore/presentation/widgets/explore_grid_card.dart';
import 'package:find_a_nikah/features/explore/presentation/widgets/explore_history_card.dart';
import 'package:find_a_nikah/features/explore/presentation/widgets/explore_history_filter_bar.dart';
import 'package:find_a_nikah/features/explore/presentation/widgets/explore_section_header.dart';
import 'package:find_a_nikah/features/explore/presentation/widgets/explore_small_card.dart';
import 'package:find_a_nikah/features/explore/presentation/widgets/explore_style.dart';
import 'package:find_a_nikah/features/explore/presentation/widgets/explore_tabs.dart';
import 'package:find_a_nikah/features/explore/presentation/widgets/explore_top_bar.dart';
import 'package:find_a_nikah/features/explore/presentation/widgets/near_end_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:go_router/go_router.dart';

/// Second bottom-nav tab: a "For you" feed of six sections (some gated
/// behind the premium lock) and a "My history" tab of liked/favourited/
/// passed/complimented profiles, filtered by a 4-way chip row.
class ExplorePage extends StatelessWidget {
  const ExplorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ExploreBloc>()..add(const ExploreSubscribed()),
      child: const _ExploreView(),
    );
  }
}

class _ExploreView extends StatefulWidget {
  const _ExploreView();

  @override
  State<_ExploreView> createState() => _ExploreViewState();
}

class _ExploreViewState extends State<_ExploreView> {
  final _scrollController = ScrollController();
  ExploreTab _tab = ExploreTab.forYou;
  // Mockup's top-of-page state is the crown-only circle.
  bool _ctaExpanded = false;
  ExploreHistoryFilter _historyFilter = ExploreHistoryFilter.liked;
  bool _historyRequested = false;

  void _onTabChanged(ExploreTab tab) {
    setState(() => _tab = tab);
    if (tab == ExploreTab.myHistory && !_historyRequested) {
      _historyRequested = true;
      context.read<ExploreBloc>().add(const ExploreHistoryRequested());
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _comingSoon(String what) =>
      CustomToast.showInfo(context, '$what — coming soon');

  void _premiumGate() => CustomToast.showInfo(
    context,
    'Premium feature',
    description: "Upgrade to see who's interested — coming soon.",
  );

  // Per the user: expands while scrolling down, shrinks to the crown-only
  // circle while scrolling up (the opposite of the usual "shrink on
  // scroll-down to save space" pattern — an explicit call, not a default).
  bool _onScroll(ScrollNotification notification) {
    if (notification is! ScrollUpdateNotification) return false;
    // Only the page's own vertical scroll — the sideways card strips'
    // notifications bubble up here too.
    if (notification.depth != 0) return false;
    final delta = notification.scrollDelta ?? 0;
    if (delta > 6 && !_ctaExpanded) {
      setState(() => _ctaExpanded = true);
    } else if (delta < -6 && _ctaExpanded) {
      setState(() => _ctaExpanded = false);
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    // Header (status bar, top bar, tab labels) is white; the page below the
    // tab bar is the grey `kExplorePageBackground`.
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            ExploreTopBar(onFilters: () => _comingSoon('Filters')),
            ExploreTabBar(selected: _tab, onChanged: _onTabChanged),
            Expanded(
              child: ColoredBox(
                color: kExplorePageBackground,
                child: Stack(
                  children: [
                    switch (_tab) {
                      ExploreTab.forYou => _ForYouTab(
                        scrollController: _scrollController,
                        onScroll: _onScroll,
                        onCardTap: () => _comingSoon('Profile'),
                        onLockedTap: _premiumGate,
                      ),
                      ExploreTab.myHistory => _MyHistoryTab(
                        filter: _historyFilter,
                        onFilterChanged: (f) =>
                            setState(() => _historyFilter = f),
                        onCardTap: () => _comingSoon('Profile'),
                      ),
                    },
                    // Figma's My history frames have no crown CTA (#49).
                    if (_tab == ExploreTab.forYou)
                      Positioned(
                        right: kExploreGutter,
                        bottom: 24.h,
                        child: ExploreCtaButton(
                          expanded: _ctaExpanded,
                          onTap: _premiumGate,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ForYouTab extends StatelessWidget {
  const _ForYouTab({
    required this.scrollController,
    required this.onScroll,
    required this.onCardTap,
    required this.onLockedTap,
  });

  final ScrollController scrollController;
  final bool Function(ScrollNotification) onScroll;
  final VoidCallback onCardTap;
  final VoidCallback onLockedTap;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<ExploreBloc>().state;
    // Superseded: the whole tab waited on the dummy feed behind one
    // spinner, which also hid the cached live sections on every reopen.
    // Each section now handles its own loading state.
    // return switch (state.status) {
    //   ExploreStatus.initial ||
    //   ExploreStatus.loading => const AppLoadingView(),
    //   ExploreStatus.failure => AppErrorView(
    //     title: state.failure!.title,
    //     message: state.failure!.message,
    //     retryLabel: 'Try again',
    //     onRetry: () =>
    //         context.read<ExploreBloc>().add(const ExploreSubscribed()),
    //   ),
    //   ExploreStatus.ready => NotificationListener<ScrollNotification>(
    return NotificationListener<ScrollNotification>(
      onNotification: onScroll,
      child: SingleChildScrollView(
        controller: scrollController,
        // Mockup: first header row starts 41.75pt under the tab bar;
        // each section ends ~42.5pt above the next header (see _sectionGap).
        padding: EdgeInsets.only(top: 41.75.w, bottom: 184.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // _HorizontalSection(
            //   title: 'Likes in your filters',
            //   count: state.feed.likesInFilters.count,
            //   cardHeight: ExploreBigCard.height,
            //   gap: ExploreBigCard.gap,
            //   itemCount: state.feed.likesInFilters.profiles.length,
            //   itemBuilder: (context, i) => ExploreBigCard(
            //     profile: state.feed.likesInFilters.profiles[i],
            //     locked: true,
            //     onTap: onLockedTap,
            //   ),
            // ),
            // _HorizontalSection(
            //   title: 'Take a second look',
            //   subtitle:
            //       'You previously passed on their profile but they liked '
            //       'you afterwards.',
            //   count: state.feed.secondLook.count,
            //   cardHeight: ExploreSmallCard.height,
            //   gap: ExploreSmallCard.gap,
            //   itemCount: state.feed.secondLook.profiles.length,
            //   itemBuilder: (context, i) => ExploreSmallCard(
            //     profile: state.feed.secondLook.profiles[i],
            //     onTap: onCardTap,
            //   ),
            // ),
            // Real API. Locked (free member) cards show with the lock and
            // don't open; unlocked behave like any other card.
            _LiveHorizontalSection(
              section: ExploreLiveSection.likesInFilters,
              // Was 'Likes in your filters' — the API returns everyone who
              // liked me, not just those inside my filters.
              title: 'People who liked you',
              subtitle: 'Members who liked your profile.',
              cardWidth: ExploreBigCard.width,
              cardHeight: ExploreBigCard.height,
              gap: ExploreBigCard.gap,
              cardBuilder: (profile, {required locked}) => ExploreBigCard(
                profile: profile,
                locked: locked,
                onTap: locked ? _noTap : onCardTap,
              ),
            ),
            _LiveHorizontalSection(
              section: ExploreLiveSection.secondLook,
              title: 'Take a second look',
              subtitle:
                  'You previously passed on their profile but they liked '
                  'you afterwards.',
              cardWidth: ExploreSmallCard.width,
              cardHeight: ExploreSmallCard.height,
              gap: ExploreSmallCard.gap,
              cardBuilder: (profile, {required locked}) => ExploreSmallCard(
                profile: profile,
                locked: locked,
                onTap: locked ? _noTap : onCardTap,
              ),
            ),
            // Still dummy (no API): shimmer while the dummy feed loads,
            // hidden if it fails.
            switch (state.status) {
              ExploreStatus.initial ||
              ExploreStatus.loading => const _GridSectionShimmer(
                title: 'Currently available',
                subtitle:
                    'Members who have at least one slot available to chat.',
                showCrown: true,
              ),
              ExploreStatus.failure => const SizedBox.shrink(),
              ExploreStatus.ready => _GridSection(
                title: 'Currently available',
                subtitle:
                    'Members who have at least one slot available to chat.',
                showCrown: true,
                profiles: state.feed.currentlyAvailable.profiles,
                // Everything is free for now — no premium lock.
                // locked: true,
                // onTap: onLockedTap,
                locked: false,
                onTap: onCardTap,
              ),
            },
            // _HorizontalSection(
            //   title: 'Visited you',
            //   subtitle:
            //       "See who's interested, they might be your perfect "
            //       'match.',
            //   count: state.feed.visitedYou.count,
            //   cardHeight: ExploreSmallCard.height,
            //   gap: ExploreSmallCard.gap,
            //   itemCount: state.feed.visitedYou.profiles.length,
            //   itemBuilder: (context, i) => ExploreSmallCard(
            //     profile: state.feed.visitedYou.profiles[i],
            //     onTap: onCardTap,
            //   ),
            // ),
            _LiveHorizontalSection(
              section: ExploreLiveSection.visitedYou,
              title: 'Visited you',
              subtitle:
                  "See who's interested, they might be your perfect match.",
              cardWidth: ExploreSmallCard.width,
              cardHeight: ExploreSmallCard.height,
              gap: ExploreSmallCard.gap,
              cardBuilder: (profile, {required locked}) => ExploreSmallCard(
                profile: profile,
                locked: locked,
                onTap: locked ? _noTap : onCardTap,
              ),
            ),
            // _GridSection(
            //   title: 'Just joined',
            //   subtitle: 'Meet new potential matches who recently joined.',
            //   showCrown: true,
            //   profiles: state.feed.justJoined.profiles,
            //   locked: true,
            //   onTap: onLockedTap,
            // ),
            _LiveGridSection(
              section: ExploreLiveSection.justJoined,
              title: 'Just joined',
              subtitle: 'Meet new potential matches who recently joined.',
              showCrown: true,
              // Everything is free for now; the API's `locked` flag still
              // applies if the backend sends it.
              // locked: true,
              // onTap: onLockedTap,
              locked: false,
              onTap: onCardTap,
            ),
            // _GridSection(
            //   title: 'Active near you',
            //   subtitle: 'These members are active now.',
            //   showCrown: false,
            //   profiles: state.feed.activeNearYou.profiles,
            //   locked: false,
            //   onTap: onCardTap,
            //   last: true,
            // ),
            _LiveGridSection(
              section: ExploreLiveSection.activeNearYou,
              title: 'Active near you',
              subtitle: 'These members are active now.',
              showCrown: false,
              locked: false,
              onTap: onCardTap,
              last: true,
            ),
          ],
        ),
      ),
    );
  }
}

/// Tap target for locked live cards: they show, but don't open.
void _noTap() {}

/// Space between one section's cards and the next section's header.
double get _sectionGap => 42.5.w;

class _HorizontalSection extends StatelessWidget {
  const _HorizontalSection({
    required this.title,
    required this.count,
    required this.cardHeight,
    required this.gap,
    required this.itemCount,
    required this.itemBuilder,
    this.subtitle,
    this.cardWidth = 0,
    this.loadingMore = false,
    this.onLoadMore,
  });

  final String title;
  final String? subtitle;
  final int count;
  final double cardHeight;
  final double gap;
  final int itemCount;
  final Widget Function(BuildContext, int) itemBuilder;

  /// Paging (see [_GridSection]): [cardWidth] sizes the shimmer card that
  /// trails the row while [loadingMore] and the "near the end" distance.
  final double cardWidth;
  final bool loadingMore;
  final VoidCallback? onLoadMore;

  @override
  Widget build(BuildContext context) {
    if (itemCount == 0) return const SizedBox.shrink();
    final header = ExploreSectionHeader(
      title: title,
      subtitle: subtitle,
      count: count,
    );
    return Padding(
      padding: EdgeInsets.only(bottom: _sectionGap),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          header,
          SizedBox(height: header.bottomGap),
          SizedBox(
            height: cardHeight.w,
            child: NearEndLoader(
              threshold: 2 * (cardWidth + gap).w,
              itemCount: itemCount,
              onLoadMore: onLoadMore,
              loading: loadingMore,
              builder: (controller) => ListView.separated(
                controller: controller,
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: kExploreGutter),
                itemCount: itemCount + (loadingMore ? 1 : 0),
                separatorBuilder: (_, _) => SizedBox(width: gap.w),
                itemBuilder: (context, i) => i == itemCount
                    ? AppShimmer(
                        child: AppShimmerBox(
                          width: cardWidth.w,
                          height: cardHeight.w,
                          radius: 4.r,
                        ),
                      )
                    : itemBuilder(context, i),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Two rows of [ExploreGridCard]s that scroll sideways together — the
/// mockup's fourth column runs off the screen edge. Filled column by
/// column (1 top / 2 bottom, 3 top / 4 bottom, …) so a new page appends
/// columns without moving the cards already on screen.
///
/// Paged when [onLoadMore] is set: called once the strip is within two
/// columns of its end (or doesn't fill the width), and a shimmer column
/// trails the cards while [loadingMore].
class _GridSection extends StatelessWidget {
  const _GridSection({
    required this.title,
    required this.subtitle,
    required this.showCrown,
    required this.profiles,
    required this.locked,
    required this.onTap,
    this.last = false,
    this.loadingMore = false,
    this.onLoadMore,
  });

  final String title;
  final String subtitle;
  final bool showCrown;
  final List<ExploreProfile> profiles;
  final bool locked;
  final VoidCallback onTap;
  final bool last;
  final bool loadingMore;
  final VoidCallback? onLoadMore;

  @override
  Widget build(BuildContext context) {
    if (profiles.isEmpty) return const SizedBox.shrink();
    final header = ExploreSectionHeader(
      title: title,
      subtitle: subtitle,
      showCrown: showCrown,
    );
    final columns = (profiles.length + 1) ~/ 2;
    final cardHeight = ExploreGridCard.width.w * kExploreCardAspect;
    Widget card(int i) =>
        ExploreGridCard(profile: profiles[i], locked: locked, onTap: onTap);
    return Padding(
      padding: EdgeInsets.only(bottom: last ? 0 : _sectionGap),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          header,
          SizedBox(height: header.bottomGap),
          SizedBox(
            height: cardHeight * 2 + ExploreGridCard.gap.w,
            child: NearEndLoader(
              threshold: 2 * (ExploreGridCard.width + ExploreGridCard.gap).w,
              itemCount: profiles.length,
              onLoadMore: onLoadMore,
              loading: loadingMore,
              builder: (controller) => ListView.separated(
                controller: controller,
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: kExploreGutter),
                itemCount: columns + (loadingMore ? 1 : 0),
                separatorBuilder: (_, _) =>
                    SizedBox(width: ExploreGridCard.gap.w),
                itemBuilder: (context, c) {
                  if (c == columns) return const _ShimmerColumn();
                  final top = c * 2;
                  return Column(
                    children: [
                      card(top),
                      if (top + 1 < profiles.length) ...[
                        SizedBox(height: ExploreGridCard.gap.w),
                        card(top + 1),
                      ],
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// A [_HorizontalSection] on a real API ([ExploreLiveSection]): shimmer on
/// a first load with no cache, hidden if that fails or has no profiles,
/// paged once ready. [cardBuilder] gets the section's `locked` flag.
class _LiveHorizontalSection extends StatelessWidget {
  const _LiveHorizontalSection({
    required this.section,
    required this.title,
    required this.cardWidth,
    required this.cardHeight,
    required this.gap,
    required this.cardBuilder,
    this.subtitle,
  });

  final ExploreLiveSection section;
  final String title;
  final String? subtitle;
  final double cardWidth;
  final double cardHeight;
  final double gap;
  final Widget Function(ExploreProfile profile, {required bool locked})
  cardBuilder;

  @override
  Widget build(BuildContext context) {
    final live = context.select<ExploreBloc, ExploreLiveState>(
      (b) => b.state.liveOf(section),
    );
    final data = live.section;
    return switch (live.status) {
      ExploreStatus.initial || ExploreStatus.loading => _ShimmerRowSection(
        title: title,
        subtitle: subtitle,
        cardWidth: cardWidth,
        cardHeight: cardHeight,
        gap: gap,
      ),
      ExploreStatus.failure => const SizedBox.shrink(),
      ExploreStatus.ready => _HorizontalSection(
        title: title,
        subtitle: subtitle,
        count: data.count,
        cardWidth: cardWidth,
        cardHeight: cardHeight,
        gap: gap,
        itemCount: data.profiles.length,
        itemBuilder: (context, i) =>
            cardBuilder(data.profiles[i], locked: data.locked),
        loadingMore: live.loadingMore,
        onLoadMore: data.hasMore
            ? () => context.read<ExploreBloc>().add(
                ExploreLiveMoreRequested(section),
              )
            : null,
      ),
    };
  }
}

/// First-load skeleton of a [_HorizontalSection]: real header, one row of
/// card-sized shimmer blocks running off the right edge.
class _ShimmerRowSection extends StatelessWidget {
  const _ShimmerRowSection({
    required this.title,
    required this.cardWidth,
    required this.cardHeight,
    required this.gap,
    this.subtitle,
  });

  final String title;
  final String? subtitle;
  final double cardWidth;
  final double cardHeight;
  final double gap;

  @override
  Widget build(BuildContext context) {
    final header = ExploreSectionHeader(title: title, subtitle: subtitle);
    return Padding(
      padding: EdgeInsets.only(bottom: _sectionGap),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          header,
          SizedBox(height: header.bottomGap),
          SizedBox(
            height: cardHeight.w,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: kExploreGutter),
              itemCount: 4,
              separatorBuilder: (_, _) => SizedBox(width: gap.w),
              itemBuilder: (_, _) => AppShimmer(
                child: AppShimmerBox(
                  width: cardWidth.w,
                  height: cardHeight.w,
                  radius: 4.r,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// A [_GridSection] on a real API ([ExploreLiveSection]): shimmer on a
/// first load with no cache, hidden if that fails, paged once ready.
class _LiveGridSection extends StatelessWidget {
  const _LiveGridSection({
    required this.section,
    required this.title,
    required this.subtitle,
    required this.showCrown,
    required this.locked,
    required this.onTap,
    this.last = false,
  });

  final ExploreLiveSection section;
  final String title;
  final String subtitle;
  final bool showCrown;
  final bool locked;
  final VoidCallback onTap;
  final bool last;

  @override
  Widget build(BuildContext context) {
    final live = context.select<ExploreBloc, ExploreLiveState>(
      (b) => b.state.liveOf(section),
    );
    return switch (live.status) {
      ExploreStatus.initial || ExploreStatus.loading => _GridSectionShimmer(
        title: title,
        subtitle: subtitle,
        showCrown: showCrown,
        last: last,
      ),
      ExploreStatus.failure => const SizedBox.shrink(),
      ExploreStatus.ready => _GridSection(
        title: title,
        subtitle: subtitle,
        showCrown: showCrown,
        profiles: live.section.profiles,
        locked: locked || live.section.locked,
        onTap: onTap,
        last: last,
        loadingMore: live.loadingMore,
        onLoadMore: live.section.hasMore
            ? () => context.read<ExploreBloc>().add(
                ExploreLiveMoreRequested(section),
              )
            : null,
      ),
    };
  }
}

/// First-load skeleton of a [_GridSection]: the real header over 2 rows of
/// shimmering card blocks, sized like the cards so nothing jumps when the
/// data lands.
class _GridSectionShimmer extends StatelessWidget {
  const _GridSectionShimmer({
    required this.title,
    required this.subtitle,
    this.showCrown = false,
    this.last = false,
  });

  final String title;
  final String subtitle;
  final bool showCrown;
  final bool last;

  /// Enough to run off the right edge, like the real strip.
  static const _columns = 5;

  @override
  Widget build(BuildContext context) {
    final header = ExploreSectionHeader(
      title: title,
      subtitle: subtitle,
      showCrown: showCrown,
    );
    final cardHeight = ExploreGridCard.width.w * kExploreCardAspect;
    return Padding(
      padding: EdgeInsets.only(bottom: last ? 0 : _sectionGap),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          header,
          SizedBox(height: header.bottomGap),
          SizedBox(
            height: cardHeight * 2 + ExploreGridCard.gap.w,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: kExploreGutter),
              itemCount: _columns,
              separatorBuilder: (_, _) =>
                  SizedBox(width: ExploreGridCard.gap.w),
              itemBuilder: (_, _) => const _ShimmerColumn(),
            ),
          ),
        ],
      ),
    );
  }
}

/// One column (2 card-sized blocks) of shimmer — the first-load skeleton
/// and the "loading next page" tail of a paged [_GridSection].
class _ShimmerColumn extends StatelessWidget {
  const _ShimmerColumn();

  @override
  Widget build(BuildContext context) {
    final width = ExploreGridCard.width.w;
    final height = width * kExploreCardAspect;
    return AppShimmer(
      child: Column(
        children: [
          AppShimmerBox(width: width, height: height, radius: 4.r),
          SizedBox(height: ExploreGridCard.gap.w),
          AppShimmerBox(width: width, height: height, radius: 4.r),
        ],
      ),
    );
  }
}

// Superseded: row-major fill (first half = top row) can't grow by
// appending pages without reshuffling every card. Column-major below.
// /// Two rows of [ExploreGridCard]s that scroll sideways together — the
// /// mockup's fourth column runs off the screen edge. Filled row-major, so
// /// the first half of [profiles] is the top row.
// class _GridSection extends StatelessWidget {
//   const _GridSection({
//     required this.title,
//     required this.subtitle,
//     required this.showCrown,
//     required this.profiles,
//     required this.locked,
//     required this.onTap,
//     this.last = false,
//   });
//
//   final String title;
//   final String subtitle;
//   final bool showCrown;
//   final List<ExploreProfile> profiles;
//   final bool locked;
//   final VoidCallback onTap;
//   final bool last;
//
//   @override
//   Widget build(BuildContext context) {
//     if (profiles.isEmpty) return const SizedBox.shrink();
//     final header = ExploreSectionHeader(
//       title: title,
//       subtitle: subtitle,
//       showCrown: showCrown,
//     );
//     final columns = (profiles.length + 1) ~/ 2;
//     final cardHeight = ExploreGridCard.width.w * kExploreCardAspect;
//     Widget card(int i) =>
//         ExploreGridCard(profile: profiles[i], locked: locked, onTap: onTap);
//     return Padding(
//       padding: EdgeInsets.only(bottom: last ? 0 : _sectionGap),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           header,
//           SizedBox(height: header.bottomGap),
//           SizedBox(
//             height: cardHeight * 2 + ExploreGridCard.gap.w,
//             child: ListView.separated(
//               scrollDirection: Axis.horizontal,
//               padding: EdgeInsets.symmetric(horizontal: kExploreGutter),
//               itemCount: columns,
//               separatorBuilder: (_, _) =>
//                   SizedBox(width: ExploreGridCard.gap.w),
//               itemBuilder: (context, c) => Column(
//                 children: [
//                   card(c),
//                   if (c + columns < profiles.length) ...[
//                     SizedBox(height: ExploreGridCard.gap.w),
//                     card(c + columns),
//                   ],
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

class _MyHistoryTab extends StatelessWidget {
  const _MyHistoryTab({
    required this.filter,
    required this.onFilterChanged,
    required this.onCardTap,
  });

  final ExploreHistoryFilter filter;
  final ValueChanged<ExploreHistoryFilter> onFilterChanged;
  final VoidCallback onCardTap;

  List<ExploreProfile> _profilesFor(ExploreHistoryFeed history) =>
      switch (filter) {
        ExploreHistoryFilter.liked => history.liked,
        ExploreHistoryFilter.favourited => history.favourited,
        ExploreHistoryFilter.passed => history.passed,
        ExploreHistoryFilter.complimented => history.complimented,
      };

  // Mockup only showed copy for Favourited/Complimented — Liked/Passed are
  // drafted to match that tone.
  (String, String) get _emptyCopy => switch (filter) {
    ExploreHistoryFilter.liked => (
      'Liked',
      'Profiles you like will appear right here. Keep exploring to find '
          'your match.',
    ),
    ExploreHistoryFilter.favourited => (
      'Favourited',
      "People you favourite will appear right here. They won't ever know "
          "you've added them to your favourites.",
    ),
    ExploreHistoryFilter.passed => (
      'Passed',
      'Profiles you pass on will appear right here.',
    ),
    ExploreHistoryFilter.complimented => (
      'Complimented',
      "Compliments you've sent to other members are shown here. Accepted "
          'compliments will be moved to your matches.',
    ),
  };

  @override
  Widget build(BuildContext context) {
    final state = context.watch<ExploreBloc>().state;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // SizedBox(height: 16.h),
        SizedBox(height: 10.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: kExploreGutter),
          child: ExploreHistoryFilterBar(
            selected: filter,
            onChanged: onFilterChanged,
          ),
        ),
        Expanded(
          child: _liveSectionFor(filter) != null
              ? _liveHistory(context, state, _liveSectionFor(filter)!)
              : switch (state.historyStatus) {
                  ExploreStatus.initial ||
                  ExploreStatus.loading => const AppLoadingView(),
                  ExploreStatus.failure => AppErrorView(
                    title: state.historyFailure!.title,
                    message: state.historyFailure!.message,
                    retryLabel: 'Try again',
                    onRetry: () => context.read<ExploreBloc>().add(
                      const ExploreHistoryRequested(),
                    ),
                  ),
                  ExploreStatus.ready => _HistoryList(
                    profiles: _profilesFor(state.history),
                    emptyCopy: _emptyCopy,
                    onCardTap: onCardTap,
                  ),
                },
        ),
      ],
    );
  }

  /// "Liked" and "Passed" are on the real API (cached, paged); the other 2
  /// filters are still the dummy [ExploreHistoryFeed].
  static ExploreLiveSection? _liveSectionFor(ExploreHistoryFilter f) =>
      switch (f) {
        ExploreHistoryFilter.liked => ExploreLiveSection.liked,
        ExploreHistoryFilter.passed => ExploreLiveSection.passed,
        _ => null,
      };

  Widget _liveHistory(
    BuildContext context,
    ExploreState state,
    ExploreLiveSection section,
  ) {
    final live = state.liveOf(section);
    return switch (live.status) {
      ExploreStatus.initial || ExploreStatus.loading => const _HistoryShimmer(),
      ExploreStatus.failure => AppErrorView(
        title: "Couldn't load profiles",
        message: 'Check your connection and try again.',
        retryLabel: 'Try again',
        onRetry: () => context.read<ExploreBloc>().add(
          ExploreLiveRefreshed(section),
        ),
      ),
      ExploreStatus.ready => _HistoryList(
        profiles: live.section.profiles,
        emptyCopy: _emptyCopy,
        onCardTap: onCardTap,
        loadingMore: live.loadingMore,
        onLoadMore: live.section.hasMore
            ? () => context.read<ExploreBloc>().add(
                ExploreLiveMoreRequested(section),
              )
            : null,
      ),
    };
  }
}

class _HistoryList extends StatelessWidget {
  const _HistoryList({
    required this.profiles,
    required this.emptyCopy,
    required this.onCardTap,
    this.loadingMore = false,
    this.onLoadMore,
  });

  final List<ExploreProfile> profiles;
  final (String, String) emptyCopy;
  final VoidCallback onCardTap;

  /// Paged ("Passed"): next page once the grid is within ~2 rows of its
  /// end; a spinner row trails it while [loadingMore].
  final bool loadingMore;
  final VoidCallback? onLoadMore;

  @override
  Widget build(BuildContext context) {
    if (profiles.isEmpty) {
      final (title, message) = emptyCopy;
      return AppMessageView(
        title: title,
        message: message,
        actionLabel: 'Continue',
        onAction: () => StatefulNavigationShell.of(context).goBranch(0),
      );
    }
    final screenWidth = MediaQuery.sizeOf(context).width;
    // const crossAxisSpacing = 12.0;
    // Figma 1157:6870: 168×260 cards, 14pt apart.
    const crossAxisSpacing = 14.0;
    final cellWidth =
        (screenWidth - kExploreGutter * 2 - crossAxisSpacing.w) / 2;
    // final cellHeight =
    //     cellWidth * kExploreCardAspect + ExploreHistoryCard.footerHeight.h;
    final cellHeight = cellWidth * 260 / 168;
    Widget grid(ScrollController? controller) => GridView.builder(
      controller: controller,
      // padding: EdgeInsets.fromLTRB(
      //   kExploreGutter,
      //   16.h,
      //   kExploreGutter,
      //   100.h,
      // ),
      padding: EdgeInsets.fromLTRB(kExploreGutter, 26.h, kExploreGutter, 100.h),
      itemCount: profiles.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        // mainAxisSpacing: 12.h,
        mainAxisSpacing: 14.h,
        crossAxisSpacing: crossAxisSpacing.w,
        mainAxisExtent: cellHeight,
      ),
      itemBuilder: (context, i) =>
          ExploreHistoryCard(profile: profiles[i], onTap: onCardTap),
    );
    if (onLoadMore == null && !loadingMore) return grid(null);
    return Stack(
      children: [
        NearEndLoader(
          threshold: cellHeight * 2,
          itemCount: profiles.length,
          onLoadMore: onLoadMore,
          loading: loadingMore,
          builder: grid,
        ),
        if (loadingMore)
          Positioned(
            left: 0,
            right: 0,
            bottom: 40.h,
            child: const Center(
              child: SizedBox.square(
                dimension: 22,
                child: CircularProgressIndicator(strokeWidth: 2.5),
              ),
            ),
          ),
      ],
    );
  }
}

/// First-load skeleton of the "My history" grid: 2 columns of
/// history-card-sized shimmer blocks.
class _HistoryShimmer extends StatelessWidget {
  const _HistoryShimmer();

  @override
  Widget build(BuildContext context) {
    const crossAxisSpacing = 14.0;
    final cellWidth =
        (MediaQuery.sizeOf(context).width -
            kExploreGutter * 2 -
            crossAxisSpacing.w) /
        2;
    final cellHeight = cellWidth * 260 / 168;
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.fromLTRB(kExploreGutter, 26.h, kExploreGutter, 0),
      itemCount: 4,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 14.h,
        crossAxisSpacing: crossAxisSpacing.w,
        mainAxisExtent: cellHeight,
      ),
      itemBuilder: (_, _) => AppShimmer(
        child: AppShimmerBox(width: cellWidth, height: cellHeight, radius: 8),
      ),
    );
  }
}
