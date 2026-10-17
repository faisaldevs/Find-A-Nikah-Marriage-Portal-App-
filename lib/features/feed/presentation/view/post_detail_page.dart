import 'package:find_a_nikah/app/di.dart';
import 'package:find_a_nikah/core/ui/ui.dart';
import 'package:find_a_nikah/features/feed/domain/domain.dart';
import 'package:find_a_nikah/features/feed/presentation/bloc/post_detail_bloc.dart';
import 'package:find_a_nikah/features/feed/presentation/widgets/feed_circle_button.dart';
import 'package:find_a_nikah/features/feed/presentation/widgets/feed_comment_thread.dart';
import 'package:find_a_nikah/features/feed/presentation/widgets/feed_icon.dart';
import 'package:find_a_nikah/features/feed/presentation/widgets/feed_portrait.dart';
import 'package:find_a_nikah/features/feed/presentation/widgets/feed_post_actions_sheet.dart';
import 'package:find_a_nikah/features/feed/presentation/widgets/feed_post_card.dart';
import 'package:find_a_nikah/features/feed/presentation/widgets/feed_sort_sheet.dart';
import 'package:find_a_nikah/features/feed/presentation/widgets/feed_style.dart';
import 'package:find_a_nikah/gen/assets.gen.dart';
import 'package:find_a_nikah/router/route_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:go_router/go_router.dart';

/// One post and its comments (Figma "feed post & comments"). Opened from a
/// feed card; the post itself travels as the route's `extra`.
class PostDetailPage extends StatelessWidget {
  const PostDetailPage({required this.post, super.key});

  final FeedPost post;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          getIt<PostDetailBloc>(param1: post)..add(const PostDetailStarted()),
      child: const _PostDetailView(),
    );
  }
}

class _PostDetailView extends StatelessWidget {
  const _PostDetailView();

