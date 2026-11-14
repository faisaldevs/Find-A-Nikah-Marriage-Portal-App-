import 'package:find_a_nikah/app/di.dart';
import 'package:find_a_nikah/core/error/failure.dart';
import 'package:find_a_nikah/core/ui/ui.dart';
import 'package:find_a_nikah/features/feed/domain/domain.dart';
import 'package:find_a_nikah/features/feed/presentation/bloc/post_detail_bloc.dart';
import 'package:find_a_nikah/features/feed/presentation/bloc/post_page_result.dart';
import 'package:find_a_nikah/features/feed/presentation/widgets/feed_circle_button.dart';
import 'package:find_a_nikah/features/feed/presentation/widgets/feed_comment_thread.dart';
import 'package:find_a_nikah/features/feed/presentation/widgets/feed_icon.dart';
import 'package:find_a_nikah/features/feed/presentation/widgets/feed_navigation.dart';
import 'package:find_a_nikah/features/feed/presentation/widgets/feed_notice.dart';
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

/// One post and its comments (Figma "feed post & comments"). Opened by post
/// id — from a card (which may pass the post as `extra` to draw at once),
/// a share link or a notification. Pops with a [PostPageResult] so the
/// list it was opened from can follow along.
class PostDetailPage extends StatelessWidget {
  const PostDetailPage({required this.postId, this.initial, super.key});

  final String postId;
  final FeedPost? initial;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          getIt<PostDetailBloc>(param1: postId, param2: initial)
            ..add(const PostDetailStarted()),
      child: const _PostDetailView(),
    );
  }
}

enum _CommentAction { edit, delete, report }

class _PostDetailView extends StatefulWidget {
  const _PostDetailView();

  @override
  State<_PostDetailView> createState() => _PostDetailViewState();
}

class _PostDetailViewState extends State<_PostDetailView> {
  final _scroll = ScrollController();
  final _text = TextEditingController();
  final _focus = FocusNode();

  /// Hidden author (muted / blocked) to report back on close.
  String? _hiddenUserId;
  bool _removed = false;

  @override
  void initState() {
    super.initState();
    _scroll.addListener(() {
      if (_scroll.position.extentAfter < 400) {
        context.read<PostDetailBloc>().add(const PostDetailLoadMore());
      }
    });
  }

  @override
  void dispose() {
    _scroll.dispose();
    _text.dispose();
    _focus.dispose();
    super.dispose();
  }

  PostPageResult _result(PostDetailState state) => PostPageResult(
    post: _removed ? null : state.post,
    removedPostId: _removed ? state.postId : null,
    hiddenUserId: _hiddenUserId,
  );

  void _close(PostDetailState state) => feedGoBack(context, _result(state));

  void _onState(BuildContext context, PostDetailState state) {
    switch (state.exit) {
      case PostDetailExit.none:
        break;
      case PostDetailExit.deleted:
        _removed = true;
        _close(state);
      case PostDetailExit.authorHidden:
        _hiddenUserId = state.post?.author.userId;
        _close(state);
    }
  }

  void _onComposer(BuildContext context, PostDetailState state) {
    switch (state.composer) {
      case ComposerEdit(:final comment):
        _text.text = comment.body;
        _text.selection = TextSelection.collapsed(offset: _text.text.length);
        _focus.requestFocus();
      case ComposerReply():
        _text.clear();
        _focus.requestFocus();
      case ComposerNew():
        break;
    }
  }

  Future<void> _commentMenu(FeedComment c) async {
    final bloc = context.read<PostDetailBloc>();
    final items = [
      if (c.isMine) ...[
        if (DateTime.now().toUtc().difference(c.createdAt.toUtc()) <
            feedEditWindow)
          const FeedSheetItem(
            _CommentAction.edit,
            'Edit comment',
            icon: Icons.edit_outlined,
          ),
        const FeedSheetItem(
          _CommentAction.delete,
          'Delete comment',
          icon: Icons.delete_outline,
        ),
      ] else
        FeedSheetItem(
          _CommentAction.report,
          'Report',
          asset: Assets.icons.feedSheetReport,
        ),
    ];
    final action = await showFeedActionsSheet<_CommentAction>(
      context,
      items: items,
    );
    if (action == null || !mounted) return;
    switch (action) {
      case _CommentAction.edit:
        bloc.add(PostDetailEditStarted(c));
      case _CommentAction.delete:
        final ok = await confirmFeedAction(
          context,
          title: 'Delete this comment?',
          message: 'This also removes its replies.',
          confirmLabel: 'Delete',
        );
        if (ok) bloc.add(PostDetailCommentDeleted(c.id));
      case _CommentAction.report:
        final reason = await showFeedReportReasons(
          context,
          FeedReportTarget.comment,
        );
        if (reason != null) {
          bloc.add(
            PostDetailReported(
              FeedReport(
                target: FeedReportTarget.comment,
                reason: reason,
                commentId: c.id,
              ),
            ),
          );
        }
    }
  }

