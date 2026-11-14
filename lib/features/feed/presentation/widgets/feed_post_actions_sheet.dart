import 'package:find_a_nikah/features/feed/domain/domain.dart';
import 'package:find_a_nikah/features/feed/presentation/widgets/feed_icon.dart';
import 'package:find_a_nikah/features/feed/presentation/widgets/feed_style.dart';
import 'package:find_a_nikah/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:share_plus/share_plus.dart';

/// Public link to a post / member (opened in the app by id).
String feedPostLink(String postId) =>
    'https://findanikah.app/feed/post/$postId';

String feedMemberLink(String userId) => 'https://findanikah.app/feed/u/$userId';

void shareFeedLink(String url) =>
    SharePlus.instance.share(ShareParams(text: url));

enum FeedPostAction { share, edit, delete, mute, block, report }

/// One row of an actions sheet.
class FeedSheetItem<T> {
  const FeedSheetItem(this.value, this.label, {this.asset, this.icon});

  final T value;
  final String label;

  /// An SVG asset, or [icon] for anything the design set has no icon for.
  final String? asset;
  final IconData? icon;
}

/// The "⋮" menu (Figma "feed_three_dot" / "post_three_dot"): a rounded card
/// of 74pt rows over a 60% scrim, with Cancel in its own card below.
/// Resolves to the picked row's value, or null on Cancel / dismiss.
Future<T?> showFeedActionsSheet<T>(
  BuildContext context, {
  required List<FeedSheetItem<T>> items,
}) {
  return showModalBottomSheet<T>(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: kFeedScrim,
    elevation: 0,
    builder: (context) => _ActionsSheet<T>(items: items),
  );
}

/// Rows for a post: yours → Share · Edit (inside the edit window) · Delete;
/// someone else's → Share · Mute · Block · Report.
List<FeedSheetItem<FeedPostAction>> feedPostItems(
  FeedPost post, {
  DateTime? now,
}) {
  final author = post.author.name;
  final share = FeedSheetItem(
    FeedPostAction.share,
    'Share',
    asset: Assets.icons.feedSheetShare,
  );
  if (post.isMine) {
    return [
      share,
      if (post.canEditAt(now ?? DateTime.now()))
        const FeedSheetItem(
          FeedPostAction.edit,
          'Edit post',
          icon: Icons.edit_outlined,
        ),
      const FeedSheetItem(
        FeedPostAction.delete,
        'Delete post',
        icon: Icons.delete_outline,
      ),
    ];
  }
  return [
    share,
    FeedSheetItem(
      FeedPostAction.mute,
      'Mute posts from $author',
      asset: Assets.icons.feedSheetMute,
    ),
    FeedSheetItem(
      FeedPostAction.block,
      'Block $author',
      asset: Assets.icons.feedSheetBlock,
    ),
    FeedSheetItem(
      FeedPostAction.report,
      'Report',
      asset: Assets.icons.feedSheetReport,
    ),
  ];
}

class _ActionsSheet<T> extends StatelessWidget {
  const _ActionsSheet({required this.items});

  final List<FeedSheetItem<T>> items;

  @override
  Widget build(BuildContext context) {
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
                for (final item in items)
                  InkWell(
                    onTap: () => Navigator.of(context).pop(item.value),
                    child: SizedBox(
                      height: 74.w,
                      child: Row(
                        children: [
                          SizedBox(width: 20.w),
                          if (item.asset != null)
                            FeedIcon(item.asset!, size: 24, color: kFeedGrey700)
                          else
                            Icon(item.icon, size: 24.w, color: kFeedGrey700),
                          SizedBox(width: 16.w),
                          Expanded(
                            child: Text(
                              item.label,
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

/// Reasons for a report. Resolves to the reason or null.
Future<FeedReportReason?> showFeedReportReasons(BuildContext context) =>
    showFeedActionsSheet<FeedReportReason>(
      context,
      items: [
        for (final r in FeedReportReason.values)
          FeedSheetItem(r, r.label, icon: Icons.flag_outlined),
      ],
    );

/// "Are you sure?" for destructive actions. True when confirmed.
Future<bool> confirmFeedAction(
  BuildContext context, {
  required String title,
  required String message,
  required String confirmLabel,
}) async {
  final ok = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(
            confirmLabel,
            style: const TextStyle(color: kFeedTopicRed),
          ),
        ),
      ],
    ),
  );
  return ok ?? false;
}

/// What each action does — supplied by the page that owns the post.
class FeedPostHandlers {
  const FeedPostHandlers({
    this.onEdit,
    this.onDelete,
    this.onMute,
    this.onBlock,
    this.onReport,
  });

  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onMute;
  final VoidCallback? onBlock;
  final ValueChanged<FeedReportReason>? onReport;
}

/// Shows the menu for [post] and runs the picked action, asking first for
/// the destructive ones (delete, block) and for the reason when reporting.
Future<void> showFeedPostMenu(
  BuildContext context,
  FeedPost post,
  FeedPostHandlers handlers,
) async {
  final action = await showFeedActionsSheet<FeedPostAction>(
    context,
    items: feedPostItems(post),
  );
  if (action == null || !context.mounted) return;
  switch (action) {
    case FeedPostAction.share:
      shareFeedLink(feedPostLink(post.id));
    case FeedPostAction.edit:
      handlers.onEdit?.call();
    case FeedPostAction.delete:
      final ok = await confirmFeedAction(
        context,
        title: 'Delete this post?',
        message: 'This removes the post and its comments.',
        confirmLabel: 'Delete',
      );
      if (ok) handlers.onDelete?.call();
    case FeedPostAction.mute:
      handlers.onMute?.call();
    case FeedPostAction.block:
      final ok = await confirmFeedAction(
        context,
        title: 'Block ${post.author.name}?',
        message: 'You will no longer see each other on Feed, Marriage or Chat.',
        confirmLabel: 'Block',
      );
      if (ok) handlers.onBlock?.call();
    case FeedPostAction.report:
      final reason = await showFeedReportReasons(context);
      if (reason != null) handlers.onReport?.call(reason);
  }
}
