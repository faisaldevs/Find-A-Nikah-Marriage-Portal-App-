import 'package:find_a_nikah/app/di.dart';
import 'package:find_a_nikah/core/ui/ui.dart';
import 'package:find_a_nikah/features/explore/domain/domain.dart';
import 'package:find_a_nikah/features/explore/presentation/bloc/explore_bloc.dart';
import 'package:find_a_nikah/features/explore/presentation/widgets/explore_big_card.dart';
import 'package:find_a_nikah/features/explore/presentation/widgets/explore_cta_button.dart';
import 'package:find_a_nikah/features/explore/presentation/widgets/explore_grid_card.dart';
import 'package:find_a_nikah/features/explore/presentation/widgets/explore_section_header.dart';
import 'package:find_a_nikah/features/explore/presentation/widgets/explore_small_card.dart';
import 'package:find_a_nikah/features/explore/presentation/widgets/explore_style.dart';
import 'package:find_a_nikah/features/explore/presentation/widgets/explore_tabs.dart';
import 'package:find_a_nikah/features/explore/presentation/widgets/explore_top_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

/// Second bottom-nav tab: a "For you" feed of six sections (some gated
/// behind the premium lock) and a "My history" tab with no design yet.
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
  bool _ctaExpanded = true;

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
    return Scaffold(
      backgroundColor: kExplorePageBackground,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            ExploreTopBar(onFilters: () => _comingSoon('Filters')),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: kExploreGutter),
              child: ExploreTabBar(
                selected: _tab,
                onChanged: (tab) => setState(() => _tab = tab),
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  switch (_tab) {
                    ExploreTab.forYou => _ForYouTab(
                      scrollController: _scrollController,
                      onScroll: _onScroll,
                      onCardTap: () => _comingSoon('Profile'),
                      onLockedTap: _premiumGate,
                    ),
                    ExploreTab.myHistory => const _MyHistoryTab(),
                  },
                  Positioned(
                    right: kExploreGutter,
                    bottom: 16.h,
                    child: ExploreCtaButton(
                      expanded: _ctaExpanded,
                      onTap: _premiumGate,
                    ),
                  ),
                ],
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
          padding: EdgeInsets.only(bottom: 100.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16.h),
              _HorizontalSection(
                title: 'Likes in your filters',
                subtitle: '',
                count: state.feed.likesInFilters.count,
                cardWidth: ExploreBigCard.width,
                itemCount: state.feed.likesInFilters.profiles.length,
                itemBuilder: (context, i) => ExploreBigCard(
                  profile: state.feed.likesInFilters.profiles[i],
                  locked: true,
                  onTap: onLockedTap,
                ),
              ),
              SizedBox(height: 32.h),
              _HorizontalSection(
                title: 'Take a second look',
                subtitle:
                    'You previously passed on their profile but they liked '
                    'you afterwards.',
                count: state.feed.secondLook.count,
                cardWidth: ExploreSmallCard.width,
                itemCount: state.feed.secondLook.profiles.length,
                itemBuilder: (context, i) => ExploreSmallCard(
                  profile: state.feed.secondLook.profiles[i],
                  onTap: onCardTap,
                ),
              ),
              SizedBox(height: 32.h),
              _GridSection(
                title: 'Currently available',
                subtitle:
                    'Members who have at least one slot available to chat.',
                showCrown: true,
                profiles: state.feed.currentlyAvailable.profiles,
                locked: true,
                onTap: onLockedTap,
              ),
              SizedBox(height: 32.h),
              _HorizontalSection(
                title: 'Visited you',
                subtitle:
                    "See who's interested, they might be your perfect match.",
                count: state.feed.visitedYou.count,
                cardWidth: ExploreSmallCard.width,
                itemCount: state.feed.visitedYou.profiles.length,
                itemBuilder: (context, i) => ExploreSmallCard(
                  profile: state.feed.visitedYou.profiles[i],
                  onTap: onCardTap,
                ),
              ),
              SizedBox(height: 32.h),
              _GridSection(
                title: 'Just joined',
                subtitle: 'Meet new potential matches who recently joined.',
                showCrown: true,
                profiles: state.feed.justJoined.profiles,
                locked: true,
                onTap: onLockedTap,
              ),
              SizedBox(height: 32.h),
              _GridSection(
                title: 'Active near you',
                subtitle: 'These members are active now.',
                showCrown: false,
                profiles: state.feed.activeNearYou.profiles,
                locked: false,
                onTap: onCardTap,
              ),
            ],
          ),
        ),
      ),
    };
  }
}

class _HorizontalSection extends StatelessWidget {
  const _HorizontalSection({
    required this.title,
    required this.subtitle,
    required this.count,
    required this.cardWidth,
    required this.itemCount,
    required this.itemBuilder,
  });

  final String title;
  final String subtitle;
  final int count;
  final double cardWidth;
  final int itemCount;
  final Widget Function(BuildContext, int) itemBuilder;

  @override
  Widget build(BuildContext context) {
    if (itemCount == 0) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ExploreSectionHeader(title: title, subtitle: subtitle, count: count),
        SizedBox(height: 16.h),
        SizedBox(
          height: cardWidth.w * kExploreCardAspect,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: kExploreGutter),
            itemCount: itemCount,
            separatorBuilder: (_, _) => SizedBox(width: 12.w),
            itemBuilder: itemBuilder,
          ),
        ),
      ],
    );
  }
}

class _GridSection extends StatelessWidget {
  const _GridSection({
    required this.title,
    required this.subtitle,
    required this.showCrown,
    required this.profiles,
    required this.locked,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final bool showCrown;
  final List<ExploreProfile> profiles;
  final bool locked;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    if (profiles.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ExploreSectionHeader(
          title: title,
          subtitle: subtitle,
          showCrown: showCrown,
        ),
        SizedBox(height: 16.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: kExploreGutter),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: profiles.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 8.h,
              crossAxisSpacing: 8.w,
              childAspectRatio: 1 / kExploreCardAspect,
            ),
            itemBuilder: (context, i) => ExploreGridCard(
              profile: profiles[i],
              locked: locked,
              onTap: onTap,
            ),
          ),
        ),
      ],
    );
  }
}

class _MyHistoryTab extends StatelessWidget {
  const _MyHistoryTab();

  @override
  Widget build(BuildContext context) => const AppEmptyView(
    title: 'My history',
    message: 'Coming soon.',
  );
}