  @override
  Widget build(BuildContext context) {
    void comingSoon(String what) =>
        CustomToast.showInfo(context, '$what — coming soon');
    void openProfile(FeedAuthor author) =>
        context.push<void>(RoutePaths.feedProfile, extra: author).ignore();
    Future<void> openActions(FeedAuthor author) async {
      final action = await showFeedPostActions(
        context,
        authorName: author.name,
        canSave: false,
      );
      if (action != null && context.mounted) comingSoon(action.name);
    }

    final state = context.watch<PostDetailBloc>().state;
    final post = state.post;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 8.4.h, 20.w, 0),
              child: Row(
                children: [
                  FeedCircleButton(
                    asset: Assets.icons.feedBack,
                    iconSize: 24,
                    iconColor: kFeedGrey900,
                    tooltip: 'Back',
                    onTap: () => context.pop(),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'Post',
                        style: feedText(20, 28, weight: FontWeight.w700),
                      ),
                    ),
                  ),
                  FeedCircleButton(
                    asset: Assets.icons.feedShare,
                    iconSize: 16,
                    iconColor: kFeedGrey950,
                    tooltip: 'Share',
                    onTap: () => comingSoon('Share'),
                  ),
                ],
              ),
            ),
            SizedBox(height: 15.w),
            Expanded(
              child: ListView(
                padding: EdgeInsets.only(bottom: 24.w),
                children: [
                  ColoredBox(
                    color: kFeedPageBackground,
                    child: Padding(
                      padding: EdgeInsets.all(16.w).copyWith(
                        left: 20.w,
                        right: 20.w,
                      ),
                      child: FeedPostCard(
                        post: post,
                        topicColor: kFeedReadMoreGreen,
                        commentsHighlighted: true,
                        onAuthorTap: () => openProfile(post.author),
                        onFollow: () =>
                            comingSoon('Follow ${post.author.name}'),
                        onMore: () => openActions(post.author),
                        onLike: () => comingSoon('Likes'),
                        onComment: () {},
                        onShare: () => comingSoon('Share'),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.6.w),
                  _SortRow(sort: state.sort),
                  SizedBox(height: 22.6.w),
                  ..._comments(
                    context,
                    state,
                    openProfile: openProfile,
                    openActions: openActions,
                    comingSoon: comingSoon,
                  ),
                ],
              ),
            ),
            _CommentComposer(me: state.me, onTap: () => comingSoon('Comments')),
          ],
        ),
      ),
    );
  }

  List<Widget> _comments(
    BuildContext context,
    PostDetailState state, {
    required ValueChanged<FeedAuthor> openProfile,
    required Future<void> Function(FeedAuthor) openActions,
    required void Function(String) comingSoon,
  }) {
    switch (state.status) {
      case PostDetailStatus.loading:
        return [SizedBox(height: 160.w, child: const AppLoadingView())];
      case PostDetailStatus.failure:
        return [
          AppErrorView(
            title: state.failure!.title,
            message: state.failure!.message,
            retryLabel: 'Try again',
            onRetry: () =>
                context.read<PostDetailBloc>().add(const PostDetailStarted()),
          ),
        ];
      case PostDetailStatus.ready:
        final divider = Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.w),
          child: Container(height: 1.w, color: kFeedGrey100),
        );
        final shown = state.comments.fold<int>(
          0,
          (n, c) => n + 1 + c.replies.length,
        );
        final more = state.post.commentCount - shown;
        return [
          for (final (i, c) in state.comments.indexed) ...[
            if (i > 0) divider,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: FeedCommentThread(
                comment: c,
                onAuthorTap: openProfile,
                onMore: (c) => openActions(c.author),
                onLike: (_) => comingSoon('Likes'),
                onReply: (_) => comingSoon('Replies'),
                onShare: (_) => comingSoon('Share'),
              ),
            ),
          ],
          if (more > 0) ...[
            divider,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: GestureDetector(
                onTap: () => comingSoon('More comments'),
                child: Row(
                  children: [
                    Text(
                      'View $more more comments',
                      style: feedText(
                        13,
                        20,
                        weight: FontWeight.w700,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    SizedBox(width: 3.w),
                    FeedIcon(
                      Assets.icons.feedChevronDown,
                      size: 16,
                      color: AppColors.primaryColor,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ];
    }
  }
}

class _SortRow extends StatelessWidget {
  const _SortRow({required this.sort});

  final CommentSort sort;

  @override
  Widget build(BuildContext context) {
    final label = switch (sort) {
      CommentSort.mostPopular => 'most popular',
      CommentSort.mostRecent => 'most recent',
    };
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: GestureDetector(
        onTap: () async {
          final picked = await showFeedSortSheet(context, current: sort);
          if (picked != null && context.mounted) {
            context.read<PostDetailBloc>().add(PostDetailSortChanged(picked));
          }
        },
        child: Row(
          children: [
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Sort comments by ',
                    style: feedText(13, 20, color: kFeedGrey500),
                  ),
                  TextSpan(
                    text: label,
                    style: feedText(
                      13,
                      20,
                      weight: FontWeight.w700,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 3.w),
            FeedIcon(
              Assets.icons.feedChevronDown,
              size: 16,
              color: AppColors.primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}

/// Fixed "Add a comment" bar under the thread.
class _CommentComposer extends StatelessWidget {
  const _CommentComposer({required this.me, required this.onTap});

  final FeedAuthor? me;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: kFeedGrey100)),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          20.w,
          14.w,
          20.w,
          12.w + MediaQuery.viewPaddingOf(context).bottom,
        ),
        child: Row(
          children: [
            FeedPortrait(url: me?.photoUrl ?? '', size: 36),
            SizedBox(width: 10.w),
            Expanded(
              child: GestureDetector(
                onTap: onTap,
                child: Container(
                  height: 40.w,
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.w),
                    border: Border.all(color: kFeedGrey200),
                  ),
                  child: Text(
                    'Add a comment',
                    style: feedText(14, 20, color: kFeedGrey400),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
