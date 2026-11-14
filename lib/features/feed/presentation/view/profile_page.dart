import 'package:find_a_nikah/app/di.dart';
import 'package:find_a_nikah/core/error/failure.dart';
import 'package:find_a_nikah/core/ui/ui.dart';
import 'package:find_a_nikah/features/feed/domain/domain.dart';
import 'package:find_a_nikah/features/feed/presentation/bloc/feed_list_state.dart';
import 'package:find_a_nikah/features/feed/presentation/bloc/post_page_result.dart';
import 'package:find_a_nikah/features/feed/presentation/bloc/profile_bloc.dart';
import 'package:find_a_nikah/features/feed/presentation/widgets/feed_circle_button.dart';
import 'package:find_a_nikah/features/feed/presentation/widgets/feed_compliment_page.dart';
import 'package:find_a_nikah/features/feed/presentation/widgets/feed_icon.dart';
import 'package:find_a_nikah/features/feed/presentation/widgets/feed_marriage_preview.dart';
import 'package:find_a_nikah/features/feed/presentation/widgets/feed_navigation.dart';
import 'package:find_a_nikah/features/feed/presentation/widgets/feed_notice.dart';
import 'package:find_a_nikah/features/feed/presentation/widgets/feed_portrait.dart';
import 'package:find_a_nikah/features/feed/presentation/widgets/feed_post_actions_sheet.dart';
import 'package:find_a_nikah/features/feed/presentation/widgets/feed_post_card.dart';
import 'package:find_a_nikah/features/feed/presentation/widgets/feed_profile_extras.dart';
import 'package:find_a_nikah/features/feed/presentation/widgets/feed_style.dart';
import 'package:find_a_nikah/gen/assets.gen.dart';
import 'package:find_a_nikah/router/route_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:go_router/go_router.dart';

/// A member's community profile (Figma "profile"). Opened by `userId` from
/// an author row, a link or a search result; the tapped [author] (if any)
/// draws the header until the profile arrives.
class ProfilePage extends StatelessWidget {
  const ProfilePage({
    required this.userId,
    this.author,
    this.onOpenChat,
    super.key,
  });

  final String userId;
  final FeedAuthor? author;

  /// Opens the existing chat with this member. Supplied by the router,
  /// because Feed can't import the chat feature.
  final void Function(FeedAuthor author, {String? matchId})? onOpenChat;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          getIt<ProfileBloc>(param1: userId, param2: author)
            ..add(const ProfileStarted()),
      child: _ProfileView(onOpenChat: onOpenChat),
    );
  }
}

class _ProfileView extends StatefulWidget {
  const _ProfileView({this.onOpenChat});

  final void Function(FeedAuthor author, {String? matchId})? onOpenChat;

  @override
  State<_ProfileView> createState() => _ProfileViewState();
}

enum _ProfileMenu { mute, block, report }

class _ProfileViewState extends State<_ProfileView> {
  FeedProfileSide _side = FeedProfileSide.feed;

  Future<void> _menu(ProfileState state) async {
    final bloc = context.read<ProfileBloc>();
    final author = state.shownAuthor;
    if (author == null) return;
    final action = await showFeedActionsSheet<_ProfileMenu>(
      context,
      items: [
        FeedSheetItem(
          _ProfileMenu.mute,
          state.muted
              ? 'Unmute posts from ${author.name}'
              : 'Mute posts from ${author.name}',
          asset: Assets.icons.feedSheetMute,
        ),
        FeedSheetItem(
          _ProfileMenu.block,
          'Block ${author.name}',
          asset: Assets.icons.feedSheetBlock,
        ),
        FeedSheetItem(
          _ProfileMenu.report,
          'Report',
          asset: Assets.icons.feedSheetReport,
        ),
      ],
    );
    if (action == null || !mounted) return;
    switch (action) {
      case _ProfileMenu.mute:
        bloc.add(const ProfileMuteToggled());
      case _ProfileMenu.block:
        final ok = await confirmFeedAction(
          context,
          title: 'Block ${author.name}?',
          message:
              'You will no longer see each other on Feed, Marriage or Chat.',
          confirmLabel: 'Block',
        );
        if (ok) bloc.add(const ProfileBlocked());
      case _ProfileMenu.report:
        final reason = await showFeedReportReasons(
          context,
          FeedReportTarget.feedUser,
        );
        if (reason != null) {
          bloc.add(
            ProfileReported(
              FeedReport(
                target: FeedReportTarget.feedUser,
                reason: reason,
                targetUserId: state.userId,
              ),
            ),
          );
        }
    }
  }

