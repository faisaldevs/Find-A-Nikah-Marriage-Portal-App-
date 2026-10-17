import 'package:find_a_nikah/app/di.dart';
import 'package:find_a_nikah/core/ui/ui.dart';
import 'package:find_a_nikah/features/feed/domain/domain.dart';
import 'package:find_a_nikah/features/feed/presentation/bloc/create_post_bloc.dart';
import 'package:find_a_nikah/features/feed/presentation/widgets/feed_circle_button.dart';
import 'package:find_a_nikah/features/feed/presentation/widgets/feed_icon.dart';
import 'package:find_a_nikah/features/feed/presentation/widgets/feed_portrait.dart';
import 'package:find_a_nikah/features/feed/presentation/widgets/feed_style.dart';
import 'package:find_a_nikah/gen/assets.gen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:go_router/go_router.dart';

/// Compose a post (Figma "create post"). Pops with the published
/// [FeedPost] so the feed can show it straight away.
class CreatePostPage extends StatelessWidget {
  const CreatePostPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<CreatePostBloc>()..add(const CreatePostStarted()),
      child: const _CreatePostView(),
    );
  }
}

class _CreatePostView extends StatelessWidget {
  const _CreatePostView();

  void _comingSoon(BuildContext context, String what) =>
      CustomToast.showInfo(context, '$what — coming soon');

  Future<void> _pickGroup(BuildContext context) async {
    final bloc = context.read<CreatePostBloc>();
    final topic = await showFeedGroupPicker(
      context,
      topics: bloc.state.topics,
      selected: bloc.state.topic,
    );
    if (topic != null) bloc.add(CreatePostTopicSelected(topic));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CreatePostBloc, CreatePostState>(
      listenWhen: (a, b) => a.status != b.status,
      listener: (context, state) {
        switch (state.status) {
          case CreatePostStatus.published:
            context.pop(state.published);
          case CreatePostStatus.failure:
            CustomToast.showError(context, state.failure!.title);
          case CreatePostStatus.editing || CreatePostStatus.submitting:
            break;
        }
      },
      builder: (context, state) {
        final me = state.me;
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(20.w, 1.4.h, 20.w, 0),
                  child: Row(
                    children: [
                      FeedCircleButton(
                        asset: Assets.icons.feedClose,
                        iconSize: 24,
                        iconColor: kFeedGrey900,
                        tooltip: 'Close',
                        onTap: () => context.pop(),
                      ),
                      const Spacer(),
                      _PostButton(
                        enabled: state.canPost,
                        onTap: () => state.topic == null
                            ? _pickGroup(context)
                            : context.read<CreatePostBloc>().add(
                                const CreatePostSubmitted(),
                              ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.w),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Row(
                    children: [
                      FeedPortrait(
                        url: Assets.images.feedDefaultAvatar,
                        size: 40,
                      ),
                      SizedBox(width: 12.w),
                      _GroupSelect(
                        topic: state.topic,
                        onTap: () => _pickGroup(context),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 26.w),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: TextField(
                      autofocus: true,
                      maxLines: null,
                      expands: true,
                      textAlignVertical: TextAlignVertical.top,
                      cursorColor: AppColors.primaryColor,
                      style: feedText(16, 24),
                      onChanged: (t) => context.read<CreatePostBloc>().add(
                        CreatePostTextChanged(t),
                      ),
                      decoration: InputDecoration(
                        isCollapsed: true,
                        // Figma draws the text just after the cursor.
                        contentPadding: EdgeInsets.only(left: 4.w),
                        border: InputBorder.none,
                        hintText: 'Salaam ${me?.name ?? ''}, what’s new?',
                        hintStyle: feedText(16, 24, color: kFeedGrey500),
                      ),
                    ),
                  ),
                ),
                Padding(
                  // CupertinoSwitch's box is its 51×31 track + 4pt each side.
                  padding: EdgeInsets.only(right: 15.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Make this post anonymous',
                        style: feedText(
                          14,
                          20,
                          weight: FontWeight.w500,
                          color: kFeedGrey700,
                        ),
                      ),
                      SizedBox(width: 7.75.w),
                      SizedBox(
                        width: 59.w,
                        height: 39.w,
                        child: FittedBox(
                          child: CupertinoSwitch(
                            value: state.anonymous,
                            activeTrackColor: AppColors.primaryColor,
                            inactiveTrackColor: kFeedGrey300,
                            onChanged: (v) => context
                                .read<CreatePostBloc>()
                                .add(CreatePostAnonymousToggled(anonymous: v)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 7.5.w),
                Container(height: 1.w, color: kFeedGrey200),
                SizedBox(height: 12.w),
                Padding(
                  padding: EdgeInsets.only(left: 24.w),
                  child: Row(
                    children: [
                      for (final (i, (icon, what)) in [
                        (Assets.icons.feedMediaImage, 'Photos'),
                        (Assets.icons.feedMediaVideo, 'Videos'),
                        (Assets.icons.feedMediaGif, 'GIFs'),
                        (Assets.icons.feedMediaCamera, 'Camera'),
                      ].indexed) ...[
                        if (i > 0) SizedBox(width: 22.w),
                        GestureDetector(
                          onTap: () => _comingSoon(context, what),
                          child: FeedIcon(icon, size: 24, color: kFeedGrey700),
                        ),
                      ],
                    ],
                  ),
                ),
                SizedBox(height: 14.3.w),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// 72×36 "Post": grey until there's text, then pink.
class _PostButton extends StatelessWidget {
  const _PostButton({required this.enabled, required this.onTap});

  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        width: 72.w,
        height: 36.w,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: enabled ? AppColors.primaryColor : kFeedGrey100,
          borderRadius: BorderRadius.circular(6.w),
        ),
        child: Text(
          'Post',
          style: feedText(
            15,
            20,
            weight: FontWeight.w700,
            color: enabled ? Colors.white : kFeedGrey400,
          ),
        ),
      ),
    );
  }
}

/// "Select group" outlined dropdown (160×34).
class _GroupSelect extends StatelessWidget {
  const _GroupSelect({required this.topic, required this.onTap});

  final FeedTopic? topic;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 160.w,
        height: 34.w,
        padding: EdgeInsets.only(left: 9.w, right: 6.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.w),
          border: Border.all(color: kFeedGrey300),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                topic?.name ?? 'Select group',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: feedText(14, 20, weight: FontWeight.w500),
              ),
            ),
            FeedIcon(
              Assets.icons.feedChevronDown,
              size: 16,
              color: kFeedGrey500,
            ),
          ],
        ),
      ),
    );
  }
}

