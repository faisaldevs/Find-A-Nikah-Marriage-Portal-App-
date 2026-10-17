import 'package:find_a_nikah/app/di.dart';
import 'package:find_a_nikah/core/ui/ui.dart';
import 'package:find_a_nikah/features/feed/domain/domain.dart';
import 'package:find_a_nikah/features/feed/presentation/bloc/feed_bloc.dart';
import 'package:find_a_nikah/features/feed/presentation/widgets/feed_compose_button.dart';
import 'package:find_a_nikah/features/feed/presentation/widgets/feed_filter_chips.dart';
import 'package:find_a_nikah/features/feed/presentation/widgets/feed_post_actions_sheet.dart';
import 'package:find_a_nikah/features/feed/presentation/widgets/feed_post_card.dart';
import 'package:find_a_nikah/features/feed/presentation/widgets/feed_style.dart';
import 'package:find_a_nikah/features/feed/presentation/widgets/feed_top_bar.dart';
import 'package:find_a_nikah/router/route_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:go_router/go_router.dart';

/// Third bottom-nav tab: community posts, filtered by the chip row under
/// the title. Built from the Figma "feed" frame (node 1157:5892).
class FeedPage extends StatelessWidget {
  const FeedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<FeedBloc>()..add(const FeedSubscribed()),
      child: const _FeedView(),
    );
  }
}

class _FeedView extends StatefulWidget {
  const _FeedView();

  @override
  State<_FeedView> createState() => _FeedViewState();
}

class _FeedViewState extends State<_FeedView> {
  final _search = TextEditingController();
  bool _searching = false;

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  void _closeSearch() {
    _search.clear();
    context.read<FeedBloc>().add(const FeedQueryChanged(''));
    setState(() => _searching = false);
  }

  @override
  Widget build(BuildContext context) {
    void comingSoon(String what) =>
        CustomToast.showInfo(context, '$what — coming soon');
    final state = context.watch<FeedBloc>().state;
    // White header (status bar, title row, chips; Figma: 173pt tall), grey
    // page below it. Back closes search before leaving the tab.
    return PopScope(
      canPop: !_searching,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _closeSearch();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              FeedTopBar(
                searching: _searching,
                searchController: _search,
                onSearch: () => setState(() => _searching = true),
                onCloseSearch: _closeSearch,
                onQueryChanged: (q) =>
                    context.read<FeedBloc>().add(FeedQueryChanged(q)),
                onNotifications: () => comingSoon('Notifications'),
              ),
              SizedBox(height: 14.w),
              FeedFilterChips(
                topics: state.topics,
                selected: state.filter,
                onSelected: (f) =>
                    context.read<FeedBloc>().add(FeedFilterSelected(f)),
              ),
              SizedBox(height: 13.4.w),
              Expanded(
                child: ColoredBox(
                  color: kFeedPageBackground,
                  child: Stack(
                    children: [
                      Positioned.fill(child: _Posts(onComingSoon: comingSoon)),
                      if (!_searching)
                        Positioned(
                          right: 22.w,
                          bottom: 48.5.w,
                          child: FeedComposeButton(
                            onTap: () async {
                              final bloc = context.read<FeedBloc>();
                              final post = await context.push<FeedPost>(
                                RoutePaths.feedCompose,
                              );
                              if (post != null) bloc.add(FeedPostAdded(post));
                            },
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Posts extends StatelessWidget {
  const _Posts({required this.onComingSoon});

  final void Function(String what) onComingSoon;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<FeedBloc>().state;
    return switch (state.status) {
      FeedStatus.initial || FeedStatus.loading => const AppLoadingView(),
      FeedStatus.failure => AppErrorView(
        title: state.failure!.title,
        message: state.failure!.message,
        retryLabel: 'Try again',
        onRetry: () => context.read<FeedBloc>().add(const FeedSubscribed()),
      ),
      FeedStatus.ready when state.visiblePosts.isEmpty =>
        state.query.trim().isEmpty
            ? const AppMessageView(
                title: 'No posts yet',
                message: 'Posts in this topic will show up here.',
              )
            : AppMessageView(
                title: 'No posts found',
                message: 'Nothing matches “${state.query.trim()}”.',
              ),
      FeedStatus.ready => ListView.separated(
        // Figma: first card 16pt under the header, 16pt between cards; the
        // bottom clears the compose button.
        padding: EdgeInsets.fromLTRB(kFeedGutter, 16.w, kFeedGutter, 112.w),
        itemCount: state.visiblePosts.length,
        separatorBuilder: (_, _) => SizedBox(height: 16.w),
        itemBuilder: (context, i) {
          final post = state.visiblePosts[i];
          void open() =>
              context.push<void>(RoutePaths.feedPost, extra: post).ignore();
          return FeedPostCard(
            post: post,
            maxBodyLines: 4,
            onTap: open,
            onAuthorTap: () => context
                .push<void>(RoutePaths.feedProfile, extra: post.author)
                .ignore(),
            onMore: () async {
              final action = await showFeedPostActions(
                context,
                authorName: post.author.name,
                canSave: true,
              );
              if (action != null) onComingSoon(action.name);
            },
            onLike: () => onComingSoon('Likes'),
            onComment: open,
            onShare: () => onComingSoon('Share'),
          );
        },
      ),
    };
  }
}