  void _submit() {
    final text = _text.text;
    if (text.trim().isEmpty) return;
    context.read<PostDetailBloc>().add(PostDetailCommentSubmitted(text));
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<PostDetailBloc>();
    return MultiBlocListener(
      listeners: [
        BlocListener<PostDetailBloc, PostDetailState>(
          listenWhen: (a, b) => a.notice != b.notice,
          listener: (c, s) => showFeedNotice(c, s.notice),
        ),
        BlocListener<PostDetailBloc, PostDetailState>(
          listenWhen: (a, b) => a.exit != b.exit,
          listener: _onState,
        ),
        BlocListener<PostDetailBloc, PostDetailState>(
          listenWhen: (a, b) => a.composer != b.composer,
          listener: _onComposer,
        ),
        // The text box empties once the comment went through.
        BlocListener<PostDetailBloc, PostDetailState>(
          listenWhen: (a, b) => a.sending && !b.sending && b.notice == a.notice,
          listener: (c, s) {
            if (s.composer is ComposerNew) {
              _text.clear();
              _focus.unfocus();
            }
          },
        ),
      ],
      child: BlocBuilder<PostDetailBloc, PostDetailState>(
        builder: (context, state) {
          final post = state.post;
          return PopScope(
            canPop: false,
            onPopInvokedWithResult: (didPop, _) {
              if (!didPop) _close(state);
            },
            child: Scaffold(
              backgroundColor: Colors.white,
              resizeToAvoidBottomInset: true,
              body: SafeArea(
                bottom: false,
                child: Column(
                  children: [
                    _Header(
                      onBack: () => _close(state),
                      onShare: () => shareFeedLink(feedPostLink(state.postId)),
                    ),
                    SizedBox(height: 15.w),
                    Expanded(child: _body(context, state, bloc)),
                    if (post != null)
                      _Composer(
                        me: state.me,
                        mode: state.composer,
                        sending: state.sending,
                        controller: _text,
                        focus: _focus,
                        onSend: _submit,
                        onCancel: () => bloc.add(
                          const PostDetailComposerCancelled(),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _body(
    BuildContext context,
    PostDetailState state,
    PostDetailBloc bloc,
  ) {
    final post = state.post;
    if (post == null) {
      if (state.status == PostDetailStatus.failure) {
        final f = state.failure!;
        final gone = f.base is NotFoundFailure || f.base is ForbiddenFailure;
        return gone
            ? const AppMessageView(
                title: 'This post isn’t available',
                message: 'It may have been deleted.',
              )
            : AppErrorView(
                title: f.title,
                message: f.message,
                retryLabel: 'Try again',
                onRetry: () => bloc.add(const PostDetailStarted()),
              );
      }
      return const AppLoadingView();
    }
    void openProfile(FeedAuthor a) {
      context
          .push<void>(RoutePaths.feedProfilePath(a.userId), extra: a)
          .ignore();
    }

    Future<void> edit() async {
      final edited = await context.push<FeedPost>(
        RoutePaths.feedCompose,
        extra: post,
      );
      if (edited != null) bloc.add(PostDetailPostEdited(edited));
    }

    return ListView(
      controller: _scroll,
      padding: EdgeInsets.only(bottom: 24.w),
      children: [
        ColoredBox(
          color: kFeedPageBackground,
          child: Padding(
            padding: EdgeInsets.all(16.w).copyWith(left: 20.w, right: 20.w),
            child: FeedPostCard(
              post: post,
              topicColor: kFeedReadMoreGreen,
              commentsHighlighted: true,
              onAuthorTap: () => openProfile(post.author),
              onFollow: state.following == null || post.author.isMe
                  ? null
                  : () => bloc.add(const PostDetailFollowToggled()),
              following: state.following ?? false,
              onMore: () => showFeedPostMenu(
                context,
                post,
                FeedPostHandlers(
                  onEdit: edit,
                  onDelete: () => bloc.add(const PostDetailPostDeleted()),
                  onMute: () => bloc.add(const PostDetailAuthorMuted()),
                  onBlock: () => bloc.add(const PostDetailAuthorBlocked()),
                  onReport: (reason) => bloc.add(
                    PostDetailReported(
                      FeedReport(
                        target: FeedReportTarget.post,
                        reason: reason,
                        postId: post.id,
                      ),
                    ),
                  ),
                ),
              ),
              onLike: () => bloc.add(const PostDetailPostLiked()),
              onComment: _focus.requestFocus,
              onShare: () => shareFeedLink(feedPostLink(post.id)),
            ),
          ),
        ),
        SizedBox(height: 20.6.w),
        _SortRow(sort: state.sort),
        SizedBox(height: 22.6.w),
        ..._comments(context, state, bloc, openProfile),
      ],
    );
  }

  List<Widget> _comments(
    BuildContext context,
    PostDetailState state,
    PostDetailBloc bloc,
    ValueChanged<FeedAuthor> openProfile,
  ) {
    final list = state.comments;
    if (list.isIdle || list.isLoading) {
      return [SizedBox(height: 160.w, child: const AppLoadingView())];
    }
    if (list.hasFailed && list.items.isEmpty) {
      return [
        AppErrorView(
          title: list.failure!.title,
          message: list.failure!.message,
          retryLabel: 'Try again',
          onRetry: () => bloc.add(const PostDetailStarted()),
        ),
      ];
    }
    if (list.items.isEmpty) {
      return [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 24.w),
          child: const AppMessageView(
            title: 'No comments yet',
            message: 'Be the first to comment.',
          ),
        ),
      ];
    }
    final divider = Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.w),
      child: Container(height: 1.w, color: kFeedGrey100),
    );
    return [
      for (final (i, c) in list.items.indexed) ...[
        if (i > 0) divider,
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: FeedCommentThread(
            comment: c,
            onAuthorTap: openProfile,
            onMore: _commentMenu,
            onLike: (x) => bloc.add(PostDetailCommentLiked(x.id)),
            onReply: (x) => bloc.add(PostDetailReplyStarted(x)),
            onShare: (_) => shareFeedLink(feedPostLink(state.postId)),
            onMoreReplies: () => bloc.add(PostDetailRepliesRequested(c.id)),
          ),
        ),
      ],
      if (list.loadingMore)
        Padding(
          padding: EdgeInsets.symmetric(vertical: 16.w),
          child: const Center(child: CircularProgressIndicator()),
        ),
    ];
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.onBack, required this.onShare});

  final VoidCallback onBack;
  final VoidCallback onShare;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 8.4.h, 20.w, 0),
      child: Row(
        children: [
          FeedCircleButton(
            asset: Assets.icons.feedBack,
            iconSize: 24,
            iconColor: kFeedGrey900,
            tooltip: 'Back',
            onTap: onBack,
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
            onTap: onShare,
          ),
        ],
      ),
    );
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

/// Fixed "Add a comment" bar under the thread; shows what it is doing
/// (replying to someone / editing) above the field.
class _Composer extends StatelessWidget {
  const _Composer({
    required this.me,
    required this.mode,
    required this.sending,
    required this.controller,
    required this.focus,
    required this.onSend,
    required this.onCancel,
  });

  final FeedAuthor? me;
  final ComposerMode mode;
  final bool sending;
  final TextEditingController controller;
  final FocusNode focus;
  final VoidCallback onSend;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final banner = switch (mode) {
      ComposerNew() => null,
      ComposerReply(:final to) => 'Replying to @${to.author.handle}',
      ComposerEdit() => 'Editing comment',
    };
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: kFeedGrey100)),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          20.w,
          10.w,
          20.w,
          12.w + MediaQuery.viewPaddingOf(context).bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (banner != null)
              Padding(
                padding: EdgeInsets.only(bottom: 8.w),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        banner,
                        style: feedText(12, 16, color: kFeedGrey500),
                      ),
                    ),
                    GestureDetector(
                      onTap: onCancel,
                      child: Icon(Icons.close, size: 18.w, color: kFeedGrey500),
                    ),
                  ],
                ),
              ),
            Row(
              children: [
                FeedPortrait(url: me?.avatarUrl ?? '', size: 36),
                SizedBox(width: 10.w),
                Expanded(
                  child: Container(
                    constraints: BoxConstraints(minHeight: 40.w),
                    padding: EdgeInsets.only(left: 16.w, right: 4.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.w),
                      border: Border.all(color: kFeedGrey200),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: controller,
                            focusNode: focus,
                            minLines: 1,
                            maxLines: 4,
                            maxLength: feedCommentMaxLength,
                            textInputAction: TextInputAction.newline,
                            cursorColor: AppColors.primaryColor,
                            style: feedText(14, 20),
                            decoration: InputDecoration(
                              isCollapsed: true,
                              counterText: '',
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 10.w,
                              ),
                              hintText: 'Add a comment',
                              hintStyle: feedText(14, 20, color: kFeedGrey400),
                            ),
                          ),
                        ),
                        ValueListenableBuilder<TextEditingValue>(
                          valueListenable: controller,
                          builder: (_, value, _) {
                            final canSend =
                                value.text.trim().isNotEmpty && !sending;
                            return IconButton(
                              onPressed: canSend ? onSend : null,
                              icon: sending
                                  ? SizedBox.square(
                                      dimension: 18.w,
                                      child: const CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : Icon(
                                      Icons.send_rounded,
                                      size: 22.w,
                                      color: canSend
                                          ? AppColors.primaryColor
                                          : kFeedGrey300,
                                    ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
