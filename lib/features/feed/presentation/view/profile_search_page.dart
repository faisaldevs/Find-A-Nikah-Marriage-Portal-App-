import 'package:find_a_nikah/app/di.dart';
import 'package:find_a_nikah/core/ui/ui.dart';
import 'package:find_a_nikah/features/feed/domain/domain.dart';
import 'package:find_a_nikah/features/feed/presentation/bloc/profile_bloc.dart';
import 'package:find_a_nikah/features/feed/presentation/widgets/feed_circle_button.dart';
import 'package:find_a_nikah/features/feed/presentation/widgets/feed_post_card.dart';
import 'package:find_a_nikah/features/feed/presentation/widgets/feed_search_field.dart';
import 'package:find_a_nikah/features/feed/presentation/widgets/feed_style.dart';
import 'package:find_a_nikah/gen/assets.gen.dart';
import 'package:find_a_nikah/router/route_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:go_router/go_router.dart';

enum _SearchIn { posts, comments }

/// Search one member's posts and comments (Figma "profile post and comment
/// search"). Empty query shows the illustration.
class ProfileSearchPage extends StatelessWidget {
  const ProfileSearchPage({required this.author, super.key});

  final FeedAuthor author;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          getIt<ProfileBloc>(param1: author)..add(const ProfileStarted()),
      child: _ProfileSearchView(author: author),
    );
  }
}

class _ProfileSearchView extends StatefulWidget {
  const _ProfileSearchView({required this.author});

  final FeedAuthor author;

  @override
  State<_ProfileSearchView> createState() => _ProfileSearchViewState();
}

class _ProfileSearchViewState extends State<_ProfileSearchView> {
  final _query = TextEditingController();
  _SearchIn _in = _SearchIn.posts;

  @override
  void initState() {
    super.initState();
    _query.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _query.dispose();
    super.dispose();
  }

  void _comingSoon(String what) =>
      CustomToast.showInfo(context, '$what — coming soon');

  @override
  Widget build(BuildContext context) {
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
                      hint: 'Search @${widget.author.handle}',
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
                    selected: _in == _SearchIn.posts,
                    onTap: () => setState(() => _in = _SearchIn.posts),
                  ),
                  SizedBox(width: 12.w),
                  _Chip(
                    label: 'Comments',
                    selected: _in == _SearchIn.comments,
                    onTap: () => setState(() => _in = _SearchIn.comments),
                  ),
                ],
              ),
            ),
            SizedBox(height: 13.w),
            Container(height: 1.w, color: kFeedGrey100),
            Expanded(child: _results(context)),
          ],
        ),
      ),
    );
  }

  Widget _results(BuildContext context) {
    final q = _query.text.trim().toLowerCase();
    if (q.isEmpty) return _Prompt(name: widget.author.name);
    if (_in == _SearchIn.comments) {
      return const AppMessageView(title: 'No comments found');
    }
    final posts = context
        .watch<ProfileBloc>()
        .state
        .posts
        .where((p) => p.body.toLowerCase().contains(q))
        .toList();
    if (posts.isEmpty) return const AppMessageView(title: 'No posts found');
    return ColoredBox(
      color: kFeedPageBackground,
      child: ListView.separated(
        padding: EdgeInsets.fromLTRB(20.w, 16.w, 20.w, 24.w),
        itemCount: posts.length,
        separatorBuilder: (_, _) => SizedBox(height: 16.w),
        itemBuilder: (context, i) => FeedPostCard(
          post: posts[i],
          topicColor: AppColors.primaryColor,
          onTap: () =>
              context.push<void>(RoutePaths.feedPost, extra: posts[i]).ignore(),
          onMore: () => _comingSoon('Post options'),
          onLike: () => _comingSoon('Likes'),
          onComment: () => _comingSoon('Comments'),
          onShare: () => _comingSoon('Share'),
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
