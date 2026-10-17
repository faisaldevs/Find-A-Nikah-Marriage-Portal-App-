import 'package:find_a_nikah/core/ui/ui.dart';
import 'package:find_a_nikah/features/feed/domain/domain.dart';
import 'package:find_a_nikah/features/feed/presentation/widgets/feed_icon.dart';
import 'package:find_a_nikah/features/feed/presentation/widgets/feed_portrait.dart';
import 'package:find_a_nikah/features/feed/presentation/widgets/feed_post_card.dart';
import 'package:find_a_nikah/features/feed/presentation/widgets/feed_style.dart';
import 'package:find_a_nikah/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

const _kAuthorBadge = Color(0xFFFDF0F6);

/// A comment and its replies on the post page (Figma "feed post &
/// comments"): 40pt photo for the comment, 36pt for replies indented 20pt.
class FeedCommentThread extends StatelessWidget {
  const FeedCommentThread({
    required this.comment,
    required this.onAuthorTap,
    required this.onMore,
    required this.onLike,
    required this.onReply,
    required this.onShare,
    super.key,
  });

  final FeedComment comment;
  final ValueChanged<FeedAuthor> onAuthorTap;
  final ValueChanged<FeedComment> onMore;
  final ValueChanged<FeedComment> onLike;
  final ValueChanged<FeedComment> onReply;
  final ValueChanged<FeedComment> onShare;

  @override
  Widget build(BuildContext context) {
    Widget tile(FeedComment c, {required bool isReply}) => _CommentTile(
      comment: c,
      isReply: isReply,
      onAuthorTap: () => onAuthorTap(c.author),
      onMore: () => onMore(c),
      onLike: () => onLike(c),
      onReply: () => onReply(c),
      onShare: () => onShare(c),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        tile(comment, isReply: false),
        for (final reply in comment.replies) ...[
          SizedBox(height: 14.w),
          Padding(
            padding: EdgeInsets.only(left: 20.w),
            child: tile(reply, isReply: true),
          ),
        ],
      ],
    );
  }
}

class _CommentTile extends StatelessWidget {
  const _CommentTile({
    required this.comment,
    required this.isReply,
    required this.onAuthorTap,
    required this.onMore,
    required this.onLike,
    required this.onReply,
    required this.onShare,
  });

  final FeedComment comment;
  final bool isReply;
  final VoidCallback onAuthorTap;
  final VoidCallback onMore;
  final VoidCallback onLike;
  final VoidCallback onReply;
  final VoidCallback onShare;

  @override
  Widget build(BuildContext context) {
    final author = comment.author;
    final grey = feedText(11, 15, color: kFeedGrey500);
    final meta = [
      '@${author.handle}',
      comment.postedAgo,
    ].join(' · ');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: onAuthorTap,
                behavior: HitTestBehavior.opaque,
                child: Row(
                  children: [
                    FeedPortrait(
                      url: author.photoUrl,
                      size: isReply ? 36 : 40,
                      countryCode: author.countryCode,
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  author.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: feedText(
                                    14,
                                    18,
                                    weight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              if (comment.isPostAuthor) ...[
                                SizedBox(width: 8.w),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 5.w,
                                    vertical: 2.w,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _kAuthorBadge,
                                    borderRadius: BorderRadius.circular(3.w),
                                  ),
                                  child: Text(
                                    'Author',
                                    style: feedText(
                                      10,
                                      14,
                                      weight: FontWeight.w500,
                                      color: AppColors.primaryColor,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          SizedBox(height: 3.w),
                          Text(
                            comment.edited ? '$meta (Edited)' : meta,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: grey,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 10.w),
            FeedTapIcon(
              asset: Assets.icons.feedEllipsisVertical,
              size: 18,
              tooltip: 'More',
              onTap: onMore,
            ),
          ],
        ),
        SizedBox(height: 15.w),
        Text.rich(
          TextSpan(
            style: feedText(14, 20, color: kFeedGrey700),
            children: [
              if (comment.mention case final handle?)
                TextSpan(
                  text: '@$handle ',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryColor,
                  ),
                ),
              TextSpan(text: comment.body),
            ],
          ),
        ),
        SizedBox(height: 15.w),
        SizedBox(
          height: 18.w,
          child: Row(
            children: [
              GestureDetector(
                onTap: onLike,
                behavior: HitTestBehavior.opaque,
                child: Row(
                  children: [
                    FeedIcon(Assets.icons.feedHeart, size: 16),
                    if (comment.likeCount > 0) ...[
                      SizedBox(width: 6.w),
                      Text(
                        comment.likeCount == 1
                            ? '1 Like'
                            : '${comment.likeCount} Likes',
                        style: grey,
                      ),
                    ],
                  ],
                ),
              ),
              SizedBox(width: 22.w),
              GestureDetector(
                onTap: onReply,
                behavior: HitTestBehavior.opaque,
                child: Row(
                  children: [
                    FeedIcon(
                      Assets.icons.feedReplies,
                      size: 12,
                      color: kFeedGrey500,
                    ),
                    SizedBox(width: 6.w),
                    Text('Reply', style: grey),
                  ],
                ),
              ),
              const Spacer(),
              if (!isReply)
                FeedTapIcon(
                  asset: Assets.icons.feedShare,
                  size: 16,
                  tooltip: 'Share',
                  onTap: onShare,
                ),
            ],
          ),
        ),
      ],
    );
  }
}
