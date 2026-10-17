import 'package:find_a_nikah/app/di.dart';
import 'package:find_a_nikah/core/ui/ui.dart';
import 'package:find_a_nikah/features/feed/domain/domain.dart';
import 'package:find_a_nikah/features/feed/presentation/bloc/profile_bloc.dart';
import 'package:find_a_nikah/features/feed/presentation/widgets/feed_circle_button.dart';
import 'package:find_a_nikah/features/feed/presentation/widgets/feed_icon.dart';
import 'package:find_a_nikah/features/feed/presentation/widgets/feed_portrait.dart';
import 'package:find_a_nikah/features/feed/presentation/widgets/feed_post_actions_sheet.dart';
import 'package:find_a_nikah/features/feed/presentation/widgets/feed_post_card.dart';
import 'package:find_a_nikah/features/feed/presentation/widgets/feed_style.dart';
import 'package:find_a_nikah/gen/assets.gen.dart';
import 'package:find_a_nikah/router/route_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:go_router/go_router.dart';

enum _ProfileTab { posts, comments, likes, groups }

/// A member's community profile (Figma "profile"). Opened from an author
/// row; the author travels as the route's `extra`.
class ProfilePage extends StatelessWidget {
  const ProfilePage({required this.author, super.key});

  final FeedAuthor author;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          getIt<ProfileBloc>(param1: author)..add(const ProfileStarted()),
      child: const _ProfileView(),
    );
  }
}

class _ProfileView extends StatefulWidget {
  const _ProfileView();

  @override
  State<_ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<_ProfileView> {
  _ProfileTab _tab = _ProfileTab.posts;

  void _comingSoon(String what) =>
      CustomToast.showInfo(context, '$what — coming soon');

  @override
  Widget build(BuildContext context) {
    final state = context.watch<ProfileBloc>().state;
    final author = state.profile?.author ?? state.author;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 3.4.h, 20.w, 0),
              child: Row(
                children: [
                  FeedCircleButton(
                    asset: Assets.icons.feedBack,
                    iconSize: 24,
                    iconColor: kFeedGrey900,
                    tooltip: 'Back',
                    onTap: () => context.pop(),
                  ),
                  const Spacer(),
                  FeedCircleButton(
                    asset: Assets.icons.feedSearch,
                    iconSize: 16,
                    tooltip: 'Search',
                    onTap: () => context
                        .push<void>(
                          RoutePaths.feedProfileSearch,
                          extra: author,
                        )
                        .ignore(),
                  ),
                  SizedBox(width: 10.w),
                  FeedCircleButton(
                    asset: Assets.icons.feedShare,
                    iconSize: 16,
                    iconColor: kFeedGrey950,
                    tooltip: 'Share',
                    onTap: () => _comingSoon('Share'),
                  ),
                  SizedBox(width: 10.w),
                  FeedTapIcon(
                    asset: Assets.icons.feedEllipsisVertical,
                    size: 18,
                    tooltip: 'More',
                    onTap: () async {
                      final action = await showFeedPostActions(
                        context,
                        authorName: author.name,
                        canSave: false,
                      );
                      if (action != null && mounted) _comingSoon(action.name);
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: _Header(
                      author: author,
                      profile: state.profile,
                      onMessage: () => _comingSoon('Messages'),
                      onFollow: () => _comingSoon('Follow ${author.name}'),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: _Tabs(
                      selected: _tab,
                      onChanged: (t) => setState(() => _tab = t),
                    ),
                  ),
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: ColoredBox(
                      color: kFeedPageBackground,
                      child: _content(state),
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

  Widget _content(ProfileState state) {
    if (_tab != _ProfileTab.posts) {
      return Padding(
        padding: EdgeInsets.only(top: 40.w),
        child: const Align(
          alignment: Alignment.topCenter,
          child: AppMessageView(title: 'Nothing here yet'),
        ),
      );
    }
    return switch (state.status) {
      ProfileStatus.loading => SizedBox(
        height: 200.w,
        child: const AppLoadingView(),
      ),
      ProfileStatus.failure => AppErrorView(
        title: state.failure!.title,
        message: state.failure!.message,
        retryLabel: 'Try again',
        onRetry: () => context.read<ProfileBloc>().add(const ProfileStarted()),
      ),
      ProfileStatus.ready => Padding(
        padding: EdgeInsets.fromLTRB(20.w, 16.w, 20.w, 24.w),
        child: Column(
          children: [
            for (final (i, post) in state.posts.indexed) ...[
              if (i > 0) SizedBox(height: 16.w),
              FeedPostCard(
                post: post,
                topicColor: AppColors.primaryColor,
                onTap: () => context
                    .push<void>(RoutePaths.feedPost, extra: post)
                    .ignore(),
                onMore: () => _comingSoon('Post options'),
                onLike: () => _comingSoon('Likes'),
                onComment: () => context
                    .push<void>(RoutePaths.feedPost, extra: post)
                    .ignore(),
                onShare: () => _comingSoon('Share'),
              ),
            ],
          ],
        ),
      ),
    };
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.author,
    required this.profile,
    required this.onMessage,
    required this.onFollow,
  });

  final FeedAuthor author;
  final FeedProfile? profile;
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
              FeedPortrait(url: author.photoUrl, size: 64),
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
                if (p != null) Text(p.countryName, style: small),
                SizedBox(width: 13.85.w),
                FeedIcon(
                  Assets.icons.feedCalendar,
                  size: 16,
                  color: kFeedGrey500,
                ),
                SizedBox(width: 5.2.w),
                if (p != null) Text('Joined ${p.joined}', style: small),
              ],
            ),
          ),
          SizedBox(height: 18.w),
          Row(
            children: [
              FeedPillButton(
                label: 'Message',
                color: kFeedNavy,
                height: 36,
                width: 104,
                onTap: onMessage,
              ),
              SizedBox(width: 10.w),
              FeedPillButton(
                label: 'Follow',
                color: AppColors.primaryColor,
                height: 36,
                width: 93,
                onTap: onFollow,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Posts · Comments · Likes · Groups, the active one in pink with a 1pt
/// underline sitting on the grey hairline below the row.
class _Tabs extends StatelessWidget {
  const _Tabs({required this.selected, required this.onChanged});

  final _ProfileTab selected;
  final ValueChanged<_ProfileTab> onChanged;

  @override
  Widget build(BuildContext context) {
    const labels = {
      _ProfileTab.posts: 'Posts',
      _ProfileTab.comments: 'Comments',
      _ProfileTab.likes: 'Likes',
      _ProfileTab.groups: 'Groups',
    };
    return Padding(
      padding: EdgeInsets.only(top: 34.w),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 16.w, right: 4.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
