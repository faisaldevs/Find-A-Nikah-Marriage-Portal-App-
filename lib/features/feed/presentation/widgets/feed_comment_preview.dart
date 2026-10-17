import 'package:find_a_nikah/core/ui/ui.dart';
import 'package:find_a_nikah/features/feed/domain/domain.dart';
import 'package:find_a_nikah/features/feed/presentation/widgets/feed_icon.dart';
import 'package:find_a_nikah/features/feed/presentation/widgets/feed_portrait.dart';
import 'package:find_a_nikah/features/feed/presentation/widgets/feed_style.dart';
import 'package:find_a_nikah/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

/// A post's top comment, previewed in a grey box inside its card (Figma
/// "profile", Posts tab): 24pt photo, name/handle, text, likes · replies,
/// and a pink "Reply".
class FeedCommentPreview extends StatelessWidget {
  const FeedCommentPreview({required this.comment, super.key});

  final FeedComment comment;

  @override
  Widget build(BuildContext context) {
    final grey = feedText(11, 15, color: kFeedGrey500);
    final likes = comment.likeCount == 1
        ? '1 Like'
        : '${comment.likeCount} Likes';
    final replies = comment.replyCount == 1
        ? '1 Reply'
        : '${comment.replyCount} Replies';
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16.w, 13.w, 16.w, 12.85.w),
      decoration: BoxDecoration(
        color: kFeedGrey100,
        borderRadius: BorderRadius.circular(6.w),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 3.w),
            child: FeedPortrait(
              url: comment.author.photoUrl,
              size: 24,
              countryCode: comment.author.countryCode,
            ),
          ),
          SizedBox(width: 6.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  comment.author.name,
                  style: feedText(13, 16, weight: FontWeight.w700),
                ),
                SizedBox(height: 2.2.w),
                Text('@${comment.author.handle}', style: grey),
                SizedBox(height: 10.2.w),
                Text(
                  comment.body,
                  style: feedText(14, 20, color: kFeedGrey700),
                ),
                SizedBox(height: 11.w),
                SizedBox(
                  height: 18.w,
                  child: Row(
                    children: [
                      FeedIcon(Assets.icons.feedHeart, size: 14),
                      SizedBox(width: 5.w),
                      Text(likes, style: grey),
                      SizedBox(width: 17.5.w),
                      FeedIcon(
                        Assets.icons.feedReplies,
                        size: 12,
                        color: kFeedGrey500,
                      ),
                      SizedBox(width: 6.w),
                      Text(replies, style: grey),
                    ],
                  ),
                ),
                SizedBox(height: 10.75.w),
                Text(
                  'Reply',
                  style: feedText(
                    12,
                    16,
                    weight: FontWeight.w700,
                    color: AppColors.primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