  /// Message: write a compliment (as on Marriage); it is sent as a like with
  /// a first message and opens in Messages when they reply.
  Future<void> _message(ProfileBloc bloc, ProfileState state) async {
    final author = state.shownAuthor;
    switch (state.profile?.messageAction ?? FeedMessageAction.compliment) {
      case FeedMessageAction.chat:
        if (author != null && widget.onOpenChat != null) {
          widget.onOpenChat!(author, matchId: state.profile?.matchId);
        } else {
          await _compliment(bloc, state);
        }
      case FeedMessageAction.compliment:
        await _compliment(bloc, state);
      case FeedMessageAction.upgrade:
        if (mounted) {
          CustomToast.showInfo(
            context,
            'Messaging this member needs a paid plan — coming soon',
          );
        }
      case FeedMessageAction.none:
        return;
    }
  }

  Future<void> _compliment(ProfileBloc bloc, ProfileState state) async {
    if (state.complimentSent) {
      CustomToast.showInfo(context, 'You already sent a compliment');
      return;
    }
    final name = state.shownAuthor?.name ?? 'member';
    final text = await showFeedComplimentPage(
      context,
      name: name,
      initialText: state.complimentDraft,
    );
    if (text != null) bloc.add(ProfileComplimentSent(text));
  }

  Future<void> _openPost(FeedPost post) async {
    final bloc = context.read<ProfileBloc>();
    final result = await context.push<PostPageResult>(
      RoutePaths.feedPostPath(post.id),
      extra: post,
    );
    if (result == null) return;
    if (result.removedPostId case final id?) bloc.add(ProfilePostRemoved(id));
    if (result.post case final p?) bloc.add(ProfilePostChanged(p));
  }

