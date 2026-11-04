import 'package:find_a_nikah/core/ui/ui.dart';
import 'package:find_a_nikah/features/chat/presentation/widgets/chat_style.dart';
import 'package:find_a_nikah/features/messaging/domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

/// One Chat-tab row: avatar · name over the last message (ticks first when
/// it's the user's own) · time over the unread badge.
class ConversationTile extends StatelessWidget {
  const ConversationTile({
    required this.conversation,
    required this.onTap,
    super.key,
  });

  final Conversation conversation;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final peer = conversation.peer;
    final last = conversation.lastMessage;
    final unread = conversation.hasUnread;
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
                  Row(
                    children: [
                      // if (last != null && last.isMine) ...[
                      if (last != null && last.isMine && !last.isCall) ...[
                        MessageTicks(last.status),
                        SizedBox(width: 4.w),
                      ],
                      if (last?.callLog case final call?) ...[
                        Icon(
                          _callIcon(call),
                          size: 16.r,
                          color: _isMissed(call)
                              ? AppColors.errorColor
                              : kChatGrey500,
                        ),
                        SizedBox(width: 4.w),
                      ],
                      Expanded(
                        child: Text(
                          // last?.text ?? '',
                          // Started from a match, nothing sent yet.
                          // last?.text ??
                          //     'Say salaam to start the conversation',
                          switch (last) {
                            null => 'Say salaam to start the conversation',
                            ChatMessage(:final callLog?) => _callText(callLog),
                            ChatMessage(:final text) => text,
                          },
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: figmaText(
                            14,
                            20,
                            weight: unread ? FontWeight.w500 : FontWeight.w400,
                            color: unread
                                ? const Color(0xFF0A0A0A)
                                : kChatGrey500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(width: 12.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (last != null)
                  Text(
                    TimeLabels.short(last.sentAt),
                    style: figmaText(
                      12,
                      16,
                      color: unread ? AppColors.primaryColor : kChatGrey500,
                    ),
                  ),
                SizedBox(height: 6.w),
                if (unread)
                  _UnreadBadge(conversation.unreadCount)
                else
                  SizedBox(height: 20.w),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// ✓ sent · ✓✓ delivered (grey) · ✓✓ seen (pink) · clock while sending.
class MessageTicks extends StatelessWidget {
  const MessageTicks(this.status, {super.key});

  final MessageStatus status;

  @override
  Widget build(BuildContext context) {
    final (icon, color) = switch (status) {
      MessageStatus.sending => (Icons.schedule_rounded, kChatGrey400),
      MessageStatus.sent => (Icons.done_rounded, kChatGrey400),
      MessageStatus.delivered => (Icons.done_all_rounded, kChatGrey400),
      MessageStatus.seen => (Icons.done_all_rounded, AppColors.primaryColor),
      MessageStatus.failed => (
        Icons.error_outline_rounded,
        AppColors.errorColor,
      ),
    };
    return Icon(icon, size: 16.r, color: color);
  }
}

class _UnreadBadge extends StatelessWidget {
  const _UnreadBadge(this.count);

  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minWidth: 20.w),
      height: 20.w,
      padding: EdgeInsets.symmetric(horizontal: 6.w),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(10.w),
      ),
      child: Text(
        count > 99 ? '99+' : '$count',
        style: figmaText(
          11,
          14,
          weight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    );
  }
}

bool _isMissed(CallLog c) =>
    !c.outgoing &&
    (c.outcome == CallOutcome.missed || c.outcome == CallOutcome.declined);

IconData _callIcon(CallLog c) => switch (c.outcome) {
  CallOutcome.completed =>
    c.outgoing ? Icons.call_made_rounded : Icons.call_received_rounded,
  CallOutcome.missed || CallOutcome.declined => Icons.call_missed_rounded,
  CallOutcome.cancelled => Icons.call_made_rounded,
};

/// Same wording as the room's call line.
String _callText(CallLog c) => switch (c.outcome) {
  CallOutcome.completed => 'Voice call · ${TimeLabels.duration(c.duration)}',
  CallOutcome.missed => 'Missed voice call',
  CallOutcome.declined => 'Declined voice call',
  CallOutcome.cancelled =>
    c.outgoing ? 'Cancelled voice call' : 'Missed voice call',
};
