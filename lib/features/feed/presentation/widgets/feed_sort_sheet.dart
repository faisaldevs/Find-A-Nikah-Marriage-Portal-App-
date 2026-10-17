import 'package:find_a_nikah/features/feed/domain/domain.dart';
import 'package:find_a_nikah/features/feed/presentation/widgets/feed_icon.dart';
import 'package:find_a_nikah/features/feed/presentation/widgets/feed_style.dart';
import 'package:find_a_nikah/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

/// "Sort comments by…" (Figma "sort comments by"): a full-width sheet with
/// two option cards, the current one outlined dark with a pink check.
/// Resolves to the picked order, or null when closed.
Future<CommentSort?> showFeedSortSheet(
  BuildContext context, {
  required CommentSort current,
}) {
  return showModalBottomSheet<CommentSort>(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    backgroundColor: kFeedSheetBackground,
    barrierColor: kFeedScrim,
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(12.w)),
    ),
    builder: (context) => _SortSheet(current: current),
  );
}

class _SortSheet extends StatelessWidget {
  const _SortSheet({required this.current});

  final CommentSort current;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        20.w,
        16.w,
        20.w,
        48.w + MediaQuery.viewPaddingOf(context).bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: FeedIcon(
              Assets.icons.feedClose,
              size: 24,
              color: kFeedGrey900,
            ),
          ),
          SizedBox(height: 8.2.w),
          Center(
            child: Text(
              'Sort comments by...',
              style: feedText(
                20,
                28,
                weight: FontWeight.w700,
                color: kFeedGrey900,
              ),
            ),
          ),
          SizedBox(height: 23.8.w),
          _Option(
            title: 'Most popular',
            description:
                'See the most relevant comments first, ordered by engagement',
            selected: current == CommentSort.mostPopular,
            onTap: () => Navigator.of(context).pop(CommentSort.mostPopular),
          ),
          SizedBox(height: 12.w),
          _Option(
            title: 'Most recent',
            description:
                'See the newest comments in your language, ordered by time',
            selected: current == CommentSort.mostRecent,
            onTap: () => Navigator.of(context).pop(CommentSort.mostRecent),
          ),
        ],
      ),
    );
  }
}

class _Option extends StatelessWidget {
  const _Option({
    required this.title,
    required this.description,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final String description;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        // + the 1pt border: 18pt to the text, 20pt to the check.
        padding: EdgeInsets.fromLTRB(17.w, 19.w, 19.w, 19.6.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.w),
          border: Border.all(color: selected ? kFeedGrey700 : kFeedGrey200),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: feedText(
                      16,
                      22,
                      weight: FontWeight.w500,
                      color: kFeedGrey900,
                    ),
                  ),
                  SizedBox(height: 5.6.w),
                  Text(
                    description,
                    style: feedText(14, 20, color: kFeedGrey500),
                  ),
                ],
              ),
            ),
            SizedBox(width: 16.w),
            if (selected)
              Image.asset(
                Assets.icons.feedCheckCircle,
                width: 20.w,
                height: 20.w,
              )
            else
              Container(
                width: 20.w,
                height: 20.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: kFeedGrey500, width: 2.w),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
