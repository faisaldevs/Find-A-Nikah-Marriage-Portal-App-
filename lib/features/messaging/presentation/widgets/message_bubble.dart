import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:find_a_nikah/core/ui/ui.dart';
import 'package:find_a_nikah/features/messaging/domain/domain.dart';
import 'package:find_a_nikah/features/messaging/presentation/widgets/messaging_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

/// One message: grey on the left (theirs) or pink on the right (mine),
/// with the quoted message on top when it's a reply. Swipe right to reply.
class MessageBubble extends StatelessWidget {
  const MessageBubble({
    required this.message,
    required this.peerName,
    required this.onReply,
    this.onLongPress,
    this.onRetry,
    super.key,
  });

  final ChatMessage message;

  /// Opens the message menu (delete for me).
  final VoidCallback? onLongPress;

  /// Taps a failed message to send it again.
  final VoidCallback? onRetry;

  /// Labels quotes of the peer's messages.
  final String peerName;
  final VoidCallback onReply;

  @override
  Widget build(BuildContext context) {
    final mine = message.isMine;
    final reply = message.replyTo;
    final textColor = mine ? Colors.white : const Color(0xFF0A0A0A);
    return _SwipeToReply(
      onReply: onReply,
      child: Align(
        alignment: mine ? Alignment.centerRight : Alignment.centerLeft,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.sizeOf(context).width * 0.75,
          ),
          child: GestureDetector(
            onLongPress: onLongPress,
            onTap: message.status == MessageStatus.failed ? onRetry : null,
            child: Container(
              padding: message.isImage
                  ? EdgeInsets.all(4.w)
                  : EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.w),
              decoration: BoxDecoration(
                color: mine ? AppColors.primaryColor : kMsgGrey100,
                borderRadius: BorderRadius.circular(16.w),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (reply != null) ...[
                    ReplyQuote(
                      author: reply.isMine ? 'You' : peerName,
                      text: reply.text,
                      onPink: mine,
                    ),
                    SizedBox(height: 8.w),
                  ],
                  if (message.isImage)
                    _MessageImage(url: message.imageUrl!)
                  else
                    Text(
                      message.text,
                      style: figmaText(15, 22, color: textColor),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// A sent / received picture; a local file while it is still uploading.
class _MessageImage extends StatelessWidget {
  const _MessageImage({required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    final size = 220.w;
    final remote = url.startsWith('http');
    return ClipRRect(
      borderRadius: BorderRadius.circular(12.w),
      child: SizedBox(
        width: size,
        height: size,
        child: remote
            ? CachedNetworkImage(
                imageUrl: url,
                fit: BoxFit.cover,
                placeholder: (_, _) => const ColoredBox(color: kMsgGrey200),
                errorWidget: (_, _, _) => const ColoredBox(
                  color: kMsgGrey200,
                  child: Icon(Icons.broken_image_outlined),
                ),
              )
            : Image.file(File(url), fit: BoxFit.cover),
      ),
    );
  }
}

/// Author over one line of quoted text, behind a 2pt bar — inside a reply
/// bubble and above the composer while replying.
class ReplyQuote extends StatelessWidget {
  const ReplyQuote({
    required this.author,
    required this.text,
    this.onPink = false,
    super.key,
  });

  final String author;
  final String text;

  /// Drawn inside a pink (own) bubble: white bar and text.
  final bool onPink;

  @override
  Widget build(BuildContext context) {
    final bar = onPink ? Colors.white : AppColors.primaryColor;
    final body = onPink ? Colors.white.withValues(alpha: 0.85) : kMsgGrey500;
    return IntrinsicHeight(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 2.w, color: bar),
          SizedBox(width: 8.w),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  author,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: figmaText(
                    12,
                    16,
                    weight: FontWeight.w700,
                    color: onPink ? Colors.white : AppColors.primaryColor,
                  ),
                ),
                Text(
                  text,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: figmaText(12, 16, color: body),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// `Sending…` · `Sent` · `Delivered` · `Seen` under the newest own message.
class MessageStatusLabel extends StatelessWidget {
  const MessageStatusLabel(this.status, {super.key});

  final MessageStatus status;

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (status) {
      MessageStatus.sending => ('Sending…', kMsgGrey400),
      MessageStatus.sent => ('Sent', kMsgGrey500),
      MessageStatus.delivered => ('Delivered', kMsgGrey500),
      MessageStatus.seen => ('Seen', AppColors.primaryColor),
      MessageStatus.failed => ('Not sent', AppColors.errorColor),
    };
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: EdgeInsets.only(top: 4.w, right: 2.w),
        child: Text(label, style: figmaText(12, 16, color: color)),
      ),
    );
  }
}

/// Drags the bubble right (up to `_max`); past `_trigger` it fires
/// [onReply] once, with a tick of haptics, and springs back on release.
class _SwipeToReply extends StatefulWidget {
  const _SwipeToReply({required this.onReply, required this.child});

  final VoidCallback onReply;
  final Widget child;

  @override
  State<_SwipeToReply> createState() => _SwipeToReplyState();
}

class _SwipeToReplyState extends State<_SwipeToReply> {
  static const _max = 72.0;
  static const _trigger = 52.0;

  double _dx = 0;
  bool _fired = false;

  void _onUpdate(DragUpdateDetails d) {
    setState(() => _dx = (_dx + d.delta.dx).clamp(0, _max));
    if (!_fired && _dx >= _trigger) {
      _fired = true;
      HapticFeedback.selectionClick().ignore();
    }
  }

  void _onEnd([DragEndDetails? _]) {
    if (_fired) widget.onReply();
    setState(() {
      _dx = 0;
      _fired = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: _onUpdate,
      onHorizontalDragEnd: _onEnd,
      onHorizontalDragCancel: _onEnd,
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          Opacity(
            opacity: (_dx / _trigger).clamp(0, 1),
            child: Icon(Icons.reply_rounded, size: 22.r, color: kMsgGrey500),
          ),
          AnimatedContainer(
            duration: _dx == 0
                ? const Duration(milliseconds: 180)
                : Duration.zero,
            curve: Curves.easeOut,
            transform: Matrix4.translationValues(_dx, 0, 0),
            child: widget.child,
          ),
        ],
      ),
    );
  }
}
