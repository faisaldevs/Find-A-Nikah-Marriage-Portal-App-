import 'package:find_a_nikah/features/feed/presentation/widgets/feed_icon.dart';
import 'package:find_a_nikah/features/feed/presentation/widgets/feed_style.dart';
import 'package:find_a_nikah/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

enum FeedPostAction { share, save, follow, mute, block, report }

/// The "⋮" menu for a post (Figma "feed_three_dot" / "post_three_dot"): a
/// rounded card of 74pt rows over a 60% scrim, with Cancel in its own card
/// below. [canSave] adds "Save" (feed only). Resolves to the picked action,
/// or null on Cancel / dismiss.
Future<FeedPostAction?> showFeedPostActions(
  BuildContext context, {
  required String authorName,
  required bool canSave,
}) {
  return showModalBottomSheet<FeedPostAction>(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: kFeedScrim,
    elevation: 0,
    builder: (context) => _ActionsSheet(
      authorName: authorName,
      canSave: canSave,
    ),
  );
}

class _ActionsSheet extends StatelessWidget {
  const _ActionsSheet({required this.authorName, required this.canSave});

  final String authorName;
  final bool canSave;

  @override
  Widget build(BuildContext context) {
    final items = [
      (FeedPostAction.share, Assets.icons.feedSheetShare, 'Share'),
      if (canSave) (FeedPostAction.save, Assets.icons.feedSheetSave, 'Save'),
      (
        FeedPostAction.follow,
        Assets.icons.feedSheetFollow,
        'Follow $authorName',
      ),
      (
        FeedPostAction.mute,
        Assets.icons.feedSheetMute,
        'Mute posts from $authorName',
      ),
      (FeedPostAction.block, Assets.icons.feedSheetBlock, 'Block $authorName'),
      (FeedPostAction.report, Assets.icons.feedSheetReport, 'Report'),
    ];
    final label = feedText(
      16,
      22,
      weight: FontWeight.w700,
      color: kFeedGrey900,
    );
    final radius = BorderRadius.circular(12.w);
    return Padding(
      padding: EdgeInsets.fromLTRB(
        20.w,
        0,
        20.w,
        16.w + MediaQuery.viewPaddingOf(context).bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Material(
            color: kFeedSheetBackground,
            borderRadius: radius,
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                for (final (action, icon, text) in items)
                  InkWell(
                    onTap: () => Navigator.of(context).pop(action),
                    child: SizedBox(
                      height: 74.w,
                      child: Row(
                        children: [
                          SizedBox(width: 20.w),
                          FeedIcon(icon, size: 24, color: kFeedGrey700),
                          SizedBox(width: 16.w),
                          Expanded(
                            child: Text(
                              text,
                              style: label,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(width: 20.w),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(height: 12.w),
          Material(
            color: kFeedSheetBackground,
            borderRadius: radius,
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: () => Navigator.of(context).pop(),
              child: SizedBox(
                height: 50.w,
                width: double.infinity,
                child: Center(child: Text('Cancel', style: label)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
