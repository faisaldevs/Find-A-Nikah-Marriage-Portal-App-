import 'dart:math' as math;

import 'package:find_a_nikah/core/ui/ui.dart';
import 'package:find_a_nikah/features/chat/presentation/widgets/chat_gold_sheet.dart';
import 'package:find_a_nikah/features/chat/presentation/widgets/chat_header.dart';
import 'package:find_a_nikah/features/chat/presentation/widgets/chat_matches_sheet.dart';
import 'package:find_a_nikah/features/chat/presentation/widgets/chat_style.dart';
import 'package:find_a_nikah/gen/assets.gen.dart';
import 'package:find_a_nikah/router/route_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:go_router/go_router.dart';

enum _ChatTab { marriage, friends }

/// Free plan's active-conversation slots (Figma "Active conversations
/// (0/5)").
const _slotCount = 5;

/// Fourth bottom-nav tab, "Your Chats" (Figma "chat_marriage" /
/// "chat_friends empty state"). No chat backend yet, so both tabs show
/// their empty states.
class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  _ChatTab _tab = _ChatTab.marriage;
  bool _matchesOpen = false;

  void _goToTab(int branch) {
    setState(() => _matchesOpen = false);
    StatefulNavigationShell.of(context).goBranch(branch);
  }

  @override
  Widget build(BuildContext context) {
    final marriage = _tab == _ChatTab.marriage;
    return PopScope(
      canPop: !_matchesOpen,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) setState(() => _matchesOpen = false);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            SafeArea(
              bottom: false,
              child: Column(
                children: [
                  ChatHeader(
                    title: 'Your Chats',
                    action: marriage
                        ? ChatCircleButton(
                            icon: Assets.icons.chatUnmatched,
                            tooltip: 'Unmatched',
                            onTap: () => context
                                .push<void>(RoutePaths.chatUnmatched)
                                .ignore(),
                          )
                        : ChatCircleButton(
                            icon: Assets.icons.chatArchive,
                            tooltip: 'Archived chats',
                            onTap: () => context
                                .push<void>(RoutePaths.chatArchived)
                                .ignore(),
                          ),
                  ),
                  SizedBox(height: 26.5.w),
                  _Tabs(
                    selected: _tab,
                    onChanged: (t) => setState(() {
                      _tab = t;
                      _matchesOpen = false;
                    }),
                  ),
                  Expanded(
                    child: marriage
                        ? _MarriageTab(
                            onSlotTap: () =>
                                setState(() => _matchesOpen = true),
                            onMoreSlots: () =>
                                showChatGoldSheet(context).then((plan) {
                                  if (plan != null && context.mounted) {
                                    CustomToast.showInfo(
                                      context,
                                      'Gold ${plan.title} — coming soon',
                                    );
                                  }
                                }),
                          )
                        : _FriendsTab(onGoToFeed: () => _goToTab(2)),
                  ),
                ],
              ),
            ),
            // Matches panel: dims the header, covers the tab content,
            // stops at the bottom nav.
            Positioned.fill(
              child: IgnorePointer(
                ignoring: !_matchesOpen,
                child: AnimatedOpacity(
                  opacity: _matchesOpen ? 1 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: GestureDetector(
                    onTap: () => setState(() => _matchesOpen = false),
                    child: const ColoredBox(color: kChatScrim),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              top: MediaQuery.paddingOf(context).top + _tabsBottom,
              child: IgnorePointer(
                ignoring: !_matchesOpen,
                child: AnimatedSlide(
                  offset: _matchesOpen ? Offset.zero : const Offset(0, 1),
                  duration: const Duration(milliseconds: 260),
                  curve: Curves.easeOutCubic,
                  child: ChatMatchesSheet(
                    onHide: () => setState(() => _matchesOpen = false),
                    onGoToMarriage: () => _goToTab(0),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Where the tab bar ends — the matches panel's top edge (Figma 174).
  double get _tabsBottom => 5.4.h + 38.w + 26.5.w + _Tabs.height;
}

/// Marriage · Friends as two halves: Bold 18 labels, a 1pt pink underline
/// on the active half over a full-width 1pt grey hairline.
class _Tabs extends StatelessWidget {
  const _Tabs({required this.selected, required this.onChanged});

  final _ChatTab selected;
  final ValueChanged<_ChatTab> onChanged;

  static double get height => 24.w + 13.5.w + 2.w;

  @override
  Widget build(BuildContext context) {
    Widget tab(_ChatTab t, String label) {
      final active = t == selected;
      return Expanded(
        child: GestureDetector(
          onTap: () => onChanged(t),
          behavior: HitTestBehavior.opaque,
          child: Column(
            children: [
              Text(
                label,
                style: figmaText(
                  18,
                  24,
                  weight: FontWeight.w700,
                  color: active ? AppColors.primaryColor : kChatGrey500,
                ),
              ),
              SizedBox(height: 13.5.w),
              Container(
                height: 1.w,
                color: active ? AppColors.primaryColor : Colors.transparent,
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        Row(
          children: [
            tab(_ChatTab.marriage, 'Marriage'),
            tab(_ChatTab.friends, 'Friends'),
          ],
        ),
        Container(height: 1.w, color: kChatGrey200),
      ],
    );
  }
}

class _MarriageTab extends StatelessWidget {
  const _MarriageTab({required this.onSlotTap, required this.onMoreSlots});

  final VoidCallback onSlotTap;
  final VoidCallback onMoreSlots;

  @override
  Widget build(BuildContext context) {
    // return SingleChildScrollView(
    // padding: EdgeInsets.only(top: 12.5.w, bottom: 24.w),
    // child: Column(
    // crossAxisAlignment: CrossAxisAlignment.start,
    // children: [
    // Padding(
    // padding: EdgeInsets.symmetric(horizontal: 20.w),
    // child: Column(
    // crossAxisAlignment: CrossAxisAlignment.start,
    // children: [
    // Text(
    // 'Active conversations (0/$_slotCount)',
    // style: figmaText(16, 22, weight: FontWeight.w700),
    // ),
    // SizedBox(height: 8.4.w),
    // Text(
    // 'Your matches are added to your conversations when '
    // 'you’ve both sent each other a message. You can only '
    // 'talk to $_slotCount people at a time.',
    // style: figmaText(14, 20, color: kChatGrey500),
    // ),
    // ],
    // ),
    // ),
    // SizedBox(height: 21.6.w),
    // for (var i = 0; i < _slotCount; i++) ...[
    // if (i > 0) SizedBox(height: 30.w),
    // _EmptySlot(onTap: onSlotTap),
    // ],
    // SizedBox(height: 25.w),
    // _MoreSlotsBanner(onTap: onMoreSlots),
    // ],
    // ),
    // );
    // The banner sits under the slots in Figma (390×844); on shorter
    // phones it fell below the fold behind the nav (audit #64), so it's
    // pinned and the slots scroll above it.
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.only(top: 12.5.w, bottom: 25.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Active conversations (0/$_slotCount)',
                        style: figmaText(16, 22, weight: FontWeight.w700),
                      ),
                      SizedBox(height: 8.4.w),
                      Text(
                        'Your matches are added to your conversations when '
                        'you’ve both sent each other a message. You can only '
                        'talk to $_slotCount people at a time.',
                        style: figmaText(14, 20, color: kChatGrey500),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 21.6.w),
                for (var i = 0; i < _slotCount; i++) ...[
                  if (i > 0) SizedBox(height: 30.w),
                  _EmptySlot(onTap: onSlotTap),
                ],
              ],
            ),
          ),
        ),
        _MoreSlotsBanner(onTap: onMoreSlots),
      ],
    );
  }
}

class _EmptySlot extends StatelessWidget {
  const _EmptySlot({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Row(
          children: [
            SizedBox(
              width: 56.w,
              height: 56.w,
              child: CustomPaint(
                painter: _DashedCirclePainter(),
                child: Center(
                  child: AssetIcon(
                    Assets.icons.chatPlus,
                    size: 24,
                    color: kChatGrey400,
                  ),
                ),
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Text(
                'Select a match to start a conversation',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: figmaText(14, 20, color: kChatGrey400),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 1pt `#D4D4D4` circle in ~5pt dashes (Figma's empty slot).
class _DashedCirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = kChatGrey300
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.w;
    final r = size.width / 2 - 0.5.w;
    final rect = Rect.fromCircle(center: size.center(Offset.zero), radius: r);
    const dashes = 16;
    const sweep = 2 * math.pi / dashes;
    for (var i = 0; i < dashes; i++) {
      canvas.drawArc(rect, i * sweep, sweep * 0.45, false, paint);
    }
  }

  @override
  bool shouldRepaint(_DashedCirclePainter old) => false;
}

class _MoreSlotsBanner extends StatelessWidget {
  const _MoreSlotsBanner({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 64.w,
        color: kChatPinkTint,
        padding: EdgeInsets.only(left: 38.w),
        child: Row(
          children: [
            AssetIcon(
              Assets.icons.chatCrown,
              size: 24,
              color: AppColors.primaryColor,
            ),
            SizedBox(width: 27.25.w),
            Text(
              'Want more chat slots?',
              style: figmaText(
                15,
                20,
                weight: FontWeight.w500,
                color: AppColors.primaryColor,
              ),
            ),
            SizedBox(width: 31.6.w),
            AssetIcon(
              Assets.icons.chatChevronRight,
              size: 16,
              color: AppColors.primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}

class _FriendsTab extends StatelessWidget {
  const _FriendsTab({required this.onGoToFeed});

  final VoidCallback onGoToFeed;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(20.w, 203.w, 20.w, 24.w),
      child: Column(
        children: [
          Transform.translate(
            offset: Offset(-2.w, 0),
            child: Image.asset(
              Assets.images.chatFriendsIllustration,
              width: 144.w,
              height: 115.w,
            ),
          ),
          SizedBox(height: 46.2.w),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Text(
              'This is where you can chat with friends from Feed',
              textAlign: TextAlign.center,
              style: figmaText(20, 26, weight: FontWeight.w700),
            ),
          ),
          SizedBox(height: 15.4.w),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Text(
              'All incoming chat requests will be shown here.',
              textAlign: TextAlign.center,
              style: figmaText(16, 22, color: kChatGrey500),
            ),
          ),
          SizedBox(height: 24.4.w),
          ChatPinkButton(
            label: 'Go to my feed',
            height: 48,
            onTap: onGoToFeed,
          ),
        ],
      ),
    );
  }
}
