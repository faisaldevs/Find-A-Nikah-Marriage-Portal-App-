import 'package:find_a_nikah/app/di.dart';
import 'package:find_a_nikah/core/ui/ui.dart';
import 'package:find_a_nikah/features/feed/domain/domain.dart';
import 'package:find_a_nikah/features/feed/presentation/bloc/create_post_bloc.dart';
import 'package:find_a_nikah/features/feed/presentation/widgets/feed_circle_button.dart';
import 'package:find_a_nikah/features/feed/presentation/widgets/feed_icon.dart';
import 'package:find_a_nikah/features/feed/presentation/widgets/feed_portrait.dart';
import 'package:find_a_nikah/features/feed/presentation/widgets/feed_style.dart';
import 'package:find_a_nikah/gen/assets.gen.dart';
// import 'package:flutter/cupertino.dart'; // only the anonymous switch used it
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:go_router/go_router.dart';

/// Compose a post (Figma "create post"). Pops with the published
/// [FeedPost] so the feed can show it straight away.
class CreatePostPage extends StatelessWidget {
  const CreatePostPage({this.editing, super.key});

  /// The post being edited (body only); null writes a new post.
  final FeedPost? editing;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          getIt<CreatePostBloc>(param1: editing)
            ..add(const CreatePostStarted()),
      child: _CreatePostView(editing: editing),
    );
  }
}

class _CreatePostView extends StatefulWidget {
  const _CreatePostView({this.editing});

  final FeedPost? editing;

  @override
  State<_CreatePostView> createState() => _CreatePostViewState();
}

class _CreatePostViewState extends State<_CreatePostView> {
  late final _controller = TextEditingController(text: widget.editing?.body);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _comingSoon(BuildContext context, String what) =>
      CustomToast.showInfo(context, '$what — coming soon');

  // Kept for when topics come back to the composer; unused for now.
  // ignore: unused_element
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
            // The server's own words (rate limit, edit window, …) when it
            // sent any, else the generic title.
            final f = state.failure!;
            CustomToast.showError(
              context,
              f.message.isNotEmpty ? f.message : f.title,
            );
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
                        label: state.isEditing ? 'Save' : 'Post',
                        enabled: state.canPost,
                        onTap: () => context.read<CreatePostBloc>().add(
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
                        url: (me?.photoUrl.isNotEmpty ?? false)
                            ? me!.photoUrl
                            : Assets.images.feedDefaultAvatar,
                        size: 40,
                      ),
                      SizedBox(width: 16.w),
                      // Was a "Select topic" dropdown here and these icons in
                      // a bar under the text; they sit beside the avatar now.
                      // _GroupSelect(
                      //   topic: state.topic,
                      //   locked: state.isEditing,
                      //   onTap: () =>
                      //       state.isEditing ? null : _pickGroup(context),
                      // ),
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
                SizedBox(height: 26.w),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: TextField(
                      controller: _controller,
                      maxLength: feedPostMaxLength,
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
                        counterText: '',
                        // Figma draws the text just after the cursor.
                        contentPadding: EdgeInsets.only(left: 4.w),
                        border: InputBorder.none,
                        hintText: 'Salaam ${me?.name ?? ''}, what’s new?',
                        hintStyle: feedText(16, 24, color: kFeedGrey500),
                      ),
                    ),
                  ),
                ),
                // Anonymous posting dropped: posts go out under the member.
                // Padding(
                //   // CupertinoSwitch's box is its 51×31 track + 4pt each side.
                //   padding: EdgeInsets.only(right: 15.w),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.end,
                //     children: [
                //       Text(
                //         'Make this post anonymous',
                //         style: feedText(
                //           14,
                //           20,
                //           weight: FontWeight.w500,
                //           color: kFeedGrey700,
                //         ),
                //       ),
                //       SizedBox(width: 7.75.w),
                //       SizedBox(
                //         width: 59.w,
                //         height: 39.w,
                //         child: FittedBox(
                //           child: CupertinoSwitch(
                //             value: state.anonymous,
                //             activeTrackColor: AppColors.primaryColor,
                //             inactiveTrackColor: kFeedGrey300,
                //             onChanged: (v) => context
                //                 .read<CreatePostBloc>()
                //                 .add(
                //                   CreatePostAnonymousToggled(anonymous: v),
                //                 ),
                //           ),
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                // Moved up beside the avatar (above):
                // SizedBox(height: 7.5.w),
                // Container(height: 1.w, color: kFeedGrey200),
                // SizedBox(height: 12.w),
                // Padding(
                // padding: EdgeInsets.only(left: 24.w),
                // child: Row(
                // children: [
                // for (final (i, (icon, what)) in [
                // (Assets.icons.feedMediaImage, 'Photos'),
                // (Assets.icons.feedMediaVideo, 'Videos'),
                // (Assets.icons.feedMediaGif, 'GIFs'),
                // (Assets.icons.feedMediaCamera, 'Camera'),
                // ].indexed) ...[
                // if (i > 0) SizedBox(width: 22.w),
                // GestureDetector(
                // onTap: () => _comingSoon(context, what),
                // child: FeedIcon(icon, size: 24, color: kFeedGrey700),
                // ),
                // ],
                // ],
                // ),
                // ),
                // SizedBox(height: 14.3.w),
                SizedBox(height: 12.w),
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
  const _PostButton({
    required this.label,
    required this.enabled,
    required this.onTap,
  });

  final String label;
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
          label,
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
// Kept for when topics come back to the composer; unused for now.
// ignore: unused_element
class _GroupSelect extends StatelessWidget {
  const _GroupSelect({
    required this.topic,
    required this.onTap,
    // ignore: unused_element_parameter
    this.locked = false,
  });

  final FeedTopic? topic;

  /// Editing: the topic can't be changed, so no dropdown arrow.
  final bool locked;
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
                topic?.name ?? 'Select topic',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: feedText(14, 20, weight: FontWeight.w500),
              ),
            ),
            if (!locked)
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
            // No group the member can post into (none created yet, or the
            // list failed to load): say so instead of an empty sheet.
            if (topics.isEmpty)
              Padding(
                padding: EdgeInsets.all(20.w),
                child: Text(
                  'No groups available to post in right now.',
                  textAlign: TextAlign.center,
                  style: feedText(
                    16,
                    22,
                    weight: FontWeight.w500,
                    color: kFeedGrey900,
                  ),
                ),
              ),
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
