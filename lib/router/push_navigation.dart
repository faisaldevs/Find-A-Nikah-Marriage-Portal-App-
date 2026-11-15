import 'package:find_a_nikah/core/core.dart';
import 'package:find_a_nikah/features/messaging/domain/entities/chat_peer.dart';
import 'package:find_a_nikah/router/route_paths.dart';
import 'package:go_router/go_router.dart';

/// Opens the screen a tapped notification is about. Unknown types just leave
/// the app where it is.
void openPush(GoRouter router, PushPayload p) {
  switch (p.type) {
    case 'message' when p.senderId != null:
      router
          .push<void>(
            RoutePaths.chatRoom,
            extra: ChatPeer(
              id: p.senderId!,
              name: p.senderName ?? p.title ?? '',
              photoUrl: p.senderPhoto ?? '',
            ),
          )
          .ignore();
    case 'match':
      router.go(RoutePaths.chat);
    case 'compliment' || 'like':
      router.go(RoutePaths.explore);
    case _ when p.postId != null:
      router.push<void>(RoutePaths.feedPostPath(p.postId!)).ignore();
    case _ when p.userId != null:
      router.push<void>(RoutePaths.feedProfilePath(p.userId!)).ignore();
  }
}
