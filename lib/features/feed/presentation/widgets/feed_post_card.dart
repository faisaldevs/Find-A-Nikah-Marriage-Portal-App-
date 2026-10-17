import 'package:find_a_nikah/core/ui/ui.dart';
import 'package:find_a_nikah/features/feed/domain/domain.dart';
import 'package:find_a_nikah/features/feed/presentation/widgets/feed_comment_preview.dart';
import 'package:find_a_nikah/features/feed/presentation/widgets/feed_icon.dart';
import 'package:find_a_nikah/features/feed/presentation/widgets/feed_portrait.dart';
import 'package:find_a_nikah/features/feed/presentation/widgets/feed_style.dart';
import 'package:find_a_nikah/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

/// One post (Figma "Post card"): author row, body, an optional comment
/// preview, a hairline, then likes · comments … views · share. Used by the
/// feed (body clipped to 4 lines), the post page (full body, Follow pill)
/// and profiles (comment preview).
class FeedPostCard extends StatelessWidget {
  const FeedPostCard({
    required this.post,
    required this.onMore,
    required this.onLike,
    required this.onComment,
    required this.onShare,
    super.key,
    this.onTap,
    this.onAuthorTap,
    this.onFollow,
    this.topicColor = kFeedTopicRed,
    this.maxBodyLines,
    this.commentsHighlighted = false,
  });

  final FeedPost post;
  final VoidCallback onMore;
  final VoidCallback onLike;
  final VoidCallback onComment;
  final VoidCallback onShare;
  final VoidCallback? onTap;
  final VoidCallback? onAuthorTap;

  /// Shows the pink "Follow" pill (post page) when set.
  final VoidCallback? onFollow;

  /// The design varies it per screen: red on the feed, pink on profiles,
  /// green on the post page.
  final Color topicColor;

  /// Clip the body with a "read more" link; null shows all of it.
  final int? maxBodyLines;

  /// The comment count in pink — the post page, where comments are open.
  final bool commentsHighlighted;

  @override
  Widget build(BuildContext context) {
    // Figma strokes sit inside the card, and Container adds the border to
    // its padding — so 15 + the 1pt border puts content 16pt in.
    final card = Container(
      padding: EdgeInsets.all(15.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6.w),
        border: Border.all(color: kFeedGrey200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Author(
            post: post,
            topicColor: topicColor,
            onAuthorTap: onAuthorTap,
            onFollow: onFollow,
            onMore: onMore,
          ),
          SizedBox(height: 12.w),
          _Body(text: post.body, maxLines: maxBodyLines),
          if (post.topComment case final comment?) ...[
            SizedBox(height: 12.w),
            FeedCommentPreview(comment: comment),
          ],
          SizedBox(height: 12.w),
          Container(height: 1.w, color: kFeedGrey100),
          SizedBox(height: 12.w),
          FeedEngagementRow(
            post: post,
            commentsHighlighted: commentsHighlighted,
            onLike: onLike,
            onComment: onComment,
            onShare: onShare,
          ),
        ],
      ),
    );
    if (onTap == null) return card;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: card,
    );
  }
}

class _Author extends StatelessWidget {
  const _Author({
    required this.post,
    required this.topicColor,
    required this.onAuthorTap,
    required this.onFollow,
    required this.onMore,
  });

  final FeedPost post;
  final Color topicColor;
  final VoidCallback? onAuthorTap;
  final VoidCallback? onFollow;
  final VoidCallback onMore;

