import 'package:find_a_nikah/core/ui/ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

enum ChatRoomAction {
  viewProfile,
  mute,
  clearChat,
  archive,
  unmatch,
  block,
  report,

  /// Dev flavor only.
  simulateIncomingCall,
}

// Same sheet look as the feed's post "⋮" menu.
const _sheetBackground = Color(0xFFFAFAFA);
const _scrim = Color(0x99000000);
const _grey700 = Color(0xFF404040);
const _grey900 = Color(0xFF171717);

/// The chat room's "⋮" menu: a rounded card of rows over a scrim, with
/// Cancel in its own card below. Unmatch / Block / Report are drawn in
/// red. Resolves to the picked action, or null on Cancel / dismiss.
Future<ChatRoomAction?> showChatRoomActions(
  BuildContext context, {
  required String peerName,
  bool devTools = false,
}) {
  return showModalBottomSheet<ChatRoomAction>(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: _scrim,
    elevation: 0,
    builder: (context) => _ActionsSheet(peerName: peerName, devTools: devTools),
  );
}

class _ActionsSheet extends StatelessWidget {
  const _ActionsSheet({required this.peerName, required this.devTools});

  final String peerName;
  final bool devTools;

  @override
  Widget build(BuildContext context) {
    final items = [
      (
        ChatRoomAction.viewProfile,
        Icons.person_outline_rounded,
        'View profile',
      ),
      (
        ChatRoomAction.mute,
        Icons.notifications_off_outlined,
        'Mute notifications',
      ),
      (
        ChatRoomAction.clearChat,
        Icons.cleaning_services_outlined,
        'Clear chat',
      ),
      (ChatRoomAction.archive, Icons.archive_outlined, 'Archive chat'),
      (ChatRoomAction.unmatch, Icons.heart_broken_outlined, 'Unmatch'),
      (ChatRoomAction.block, Icons.block_rounded, 'Block $peerName'),
      (ChatRoomAction.report, Icons.flag_outlined, 'Report'),
      if (devTools)
        (
          ChatRoomAction.simulateIncomingCall,
          Icons.phone_callback_outlined,
          'Simulate incoming call (dev)',
        ),
    ];
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
            color: _sheetBackground,
            borderRadius: radius,
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                for (final (action, icon, text) in items)
                  _Row(
                    icon: icon,
                    text: text,
                    destructive: _isDestructive(action),
                    onTap: () => Navigator.of(context).pop(action),
                  ),
              ],
            ),
          ),
          SizedBox(height: 12.w),
          Material(
            color: _sheetBackground,
            borderRadius: radius,
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: () => Navigator.of(context).pop(),
              child: SizedBox(
                height: 50.w,
                width: double.infinity,
                child: Center(
                  child: Text(
                    'Cancel',
                    style: figmaText(
                      16,
                      22,
                      weight: FontWeight.w700,
                      color: _grey900,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static bool _isDestructive(ChatRoomAction a) => switch (a) {
    ChatRoomAction.unmatch ||
    ChatRoomAction.block ||
    ChatRoomAction.report => true,
    ChatRoomAction.simulateIncomingCall ||
    ChatRoomAction.viewProfile ||
    ChatRoomAction.mute ||
    ChatRoomAction.archive ||
    ChatRoomAction.clearChat => false,
  };
}

class _Row extends StatelessWidget {
  const _Row({
    required this.icon,
    required this.text,
    required this.destructive,
    required this.onTap,
  });

  final IconData icon;
  final String text;
  final bool destructive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = destructive ? AppColors.errorColor : _grey900;
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        height: 60.w,
        child: Row(
          children: [
            SizedBox(width: 20.w),
            Icon(
              icon,
              size: 24.r,
              color: destructive ? AppColors.errorColor : _grey700,
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Text(
                text,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: figmaText(16, 22, weight: FontWeight.w700, color: color),
              ),
            ),
            SizedBox(width: 20.w),
          ],
        ),
      ),
    );
  }
}
