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
    return switch (state.status) {
      ExploreStatus.initial || ExploreStatus.loading => const AppLoadingView(),
      ExploreStatus.failure => AppErrorView(
        title: state.failure!.title,
        message: state.failure!.message,
        retryLabel: 'Try again',
        onRetry: () =>
            context.read<ExploreBloc>().add(const ExploreSubscribed()),
      ),
      ExploreStatus.ready => NotificationListener<ScrollNotification>(
        onNotification: onScroll,
        child: SingleChildScrollView(
          controller: scrollController,
          // Mockup: first header row starts 41.75pt under the tab bar;
          // each section ends ~42.5pt above the next header (see _sectionGap).
          padding: EdgeInsets.only(top: 41.75.w, bottom: 184.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _HorizontalSection(
                title: 'Likes in your filters',
                count: state.feed.likesInFilters.count,
                cardHeight: ExploreBigCard.height,
                gap: ExploreBigCard.gap,
                itemCount: state.feed.likesInFilters.profiles.length,
                itemBuilder: (context, i) => ExploreBigCard(
                  profile: state.feed.likesInFilters.profiles[i],
                  locked: true,
                  onTap: onLockedTap,
                ),
              ),
              _HorizontalSection(
                title: 'Take a second look',
                subtitle:
                    'You previously passed on their profile but they liked '
                    'you afterwards.',
                count: state.feed.secondLook.count,
                cardHeight: ExploreSmallCard.height,
                gap: ExploreSmallCard.gap,
                itemCount: state.feed.secondLook.profiles.length,
                itemBuilder: (context, i) => ExploreSmallCard(
                  profile: state.feed.secondLook.profiles[i],
                  onTap: onCardTap,
                ),
              ),
              _GridSection(
                title: 'Currently available',
                subtitle:
                    'Members who have at least one slot available to chat.',
                showCrown: true,
                profiles: state.feed.currentlyAvailable.profiles,
                locked: true,
                onTap: onLockedTap,
              ),
              _HorizontalSection(
                title: 'Visited you',
                subtitle:
                    "See who's interested, they might be your perfect match.",
                count: state.feed.visitedYou.count,
                cardHeight: ExploreSmallCard.height,
                gap: ExploreSmallCard.gap,
                itemCount: state.feed.visitedYou.profiles.length,
                itemBuilder: (context, i) => ExploreSmallCard(
                  profile: state.feed.visitedYou.profiles[i],
                  onTap: onCardTap,
                ),
              ),
              _GridSection(
                title: 'Just joined',
                subtitle: 'Meet new potential matches who recently joined.',
                showCrown: true,
                profiles: state.feed.justJoined.profiles,
                locked: true,
                onTap: onLockedTap,
              ),
              _GridSection(
                title: 'Active near you',
                subtitle: 'These members are active now.',
                showCrown: false,
                profiles: state.feed.activeNearYou.profiles,
                locked: false,
                onTap: onCardTap,
                last: true,
              ),
            ],
          ),
        ),
      ),
    };
  }
}

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
  });

  final String title;
  final String? subtitle;
  final int count;
  final double cardHeight;
  final double gap;
  final int itemCount;
  final Widget Function(BuildContext, int) itemBuilder;

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
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: kExploreGutter),
              itemCount: itemCount,
              separatorBuilder: (_, _) => SizedBox(width: gap.w),
              itemBuilder: itemBuilder,
            ),
          ),
        ],
      ),
    );
  }
}

/// Two rows of [ExploreGridCard]s that scroll sideways together — the
/// mockup's fourth column runs off the screen edge. Filled row-major, so
/// the first half of [profiles] is the top row.
class _GridSection extends StatelessWidget {
  const _GridSection({
    required this.title,
    required this.subtitle,
    required this.showCrown,
    required this.profiles,
    required this.locked,
    required this.onTap,
    this.last = false,
  });

  final String title;
  final String subtitle;
  final bool showCrown;
  final List<ExploreProfile> profiles;
  final bool locked;
  final VoidCallback onTap;
  final bool last;

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
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: kExploreGutter),
              itemCount: columns,
              separatorBuilder: (_, _) =>
                  SizedBox(width: ExploreGridCard.gap.w),
              itemBuilder: (context, c) => Column(
                children: [
                  card(c),
                  if (c + columns < profiles.length) ...[
                    SizedBox(height: ExploreGridCard.gap.w),
                    card(c + columns),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

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
          child: switch (state.historyStatus) {
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
}

class _HistoryList extends StatelessWidget {
  const _HistoryList({
    required this.profiles,
    required this.emptyCopy,
    required this.onCardTap,
  });

  final List<ExploreProfile> profiles;
  final (String, String) emptyCopy;
  final VoidCallback onCardTap;

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
    return GridView.builder(
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
  }
}