  @override
  Widget build(BuildContext context) {
    final author = post.author;
    final who = Row(
      children: [
        FeedPortrait(
          url: author.photoUrl,
          size: 40,
          countryCode: author.countryCode,
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: author.name,
                      style: feedText(14, 18, weight: FontWeight.w700),
                    ),
                    TextSpan(
                      text: ' · @${author.handle}',
                      style: feedText(11, 18, color: kFeedGrey500),
                    ),
                  ],
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 3.w),
              Text.rich(
                TextSpan(
                  style: feedText(11, 15, color: kFeedGrey500),
                  children: [
                    TextSpan(
                      text: post.topic,
                      style: TextStyle(color: topicColor),
                    ),
                    TextSpan(text: ' · ${post.postedAgo}'),
                  ],
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
    return Row(
      children: [
        Expanded(
          child: onAuthorTap == null
              ? who
              : GestureDetector(
                  onTap: onAuthorTap,
                  behavior: HitTestBehavior.opaque,
                  child: who,
                ),
        ),
        if (onFollow != null) ...[
          SizedBox(width: 10.w),
          FeedPillButton(
            label: 'Follow',
            color: AppColors.primaryColor,
            height: 28,
            horizontalPadding: 12.75,
            onTap: onFollow!,
          ),
        ],
        SizedBox(width: 10.w),
        FeedTapIcon(
          asset: Assets.icons.feedEllipsisVertical,
          size: 18,
          tooltip: 'More',
          onTap: onMore,
        ),
      ],
    );
  }
}

/// Body text. With [maxLines], it's cut there with "…" and a green "read
/// more" line under it when it doesn't fit; "read more" expands it in
/// place.
class _Body extends StatefulWidget {
  const _Body({required this.text, required this.maxLines});

  final String text;
  final int? maxLines;

  @override
  State<_Body> createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final style = feedText(14, 20, color: kFeedGrey700);
    final maxLines = widget.maxLines;
    if (_expanded || maxLines == null) {
      return Text(widget.text, style: style);
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        final painter = TextPainter(
          text: TextSpan(text: widget.text, style: style),
          maxLines: maxLines,
          textDirection: Directionality.of(context),
          textScaler: MediaQuery.textScalerOf(context),
        )..layout(maxWidth: constraints.maxWidth);
        final overflows = painter.didExceedMaxLines;
        painter.dispose();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.text,
              style: style,
              maxLines: maxLines,
              overflow: TextOverflow.ellipsis,
            ),
            if (overflows)
              GestureDetector(
                onTap: () => setState(() => _expanded = true),
                child: Text(
                  'read more',
                  style: feedText(
                    14,
                    20,
                    weight: FontWeight.w500,
                    color: kFeedReadMoreGreen,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

/// Likes · comments on the left, views · share on the right.
class FeedEngagementRow extends StatelessWidget {
  const FeedEngagementRow({
    required this.post,
    required this.onLike,
    required this.onComment,
    required this.onShare,
    this.commentsHighlighted = false,
    super.key,
  });

  final FeedPost post;
  final bool commentsHighlighted;
  final VoidCallback onLike;
  final VoidCallback onComment;
  final VoidCallback onShare;

  /// 412 → "412", 1000 → "1k", 1500 → "1.5k", 4000 → "4k".
  static String compact(int n) {
    if (n < 1000) return '$n';
    if (n < 1000000) return '${_trim(n / 1000)}k';
    return '${_trim(n / 1000000)}m';
  }

  static String _trim(double v) {
    final s = v.toStringAsFixed(1);
    return s.endsWith('.0') ? s.substring(0, s.length - 2) : s;
  }

  @override
  Widget build(BuildContext context) {
    Widget stat(
      String icon,
      String label,
      double gap,
      double fontSize,
      VoidCallback? onTap, {
      Color? color,
    }) => GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FeedIcon(icon, size: 16, color: color),
          SizedBox(width: gap.w),
          Text(
            label,
            style: feedText(fontSize, 18, color: color ?? kFeedGrey500),
          ),
        ],
      ),
    );
    final likes = post.likeCount == 1 ? '1 Like' : '${post.likeCount} Likes';
    return SizedBox(
      height: 18.w,
      child: Row(
        children: [
          stat(Assets.icons.feedHeart, likes, 6, 12, onLike),
          SizedBox(width: 16.w),
          stat(
            Assets.icons.feedComment,
            '${post.commentCount}',
            6,
            12,
            onComment,
            color: commentsHighlighted ? AppColors.primaryColor : null,
          ),
          const Spacer(),
          stat(Assets.icons.feedViews, compact(post.viewCount), 4, 11, null),
          SizedBox(width: 14.w),
          FeedTapIcon(
            asset: Assets.icons.feedShare,
            size: 16,
            tooltip: 'Share',
            onTap: onShare,
          ),
        ],
      ),
    );
  }
}

class FeedTapIcon extends StatelessWidget {
  const FeedTapIcon({
    required this.asset,
    required this.size,
    required this.tooltip,
    required this.onTap,
    this.color,
    super.key,
  });

  final String asset;
  final double size;
  final String tooltip;
  final VoidCallback onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: FeedIcon(asset, size: size, color: color),
      ),
    );
  }
}

/// Fully-rounded solid button with a Bold 13 white label ("Follow",
/// "Message").
class FeedPillButton extends StatelessWidget {
  const FeedPillButton({
    required this.label,
    required this.color,
    required this.height,
    required this.onTap,
    this.horizontalPadding = 0,
    this.width,
    super.key,
  });

  final String label;
  final Color color;
  final double height;
  final double horizontalPadding;

  /// Fixed width; otherwise the label plus [horizontalPadding] each side.
  final double? width;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height.w,
        width: width?.w,
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding.w),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(height.w / 2),
        ),
        child: Text(
          label,
          style: feedText(
            13,
            18,
            weight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