  Future<void> _editPost(FeedPost post) async {
    final bloc = context.read<ProfileBloc>();
    final edited = await context.push<FeedPost>(
      RoutePaths.feedCompose,
      extra: post,
    );
    if (edited != null) bloc.add(ProfilePostChanged(edited));
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<ProfileBloc>().state;
    final author = state.shownAuthor;
    return MultiBlocListener(
      listeners: [
        BlocListener<ProfileBloc, ProfileState>(
          listenWhen: (a, b) => a.notice != b.notice,
          listener: (c, s) => showFeedNotice(c, s.notice),
        ),
        BlocListener<ProfileBloc, ProfileState>(
          listenWhen: (a, b) => !a.exit && b.exit,
          listener: (c, s) => feedGoBack(c),
        ),
      ],
      // Opened from a shared link there is nothing to pop to: Back goes to
      // the Feed tab instead of closing the app.
      child: PopScope(
        canPop: context.canPop(),
        onPopInvokedWithResult: (didPop, _) {
          if (!didPop) feedGoBack(context);
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            bottom: false,
            child: Column(
              children: [
                _TopBar(
                  onSearch: author == null
                      ? null
                      : () => context
                            .push<void>(
                              RoutePaths.feedProfileSearchPath(state.userId),
                              extra: author,
                            )
                            .ignore(),
                  onShare: () => shareFeedLink(feedMemberLink(state.userId)),
                  onMore: state.isMe || author == null
                      ? null
                      : () => _menu(state),
                ),
                Expanded(child: _content(context, state)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _content(BuildContext context, ProfileState state) {
    final author = state.shownAuthor;
    if (author == null) {
      return state.status == ProfileStatus.failure
          ? _failure(context, state)
          : const AppLoadingView();
    }
    if (state.status == ProfileStatus.failure && state.profile == null) {
      return _failure(context, state);
    }
    final bloc = context.read<ProfileBloc>();
    return NotificationListener<ScrollNotification>(
      onNotification: (n) {
        if (n.metrics.extentAfter < 600) bloc.add(const ProfileLoadMore());
        return false;
      },
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: _Header(
              author: author,
              profile: state.profile,
              isMe: state.isMe,
              following: state.following,
              followBusy: state.followBusy,
              showMessage:
                  state.profile?.messageAction != FeedMessageAction.none,
              onMessage: () => _message(bloc, state),
              onFollow: () => bloc.add(const ProfileFollowToggled()),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20.w, 18.w, 20.w, 0),
              child: Column(
                children: [
                  FeedProfileSwitch(
                    selected: _side,
                    onChanged: (v) {
                      setState(() => _side = v);
                      if (v == FeedProfileSide.marriage) {
                        bloc.add(const ProfileMarriageRequested());
                      }
                    },
                  ),
                  if (_side == FeedProfileSide.feed) ...[
                    SizedBox(height: 14.w),
                    FeedActivityStats(profile: state.profile),
                  ],
                ],
              ),
            ),
          ),
          if (_side == FeedProfileSide.feed)
            SliverToBoxAdapter(
              child: _Tabs(
                selected: state.tab,
                showLikes: state.isMe,
                onChanged: (t) => bloc.add(ProfileTabSelected(t)),
              ),
            ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: ColoredBox(
              color: kFeedPageBackground,
              child: _side == FeedProfileSide.marriage
                  ? _marriage(context, state)
                  : _tabContent(context, state),
            ),
          ),
        ],
      ),
    );
  }

  Widget _marriage(BuildContext context, ProfileState state) {
    final m = state.marriage;
    if (m.status == ProfileStatus.failure) {
      final f = m.failure!;
      final gone = f.base is NotFoundFailure || f.base is ForbiddenFailure;
      return Padding(
        padding: EdgeInsets.only(top: 40.w),
        child: gone
            ? const AppMessageView(
                title: 'Profile not available',
                message: 'This profile isn’t available for you.',
              )
            : AppErrorView(
                title: f.title,
                message: f.message,
                retryLabel: 'Try again',
                onRetry: () => context.read<ProfileBloc>().add(
                  const ProfileMarriageRequested(),
                ),
              ),
      );
    }
    final profile = m.profile;
    if (profile == null) {
      return SizedBox(height: 240.w, child: const AppLoadingView());
    }
    return FeedMarriagePreview(profile: profile, showGoldBadge: false);
  }

  Widget _failure(BuildContext context, ProfileState state) {
    final f = state.failure;
    if (f == null) return const AppLoadingView();
    final gone = f.base is NotFoundFailure || f.base is ForbiddenFailure;
    return gone
        ? const AppMessageView(
            title: 'This profile isn’t available',
            message: 'The member may have left or restricted their account.',
          )
        : AppErrorView(
            title: f.title,
            message: f.message,
            retryLabel: 'Try again',
            onRetry: () =>
                context.read<ProfileBloc>().add(const ProfileStarted()),
          );
  }

  Widget _tabContent(BuildContext context, ProfileState state) {
    final bloc = context.read<ProfileBloc>();
    Widget loadingOrEmpty<T>(FeedListState<T> list, String empty) {
      if (list.isIdle || list.isLoading) {
        return SizedBox(height: 200.w, child: const AppLoadingView());
      }
      if (list.hasFailed) {
        return AppErrorView(
          title: list.failure?.title ?? 'Something went wrong',
          message: list.failure?.message ?? '',
          retryLabel: 'Try again',
          onRetry: () => bloc.add(ProfileTabSelected(state.tab)),
        );
      }
      return Padding(
        padding: EdgeInsets.only(top: 40.w),
        child: Align(
          alignment: Alignment.topCenter,
          child: AppMessageView(title: empty),
        ),
      );
    }

    Widget postList(FeedListState<FeedPost> list, String empty) {
      if (!list.isReady || list.items.isEmpty) {
        return loadingOrEmpty(list, empty);
      }
      return Padding(
        padding: EdgeInsets.fromLTRB(20.w, 16.w, 20.w, 24.w),
        child: Column(
          children: [
            for (final (i, post) in list.items.indexed) ...[
              if (i > 0) SizedBox(height: 16.w),
              FeedPostCard(
                post: post,
                topicColor: AppColors.primaryColor,
                onTap: () => _openPost(post),
                onMore: () => showFeedPostMenu(
                  context,
                  post,
                  FeedPostHandlers(
                    onEdit: () => _editPost(post),
                    onDelete: () =>
                        bloc.add(ProfilePostDeleteRequested(post.id)),
                    onMute: () => bloc.add(
                      ProfileAuthorHideRequested(
                        post.author.userId,
                        block: false,
                      ),
                    ),
                    onBlock: () => bloc.add(
                      ProfileAuthorHideRequested(
                        post.author.userId,
                        block: true,
                      ),
                    ),
                    onReport: (reason) => bloc.add(
                      ProfileReported(
                        FeedReport(
                          target: FeedReportTarget.post,
                          reason: reason,
                          postId: post.id,
                        ),
                      ),
                    ),
                  ),
                ),
                onLike: () => bloc.add(ProfilePostLikeToggled(post.id)),
                onComment: () => _openPost(post),
                onShare: () => shareFeedLink(feedPostLink(post.id)),
              ),
            ],
            if (list.loadingMore)
              Padding(
                padding: EdgeInsets.only(top: 16.w),
                child: const Center(child: CircularProgressIndicator()),
              ),
          ],
        ),
      );
    }

    switch (state.tab) {
      case ProfileTab.posts:
        return postList(state.posts, 'No posts yet');
      case ProfileTab.likes:
        return postList(state.likes, 'No likes yet');
      case ProfileTab.comments:
        final list = state.comments;
        if (!list.isReady || list.items.isEmpty) {
          return loadingOrEmpty(list, 'No comments yet');
        }
        return Padding(
          padding: EdgeInsets.fromLTRB(20.w, 16.w, 20.w, 24.w),
          child: Column(
            children: [
              for (final (i, row) in list.items.indexed) ...[
                if (i > 0) SizedBox(height: 16.w),
                FeedUserCommentCard(
                  row: row,
                  onTap: () => context
                      .push<void>(RoutePaths.feedPostPath(row.postId))
                      .ignore(),
                ),
              ],
              if (list.loadingMore)
                Padding(
                  padding: EdgeInsets.only(top: 16.w),
                  child: const Center(child: CircularProgressIndicator()),
                ),
            ],
          ),
        );
    }
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({
    required this.onSearch,
    required this.onShare,
    required this.onMore,
  });

  final VoidCallback? onSearch;
  final VoidCallback onShare;
  final VoidCallback? onMore;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 3.4.h, 20.w, 0),
      child: Row(
        children: [
          FeedCircleButton(
            asset: Assets.icons.feedBack,
            iconSize: 24,
            iconColor: kFeedGrey900,
            tooltip: 'Back',
            onTap: () => feedGoBack(context),
          ),
          const Spacer(),
          if (onSearch != null) ...[
            FeedCircleButton(
              asset: Assets.icons.feedSearch,
              iconSize: 16,
              tooltip: 'Search',
              onTap: onSearch!,
            ),
            SizedBox(width: 10.w),
          ],
          FeedCircleButton(
            asset: Assets.icons.feedShare,
            iconSize: 16,
            iconColor: kFeedGrey950,
            tooltip: 'Share',
            onTap: onShare,
          ),
          if (onMore != null) ...[
            SizedBox(width: 10.w),
            FeedTapIcon(
              asset: Assets.icons.feedEllipsisVertical,
              size: 18,
              tooltip: 'More',
              onTap: onMore!,
            ),
          ],
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.author,
    required this.profile,
    required this.isMe,
    required this.following,
    required this.followBusy,
    required this.showMessage,
    required this.onMessage,
    required this.onFollow,
  });

  final FeedAuthor author;
  final FeedProfile? profile;
  final bool isMe;
  final bool following;
  final bool followBusy;
  final bool showMessage;
  final VoidCallback onMessage;
  final VoidCallback onFollow;

  @override
  Widget build(BuildContext context) {
    final count = feedText(14, 20, weight: FontWeight.w700);
    final label = feedText(
      14,
      20,
      weight: FontWeight.w500,
      color: kFeedGrey500,
    );
    final small = feedText(12, 16, color: kFeedGrey600);
    final p = profile;
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 26.w, 20.w, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FeedPortrait(url: author.avatarUrl, size: 64),
              SizedBox(width: 14.w),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(top: 3.5.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        author.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: feedText(24, 32, weight: FontWeight.w700),
                      ),
                      SizedBox(height: 4.w),
                      Text(
                        '@${author.handle}',
                        style: feedText(
                          14,
                          18,
                          weight: FontWeight.w500,
                          color: kFeedGrey500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 17.5.w),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(text: '${p?.followers ?? 0}', style: count),
                TextSpan(text: ' Followers', style: label),
                WidgetSpan(child: SizedBox(width: 18.w)),
                TextSpan(text: '${p?.following ?? 0}', style: count),
                TextSpan(text: ' Following', style: label),
              ],
            ),
          ),
          SizedBox(height: 17.5.w),
          SizedBox(
            height: 16.w,
            child: Row(
              children: [
                if (author.countryCode != null) ...[
                  FeedPortraitFlag(countryCode: author.countryCode!),
                  SizedBox(width: 6.1.w),
                ],
                if (p != null && p.countryName.isNotEmpty)
                  Text(p.countryName, style: small),
                SizedBox(width: 13.85.w),
                if (p != null && p.joined.isNotEmpty) ...[
                  FeedIcon(
                    Assets.icons.feedCalendar,
                    size: 16,
                    color: kFeedGrey500,
                  ),
                  SizedBox(width: 5.2.w),
                  Text('Joined ${p.joined}', style: small),
                ],
              ],
            ),
          ),
          if (!isMe) ...[
            SizedBox(height: 18.w),
            Row(
              children: [
                if (showMessage) ...[
                  FeedPillButton(
                    label: 'Message',
                    color: kFeedNavy,
                    height: 36,
                    width: 104,
                    onTap: onMessage,
                  ),
                  SizedBox(width: 10.w),
                ],
                FeedPillButton(
                  label: following ? 'Following' : 'Follow',
                  color: following ? kFeedGrey500 : AppColors.primaryColor,
                  height: 36,
                  width: 104,
                  onTap: followBusy ? () {} : onFollow,
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

/// Posts · Comments · Likes (own profile only), the active one in pink with
/// a 1pt underline sitting on the grey hairline below the row.
class _Tabs extends StatelessWidget {
  const _Tabs({
    required this.selected,
    required this.showLikes,
    required this.onChanged,
  });

  final ProfileTab selected;
  final bool showLikes;
  final ValueChanged<ProfileTab> onChanged;

  @override
  Widget build(BuildContext context) {
    final labels = {
      ProfileTab.posts: 'Posts',
      ProfileTab.comments: 'Comments',
      if (showLikes) ProfileTab.likes: 'Likes',
    };
    return Padding(
      padding: EdgeInsets.only(top: 34.w),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 16.w, right: 4.w),
            child: Row(
              children: [
                for (final MapEntry(key: tab, value: label) in labels.entries)
                  GestureDetector(
                    onTap: () => onChanged(tab),
                    behavior: HitTestBehavior.opaque,
                    child: IntrinsicWidth(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 14.4.w),
                            child: Text(
                              label,
                              textAlign: TextAlign.center,
                              style: tab == selected
                                  ? feedText(
                                      14,
                                      20,
                                      weight: FontWeight.w700,
                                      color: AppColors.primaryColor,
                                    )
                                  : feedText(
                                      14,
                                      20,
                                      weight: FontWeight.w500,
                                      color: kFeedGrey500,
                                    ),
                            ),
                          ),
                          SizedBox(height: 12.w),
                          Container(
                            height: 1.w,
                            color: tab == selected
                                ? AppColors.primaryColor
                                : Colors.transparent,
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Container(height: 1.w, color: kFeedGrey200),
        ],
      ),
    );
  }
}
