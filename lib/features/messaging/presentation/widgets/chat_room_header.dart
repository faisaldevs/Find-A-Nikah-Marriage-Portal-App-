import 'package:find_a_nikah/core/ui/ui.dart';
import 'package:find_a_nikah/features/messaging/domain/domain.dart';
import 'package:find_a_nikah/features/messaging/presentation/widgets/messaging_style.dart';
import 'package:find_a_nikah/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

/// Back · avatar · name over presence · voice call · "⋮" more options, on
/// a grey hairline.
class ChatRoomHeader extends StatelessWidget {
  const ChatRoomHeader({
    required this.peer,
    required this.typing,
    required this.onBack,
    // required this.onVideoCall,
    this.onVoiceCall,
    required this.onMore,
    super.key,
  });

  final ChatPeer peer;
  final bool typing;
  final VoidCallback onBack;
  // final VoidCallback onVideoCall;
  /// Null hides the call button. CALLS-ON-HOLD (2026-11-12): the page passes
  /// null until the backend has a calling SDK + signalling.
  final VoidCallback? onVoiceCall;
  final VoidCallback onMore;

  @override
  Widget build(BuildContext context) {
    final (presence, presenceColor) = switch (peer) {
      _ when typing => ('typing…', AppColors.primaryColor),
      ChatPeer(isOnline: true) => ('Online', kMsgOnline),
      ChatPeer(:final lastSeenAt?) => (
        'Last seen ${TimeLabels.ago(lastSeenAt)}',
        kMsgGrey500,
      ),
      _ => ('Offline', kMsgGrey500),
    };
    return DecoratedBox(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: kMsgGrey200)),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(8.w, 6.w, 12.w, 12.w),
        child: Row(
          children: [
            _IconTap(
              tooltip: 'Back',
              onTap: onBack,
              child: AssetIcon(
                Assets.icons.feedBack,
                size: 24,
                color: kMsgIconDark,
              ),
            ),
            SizedBox(width: 4.w),
            AppAvatar(peer.photoUrl, size: 40),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    peer.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: figmaText(16, 22, weight: FontWeight.w700),
                  ),
                  Text(
                    presence,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: figmaText(13, 18, color: presenceColor),
                  ),
                ],
              ),
            ),
            // Video calls dropped from the room.
            // _IconTap(
            //   tooltip: 'Video call',
            //   onTap: onVideoCall,
            //   child: Icon(
            //     Icons.videocam_outlined,
            //     size: 26.r,
            //     color: kMsgIconDark,
            //   ),
            // ),
            // SizedBox(width: 4.w),
            if (onVoiceCall case final onCall?)
              _IconTap(
                tooltip: 'Voice call',
                onTap: onCall,
                child: Icon(
                  Icons.call_outlined,
                  size: 24.r,
                  color: kMsgIconDark,
                ),
              ),
            _IconTap(
              tooltip: 'More options',
              onTap: onMore,
              child: Icon(
                Icons.more_vert_rounded,
                size: 24.r,
                color: kMsgIconDark,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _IconTap extends StatelessWidget {
  const _IconTap({
    required this.tooltip,
    required this.onTap,
    required this.child,
  });

  final String tooltip;
  final VoidCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkResponse(
        onTap: onTap,
        radius: 22.r,
        child: SizedBox.square(
          dimension: 40.r,
          child: Center(child: child),
        ),
      ),
    );
  }
}
