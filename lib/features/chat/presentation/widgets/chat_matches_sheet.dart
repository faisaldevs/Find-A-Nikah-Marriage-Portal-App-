import 'package:find_a_nikah/core/ui/ui.dart';
import 'package:find_a_nikah/features/chat/presentation/widgets/chat_header.dart';
import 'package:find_a_nikah/features/chat/presentation/widgets/chat_style.dart';
import 'package:find_a_nikah/features/messaging/domain/domain.dart';
import 'package:find_a_nikah/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

/// "Matches (0)" panel (Figma "chat_matches expanded"): docked above the
/// bottom nav as a "Matches (n) · Show" bar ([peekHeight] tall), it rises
/// over the tab content when [expanded], 20pt corners and a grab handle.
/// Lists
/// the matches nobody has messaged yet; tapping one starts the
/// conversation. With none, it shows the "go like profiles" prompt.
class ChatMatchesSheet extends StatelessWidget {
  const ChatMatchesSheet({
    required this.matches,
    required this.expanded,
    required this.onMatchTap,
    required this.onShow,
    required this.onHide,
    required this.onGoToMarriage,
    super.key,
  });

  final List<ChatPeer> matches;
  final bool expanded;
  final ValueChanged<ChatPeer> onMatchTap;
  final VoidCallback onShow;
  final VoidCallback onHide;
  final VoidCallback onGoToMarriage;

  /// Handle + "Matches (n)" row + hairline: what shows while docked.
  static double get peekHeight => 8.w + 4.w + 9.5.w + 22.w + 16.w + 1;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Swipe down on the sheet to hide it, like the handle suggests.
      // onVerticalDragEnd: (d) {
      //   if ((d.primaryVelocity ?? 0) > 200) onHide();
      // },
      // Swipe up to show, down to hide, like the handle suggests.
      onVerticalDragEnd: (d) {
        final v = d.primaryVelocity ?? 0;
        if (v > 200) onHide();
        if (v < -200) onShow();
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.w)),
          // Lifts the docked bar off the list scrolling under it.
          boxShadow: const [
            BoxShadow(
              color: Color(0x1A000000),
              blurRadius: 12,
              offset: Offset(0, -2),
            ),
          ],
        ),
        // Docked: clipped to the bar, nothing to scroll.
        clipBehavior: Clip.antiAlias,
        child: SingleChildScrollView(
          physics: expanded
              ? const ClampingScrollPhysics()
              : const NeverScrollableScrollPhysics(),
          child: Column(
            children: [
              // Docked, the whole bar opens the panel.
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: expanded ? null : onShow,
                child: Column(
                  children: [
                    SizedBox(height: 8.w),
                    Container(
                      width: 66.w,
                      height: 4.w,
                      decoration: BoxDecoration(
                        color: kChatGrey300,
                        borderRadius: BorderRadius.circular(2.w),
                      ),
                    ),
                    SizedBox(height: 9.5.w),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Row(
                        children: [
                          Text(
                            'Matches (${matches.length})',
                            style: figmaText(16, 22, weight: FontWeight.w700),
                          ),
                          const Spacer(),
                          GestureDetector(
                            // onTap: onHide,
                            onTap: expanded ? onHide : onShow,
                            behavior: HitTestBehavior.opaque,
                            child: Row(
                              children: [
                                Text(
                                  // 'Hide',
                                  expanded ? 'Hide' : 'Show',
                                  style: figmaText(13, 20, color: kChatGrey500),
                                ),
                                SizedBox(width: 2.w),
                                // Chevron points down to hide, up to show.
                                RotatedBox(
                                  quarterTurns: expanded ? 0 : 2,
                                  child: AssetIcon(
                                    Assets.icons.chatChevronDown,
                                    size: 16,
                                    color: kChatGrey500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.w),
                  ],
                ),
              ),
              // Hairline under the bar while docked (Muzz).
              if (!expanded)
                Container(
                  height: 1,
                  margin: EdgeInsets.symmetric(horizontal: 20.w),
                  color: kChatGrey200,
                )
              else
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Text(
                    'Matches will move to your active conversations when '
                    'you’ve both sent a message to each other.',
                    style: figmaText(14, 20),
                  ),
                ),
              if (matches.isEmpty) ...[
                SizedBox(height: 122.5.w),
                // Figma centres it 3pt left of the screen centre.
                Transform.translate(
                  offset: Offset(-3.w, 0),
                  child: Image.asset(
                    Assets.images.chatMatchesIllustration,
                    width: 136.5.w,
                    height: 134.w,
                  ),
                ),
                SizedBox(height: 36.2.w),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 60.w),
                  child: Text(
                    'No matches yet, like new profiles in the marriage tab',
                    textAlign: TextAlign.center,
                    style: figmaText(20, 30, weight: FontWeight.w700),
                  ),
                ),
                SizedBox(height: 23.8.w),
                ChatPinkButton(
                  label: 'Go to Marriage',
                  height: 44,
                  width: 190,
                  onTap: onGoToMarriage,
                ),
                SizedBox(height: 32.w),
              ] else ...[
                SizedBox(height: 12.w),
                for (final peer in matches)
                  _MatchRow(peer: peer, onTap: () => onMatchTap(peer)),
                SizedBox(height: 24.w),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Avatar · name over the "say salaam" prompt.
class _MatchRow extends StatelessWidget {
  const _MatchRow({required this.peer, required this.onTap});

  final ChatPeer peer;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.w),
        child: Row(
          children: [
            AppAvatar(peer.photoUrl, size: 56, online: peer.isOnline),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    peer.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: figmaText(16, 22, weight: FontWeight.w700),
                  ),
                  SizedBox(height: 2.w),
                  Text(
                    'Say salaam to start the conversation',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: figmaText(14, 20, color: kChatGrey500),
                  ),
                ],
              ),
            ),
            AssetIcon(
              Assets.icons.chatChevronRight,
              size: 16,
              color: kChatGrey400,
            ),
          ],
        ),
      ),
    );
  }
}
