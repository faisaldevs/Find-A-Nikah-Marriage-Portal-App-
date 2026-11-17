import 'package:find_a_nikah/core/ui/ui.dart';
import 'package:find_a_nikah/features/feed/domain/domain.dart';
import 'package:find_a_nikah/features/feed/presentation/widgets/feed_comment_preview.dart';
import 'package:find_a_nikah/features/feed/presentation/widgets/feed_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

/// Which side of a member's profile is showing.
enum FeedProfileSide { feed, marriage }

/// Two-option pill switch: "Feed activity" | "Marriage profile".
class FeedProfileSwitch extends StatelessWidget {
  const FeedProfileSwitch({
    required this.selected,
    required this.onChanged,
    super.key,
  });

  final FeedProfileSide selected;
  final ValueChanged<FeedProfileSide> onChanged;

  @override
  Widget build(BuildContext context) {
    const labels = {
      FeedProfileSide.feed: 'Feed activity',
      FeedProfileSide.marriage: 'Marriage profile',
    };
    return Container(
      height: 40.w,
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: kFeedGrey100,
        borderRadius: BorderRadius.circular(20.w),
      ),
      child: Row(
        children: [
          for (final MapEntry(key: side, value: label) in labels.entries)
            Expanded(
              child: GestureDetector(
                onTap: () => onChanged(side),
                behavior: HitTestBehavior.opaque,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: side == selected
                        ? AppColors.primaryColor
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(17.w),
                  ),
                  child: Text(
                    label,
                    style: feedText(
                      13,
                      18,
                      weight: FontWeight.w700,
                      color: side == selected ? Colors.white : kFeedGrey500,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Posts · Comments · Likes counts under the header.
class FeedActivityStats extends StatelessWidget {
  const FeedActivityStats({required this.profile, super.key});

  final FeedProfile? profile;

  @override
  Widget build(BuildContext context) {
    final p = profile;
    String label(int n, String one, String many) => n == 1 ? one : many;
    final posts = p?.postsCount ?? 0;
    final comments = p?.commentsCount ?? 0;
    final likes = p?.likesCount ?? 0;
    final items = [
      ('$posts', label(posts, 'Post', 'Posts')),
      ('$comments', label(comments, 'Comment', 'Comments')),
      ('$likes', label(likes, 'Like', 'Likes')),
    ];
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.w),
        border: Border.all(color: kFeedGrey200),
      ),
      child: Row(
        children: [
          for (final (value, label) in items)
            Expanded(
              child: Column(
                children: [
                  Text(
                    value,
                    style: feedText(18, 24, weight: FontWeight.w700),
                  ),
                  Text(label, style: feedText(12, 16, color: kFeedGrey500)),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

/// A row of a member's Comments tab: the post it was left on, then the
/// comment.
class FeedUserCommentCard extends StatelessWidget {
  const FeedUserCommentCard({
    required this.row,
    required this.onTap,
    super.key,
  });

  final FeedUserComment row;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.w),
          border: Border.all(color: kFeedGrey200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'On ${row.postAuthorName}’s post · ${row.postPreview}',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: feedText(12, 16, color: kFeedGrey500),
            ),
            SizedBox(height: 10.w),
            FeedCommentPreview(comment: row.comment),
          ],
        ),
      ),
    );
  }
}