/// Group (topic) to post into, in the same card style as the post-actions
/// sheet. Not in the Figma flow — kept deliberately plain.
Future<FeedTopic?> showFeedGroupPicker(
  BuildContext context, {
  required List<FeedTopic> topics,
  required FeedTopic? selected,
}) {
  return showModalBottomSheet<FeedTopic>(
    context: context,
    useRootNavigator: true,
    backgroundColor: Colors.transparent,
    barrierColor: kFeedScrim,
    elevation: 0,
    builder: (context) => Padding(
      padding: EdgeInsets.fromLTRB(
        20.w,
        0,
        20.w,
        16.w + MediaQuery.viewPaddingOf(context).bottom,
      ),
      child: Material(
        color: kFeedSheetBackground,
        borderRadius: BorderRadius.circular(12.w),
        clipBehavior: Clip.antiAlias,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final t in topics)
              InkWell(
                onTap: () => Navigator.of(context).pop(t),
                child: SizedBox(
                  height: 56.w,
                  child: Row(
                    children: [
                      SizedBox(width: 20.w),
                      Expanded(
                        child: Text(
                          t.name,
                          style: feedText(
                            16,
                            22,
                            weight: FontWeight.w700,
                            color: kFeedGrey900,
                          ),
                        ),
                      ),
                      if (t == selected)
                        Image.asset(
                          Assets.icons.feedCheckCircle,
                          width: 20.w,
                          height: 20.w,
                        ),
                      SizedBox(width: 20.w),
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
