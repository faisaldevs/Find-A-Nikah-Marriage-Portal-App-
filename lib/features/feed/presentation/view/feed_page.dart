import 'dart:async';

import 'package:find_a_nikah/app/di.dart';
import 'package:find_a_nikah/core/ui/ui.dart';
import 'package:find_a_nikah/features/feed/domain/domain.dart';
import 'package:find_a_nikah/features/feed/presentation/bloc/feed_bloc.dart';
import 'package:find_a_nikah/features/feed/presentation/bloc/post_page_result.dart';
import 'package:find_a_nikah/features/feed/presentation/widgets/feed_compose_button.dart';
import 'package:find_a_nikah/features/feed/presentation/widgets/feed_filter_chips.dart';
import 'package:find_a_nikah/features/feed/presentation/widgets/feed_notice.dart';
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

  Future<void> _compose() async {
    final bloc = context.read<FeedBloc>();
    final post = await context.push<FeedPost>(RoutePaths.feedCompose);
    if (post != null) bloc.add(FeedPostAdded(post));
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<FeedBloc>().state;
    // White header (status bar, title row, chips; Figma: 173pt tall), grey
    // page below it. Back closes search before leaving the tab.
    return PopScope(
      canPop: !_searching,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _closeSearch();
      },
      child: BlocListener<FeedBloc, FeedState>(
        listenWhen: (a, b) => a.notice != b.notice,
        listener: (context, state) => showFeedNotice(context, state.notice),
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
                  onNotifications: () => CustomToast.showInfo(
                    context,
                    'Notifications — coming soon',
                  ),
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
                        const Positioned.fill(child: _Posts()),
                        if (!_searching)
                          Positioned(
                            right: 22.w,
                            bottom: 48.5.w,
                            child: FeedComposeButton(onTap: _compose),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Posts extends StatefulWidget {
  const _Posts();

  @override
  State<_Posts> createState() => _PostsState();
}

class _PostsState extends State<_Posts> {
  final _scroll = ScrollController();

  @override
  void initState() {
    super.initState();
    _scroll.addListener(() {
      // Ask for the next page a screen before the end.
      if (_scroll.position.extentAfter < 600) {
        context.read<FeedBloc>().add(const FeedLoadMore());
      }
    });
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  Future<void> _refresh() {
    final done = Completer<void>();
    context.read<FeedBloc>().add(FeedRefreshed(done));
    return done.future;
  }

  Future<void> _open(FeedPost post) async {
    final bloc = context.read<FeedBloc>();
    final result = await context.push<PostPageResult>(
      RoutePaths.feedPostPath(post.id),
      extra: post,
    );
    if (result == null) return;
    if (result.removedPostId case final id?) bloc.add(FeedPostRemoved(id));
    if (result.hiddenUserId case final id?) bloc.add(FeedAuthorRemoved(id));
    if (result.post case final p?) bloc.add(FeedPostChanged(p));
  }

  Future<void> _edit(FeedPost post) async {
    final bloc = context.read<FeedBloc>();
    final edited = await context.push<FeedPost>(
      RoutePaths.feedCompose,
      extra: post,
    );
    if (edited != null) bloc.add(FeedPostChanged(edited));
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<FeedBloc>().state;
    final list = state.shown;
    if (list.isIdle || list.isLoading) return const AppLoadingView();
    if (list.hasFailed && list.items.isEmpty) {
      return AppErrorView(
        title: list.failure!.title,
        message: list.failure!.message,
        retryLabel: 'Try again',
        onRetry: () => context.read<FeedBloc>().add(
          state.searching
              ? FeedQueryChanged(state.query)
              : const FeedSubscribed(),
        ),
      );
    }
    if (list.items.isEmpty) {
      // Still scrollable, so pull-to-refresh works on an empty feed.
      return RefreshIndicator(
        onRefresh: _refresh,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            SizedBox(height: 80.w),
            if (state.searching)
              AppMessageView(
                title: 'No posts found',
                message: 'Nothing matches “${state.query.trim()}”.',
              )
            else
              const AppMessageView(
                title: 'No posts yet',
                message: 'Be the first to post in this topic.',
              ),
          ],
        ),
      );
    }
    final bloc = context.read<FeedBloc>();
    return RefreshIndicator(
      onRefresh: _refresh,
      child: ListView.separated(
        controller: _scroll,
        physics: const AlwaysScrollableScrollPhysics(),
        // Figma: first card 16pt under the header, 16pt between cards; the
        // bottom clears the compose button.
        padding: EdgeInsets.fromLTRB(kFeedGutter, 16.w, kFeedGutter, 112.w),
        itemCount: list.items.length + (list.loadingMore ? 1 : 0),
        separatorBuilder: (_, _) => SizedBox(height: 16.w),
        itemBuilder: (context, i) {
          if (i >= list.items.length) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 16.w),
              child: const Center(child: CircularProgressIndicator()),
            );
          }
          final post = list.items[i];
          bloc.add(FeedPostSeen(post.id));
          return FeedPostCard(
            post: post,
            maxBodyLines: 4,
            onTap: () => _open(post),
            onAuthorTap: () => context
                .push<void>(
                  RoutePaths.feedProfilePath(post.author.userId),
                  extra: post.author,
                )
                .ignore(),
            onMore: () => showFeedPostMenu(
              context,
              post,
              FeedPostHandlers(
                onEdit: () => _edit(post),
                onDelete: () => bloc.add(FeedPostDeleteRequested(post.id)),
                onMute: () =>
                    bloc.add(FeedAuthorMuteRequested(post.author.userId)),
                onBlock: () =>
                    bloc.add(FeedAuthorBlockRequested(post.author.userId)),
                onReport: (reason) => bloc.add(
                  FeedReportRequested(
                    FeedReport(
                      target: FeedReportTarget.post,
                      reason: reason,
                      postId: post.id,
                    ),
                  ),
                ),
              ),
            ),
            onLike: () => bloc.add(FeedPostLikeToggled(post.id)),
            onComment: () => _open(post),
            onShare: () => shareFeedLink(feedPostLink(post.id)),
          );
        },
      ),
    );
  }
}
