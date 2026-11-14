import 'package:find_a_nikah/app/di.dart';
import 'package:find_a_nikah/core/ui/ui.dart';
import 'package:find_a_nikah/features/feed/presentation/bloc/member_search_bloc.dart';
import 'package:find_a_nikah/features/feed/presentation/widgets/feed_circle_button.dart';
import 'package:find_a_nikah/features/feed/presentation/widgets/feed_post_actions_sheet.dart';
import 'package:find_a_nikah/features/feed/presentation/widgets/feed_post_card.dart';
import 'package:find_a_nikah/features/feed/presentation/widgets/feed_profile_extras.dart';
import 'package:find_a_nikah/features/feed/presentation/widgets/feed_search_field.dart';
import 'package:find_a_nikah/features/feed/presentation/widgets/feed_style.dart';
import 'package:find_a_nikah/gen/assets.gen.dart';
import 'package:find_a_nikah/router/route_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:go_router/go_router.dart';

/// Search one member's posts and comments (Figma "profile post and comment
/// search"), on the server. Empty query shows the illustration.
class ProfileSearchPage extends StatelessWidget {
  const ProfileSearchPage({
    required this.userId,
    this.name,
    this.handle,
    super.key,
  });

  final String userId;
  final String? name;
  final String? handle;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<MemberSearchBloc>(param1: userId),
      child: _SearchView(name: name, handle: handle),
    );
  }
}

class _SearchView extends StatefulWidget {
  const _SearchView({this.name, this.handle});

  final String? name;
  final String? handle;

  @override
  State<_SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<_SearchView> {
  final _query = TextEditingController();
  final _scroll = ScrollController();

  @override
  void initState() {
    super.initState();
    _scroll.addListener(() {
      if (_scroll.hasClients && _scroll.position.extentAfter < 600) {
        context.read<MemberSearchBloc>().add(const MemberSearchLoadMore());
      }
    });
  }

  @override
  void dispose() {
    _query.dispose();
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<MemberSearchBloc>().state;
    final bloc = context.read<MemberSearchBloc>();
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 4.4.h, 20.w, 0),
              child: Row(
                children: [
                  FeedCircleButton(
                    asset: Assets.icons.feedBack,
                    iconSize: 24,
                    iconColor: kFeedGrey900,
                    tooltip: 'Back',
                    onTap: () => context.pop(),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: FeedSearchField(
                      controller: _query,
                      hint: widget.handle == null
                          ? 'Search this member'
                          : 'Search @${widget.handle}',
                      onChanged: (q) => bloc.add(MemberSearchQueryChanged(q)),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 17.w),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                children: [
                  _Chip(
                    label: 'Posts',
                    selected: state.where == MemberSearchIn.posts,
                    onTap: () => bloc.add(
                      const MemberSearchInChanged(MemberSearchIn.posts),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  _Chip(
                    label: 'Comments',
                    selected: state.where == MemberSearchIn.comments,
                    onTap: () => bloc.add(
                      const MemberSearchInChanged(MemberSearchIn.comments),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 13.w),
            Container(height: 1.w, color: kFeedGrey100),
            Expanded(child: _results(context, state)),
          ],
        ),
      ),
    );
  }

  Widget _results(BuildContext context, MemberSearchState state) {
    if (!state.hasQuery) {
      return _Prompt(name: widget.name ?? 'this member');
    }
    final list = switch (state.where) {
      MemberSearchIn.posts => state.posts,
      MemberSearchIn.comments => state.comments,
    };
    if (list.isIdle || list.isLoading) return const AppLoadingView();
    if (list.hasFailed) {
      return AppMessageView(
        title: 'Search failed',
        message: state.error ?? 'Try again in a moment.',
      );
    }
    if (state.where == MemberSearchIn.posts) {
      final posts = state.posts.items;
      if (posts.isEmpty) return const AppMessageView(title: 'No posts found');
      return ColoredBox(
        color: kFeedPageBackground,
        child: ListView.separated(
          controller: _scroll,
          padding: EdgeInsets.fromLTRB(20.w, 16.w, 20.w, 24.w),
          itemCount: posts.length,
          separatorBuilder: (_, _) => SizedBox(height: 16.w),
          itemBuilder: (context, i) => FeedPostCard(
            post: posts[i],
            topicColor: AppColors.primaryColor,
            onTap: () => context
                .push<void>(
                  RoutePaths.feedPostPath(posts[i].id),
                  extra: posts[i],
                )
                .ignore(),
            onMore: () => shareFeedLink(feedPostLink(posts[i].id)),
            onLike: () => context
                .push<void>(
                  RoutePaths.feedPostPath(posts[i].id),
                  extra: posts[i],
                )
                .ignore(),
            onComment: () => context
                .push<void>(
                  RoutePaths.feedPostPath(posts[i].id),
                  extra: posts[i],
                )
                .ignore(),
            onShare: () => shareFeedLink(feedPostLink(posts[i].id)),
          ),
        ),
      );
    }
    final rows = state.comments.items;
    if (rows.isEmpty) return const AppMessageView(title: 'No comments found');
    return ColoredBox(
      color: kFeedPageBackground,
      child: ListView.separated(
        controller: _scroll,
        padding: EdgeInsets.fromLTRB(20.w, 16.w, 20.w, 24.w),
        itemCount: rows.length,
        separatorBuilder: (_, _) => SizedBox(height: 16.w),
        itemBuilder: (context, i) => FeedUserCommentCard(
          row: rows[i],
          onTap: () => context
              .push<void>(RoutePaths.feedPostPath(rows[i].postId))
              .ignore(),
        ),
      ),
    );
  }
}

/// Posts / Comments toggle: 32pt high, 6pt corners; pink when on, grey with
/// an outline when off.
class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 32.w,
        padding: EdgeInsets.symmetric(horizontal: (selected ? 15 : 15.4).w),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryColor : kFeedGrey100,
          borderRadius: BorderRadius.circular(6.w),
          border: selected ? null : Border.all(color: kFeedGrey300),
        ),
        child: Text(
          label,
          style: feedText(
            13,
            20,
            weight: FontWeight.w500,
            color: selected ? Colors.white : kFeedGrey700,
          ),
        ),
      ),
    );
  }
}

class _Prompt extends StatelessWidget {
  const _Prompt({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(40.w, 44.w, 40.w, 24.w),
      child: Column(
        children: [
          Center(
            child: Image.asset(
              Assets.images.feedSearchIllustration,
              width: 140.w,
              height: 148.w,
            ),
          ),
          SizedBox(height: 54.2.w),
          Text(
            'Search for posts and comments from $name',
            textAlign: TextAlign.center,
            style: feedText(20, 26, weight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
