import 'package:find_a_nikah/app/di.dart';
import 'package:find_a_nikah/core/media/image_compressor.dart';
import 'package:find_a_nikah/core/ui/ui.dart';
import 'package:find_a_nikah/features/messaging/domain/domain.dart';
import 'package:find_a_nikah/features/messaging/presentation/bloc/chat_room_bloc.dart';
import 'package:find_a_nikah/features/messaging/presentation/widgets/call_log_line.dart';
import 'package:find_a_nikah/features/messaging/presentation/widgets/chat_room_actions_sheet.dart';
import 'package:find_a_nikah/features/messaging/presentation/widgets/chat_room_header.dart';
import 'package:find_a_nikah/features/messaging/presentation/widgets/message_bubble.dart';
import 'package:find_a_nikah/features/messaging/presentation/widgets/message_composer.dart';
import 'package:find_a_nikah/features/messaging/presentation/widgets/messaging_style.dart';
import 'package:find_a_nikah/features/messaging/presentation/widgets/typing_bubble.dart';
import 'package:find_a_nikah/router/route_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';

enum _MessageAction { copy, delete }

/// One-to-one chat with a match, pushed over the tabs. Opened from a
/// Chat-tab row or a match pick; the peer travels as the route's `extra`.
class ChatRoomPage extends StatelessWidget {
  const ChatRoomPage({required this.peer, this.devTools = false, super.key});

  final ChatPeer peer;

  /// Dev flavor: adds "Simulate incoming call" to the ⋮ menu.
  final bool devTools;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          getIt<ChatRoomBloc>(param1: peer)..add(const ChatRoomStarted()),
      child: _ChatRoomView(devTools: devTools),
    );
  }
}

class _ChatRoomView extends StatelessWidget {
  const _ChatRoomView({required this.devTools});

  final bool devTools;

  void _comingSoon(BuildContext context, String what) =>
      CustomToast.showInfo(context, '$what — coming soon');

  /// Drops the composer's focus first — otherwise the keyboard pops back
  /// up when the call screen closes.
  void _openCall(BuildContext context, String route, ChatPeer peer) {
    // Unfocus the field itself: unfocusing the page's scope keeps the
    // field as its remembered child, which refocuses on return.
    FocusManager.instance.primaryFocus?.unfocus();
    context.push<void>(route, extra: peer).ignore();
  }

  /// Mute and Clear chat have no backend yet; the rest are live.
  Future<void> _onMore(BuildContext context, ChatPeer peer) async {
    // Before the sheet: closing it hands focus back to whatever had it.
    // Unfocus the field itself: unfocusing the page's scope keeps the
    // field as its remembered child, which refocuses on return.
    FocusManager.instance.primaryFocus?.unfocus();
    final bloc = context.read<ChatRoomBloc>();
    final action = await showChatRoomActions(
      context,
      peerName: peer.name,
      muted: bloc.state.isMuted,
      // CALLS-ON-HOLD: "Simulate incoming call (dev)" hidden too. Restore
      // `devTools: devTools` to bring it back.
      // devTools: devTools,
    );
    if (action == null || !context.mounted) return;
    switch (action) {
      case ChatRoomAction.simulateIncomingCall:
        _openCall(context, RoutePaths.incomingCall, peer);
      case ChatRoomAction.archive:
        bloc.add(const ChatRoomArchiveRequested());
      case ChatRoomAction.block:
        if (await _confirm(
          context,
          title: 'Block ${peer.name}?',
          message:
              'They won’t be able to message you, and this chat '
              'will be removed.',
          action: 'Block',
        )) {
          bloc.add(const ChatRoomBlockRequested());
        }
      case ChatRoomAction.unmatch:
        if (await _confirm(
          context,
          title: 'Unmatch ${peer.name}?',
          message: 'The chat will close for both of you.',
          action: 'Unmatch',
        )) {
          bloc.add(const ChatRoomUnmatchRequested());
        }
      case ChatRoomAction.report:
        final reason = await _pickReportReason(context);
        if (reason != null) bloc.add(ChatRoomReportRequested(reason));
      case ChatRoomAction.viewProfile:
        // The peer in the bloc carries the profile once the match data
        // has loaded.
        context
            .push<void>(RoutePaths.peerProfile, extra: bloc.state.peer)
            .ignore();
      case ChatRoomAction.mute:
        bloc.add(const ChatRoomMuteToggled());
      case ChatRoomAction.clearChat:
        if (await _confirm(
          context,
          title: 'Clear this chat?',
          message:
              'Messages are removed for you only. ${peer.name} keeps '
              'their copy.',
          action: 'Clear',
        )) {
          bloc.add(const ChatRoomClearRequested());
        }
    }
  }

  Future<bool> _confirm(
    BuildContext context, {
    required String title,
    required String message,
    required String action,
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
              action,
              style: const TextStyle(color: AppColors.errorColor),
            ),
          ),
        ],
      ),
    );
    return ok ?? false;
  }

  static const _reportReasons = <(String, String)>[
    ('harassment', 'Harassment or abuse'),
    ('inappropriate_content', 'Inappropriate content'),
    ('fake_profile', 'Fake profile'),
    ('spam', 'Spam or scam'),
    ('other', 'Something else'),
  ];

  Future<String?> _pickReportReason(BuildContext context) {
    return showModalBottomSheet<String>(
      context: context,
      useRootNavigator: true,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Text(
                'Report this member',
                style: figmaText(16, 22, weight: FontWeight.w700),
              ),
            ),
            for (final (code, label) in _reportReasons)
              ListTile(
                title: Text(label),
                onTap: () => Navigator.of(context).pop(code),
              ),
          ],
        ),
      ),
    );
  }

  /// "+" in the composer: a picture from the gallery or the camera.
  Future<void> _onAttach(BuildContext context) async {
    FocusManager.instance.primaryFocus?.unfocus();
    final bloc = context.read<ChatRoomBloc>();
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      useRootNavigator: true,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Photo library'),
              onTap: () => Navigator.of(context).pop(ImageSource.gallery),
            ),
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined),
              title: const Text('Camera'),
              onTap: () => Navigator.of(context).pop(ImageSource.camera),
            ),
          ],
        ),
      ),
    );
    if (source == null) return;
    try {
      final picked = await getIt<ImagePicker>().pickImage(source: source);
      if (picked == null) return;
      // Same shrink-and-strip-EXIF as profile photos.
      final path = await getIt<ImageCompressor>().compress(
        picked.path,
        outputName: 'chat_${DateTime.now().millisecondsSinceEpoch}.jpg',
      );
      bloc.add(ChatRoomImageSelected(path));
    } on Object {
      if (context.mounted) {
        CustomToast.showInfo(context, 'Couldn’t attach that photo.');
      }
    }
  }

  /// Long-press on a message: copy (text only) or delete for me.
  static Future<void> _onMessageMenu(
    BuildContext context,
    ChatMessage m,
  ) async {
    final bloc = context.read<ChatRoomBloc>();
    final action = await showModalBottomSheet<_MessageAction>(
      context: context,
      useRootNavigator: true,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (m.text.trim().isNotEmpty)
              ListTile(
                leading: const Icon(Icons.copy_rounded),
                title: const Text('Copy'),
                onTap: () => Navigator.of(context).pop(_MessageAction.copy),
              ),
            ListTile(
              leading: const Icon(
                Icons.delete_outline_rounded,
                color: AppColors.errorColor,
              ),
              title: const Text('Delete for me'),
              onTap: () => Navigator.of(context).pop(_MessageAction.delete),
            ),
          ],
        ),
      ),
    );
    switch (action) {
      case _MessageAction.copy:
        await Clipboard.setData(ClipboardData(text: m.text));
      case _MessageAction.delete:
        bloc.add(ChatRoomMessageDeleted(m));
      case null:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<ChatRoomBloc>();
    return MultiBlocListener(
      listeners: [
        BlocListener<ChatRoomBloc, ChatRoomState>(
          listenWhen: (a, b) => b.failure != null && a.failure != b.failure,
          listener: (context, state) =>
              showFailureToast(context, state.failure!),
        ),
        BlocListener<ChatRoomBloc, ChatRoomState>(
          listenWhen: (a, b) => b.outcome != null && a.outcome != b.outcome,
          listener: (context, state) {
            final done = state.outcome!;
            CustomToast.showInfo(context, switch (done) {
              ChatRoomOutcome.blocked => 'Blocked',
              ChatRoomOutcome.unmatched => 'Unmatched',
              ChatRoomOutcome.reported => 'Thanks — we’ll review this report',
              ChatRoomOutcome.archived => 'Chat archived',
              ChatRoomOutcome.muted => 'Notifications muted',
              ChatRoomOutcome.unmuted => 'Notifications on',
              ChatRoomOutcome.cleared => 'Chat cleared',
            });
            // Blocking, unmatching and archiving end the chat.
            // Blocking, unmatching and archiving end the chat.
            if (done == ChatRoomOutcome.blocked ||
                done == ChatRoomOutcome.unmatched ||
                done == ChatRoomOutcome.archived) {
              context.pop();
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              BlocBuilder<ChatRoomBloc, ChatRoomState>(
                buildWhen: (a, b) =>
                    a.peer != b.peer ||
                    a.peerTyping != b.peerTyping ||
                    a.isMuted != b.isMuted,
                builder: (context, state) => ChatRoomHeader(
                  peer: state.peer,
                  muted: state.isMuted,
                  typing: state.peerTyping,
                  onBack: () => context.pop(),
                  // onVideoCall: () => _comingSoon(context, 'Video calls'),
                  // onVoiceCall: () => _comingSoon(context, 'Voice calls'),
                  // onVoiceCall: () => context
                  //     .push<void>(RoutePaths.call, extra: state.peer)
                  //     .ignore(),
                  // CALLS-ON-HOLD (2026-11-12): call button hidden. To bring
                  // calls back, restore the line below.
                  // onVoiceCall: () =>
                  //     _openCall(context, RoutePaths.call, state.peer),
                  onMore: () => _onMore(context, state.peer),
                ),
              ),
              const Expanded(child: _Thread()),
              BlocBuilder<ChatRoomBloc, ChatRoomState>(
                buildWhen: (a, b) =>
                    a.replyingTo != b.replyingTo || a.peer.name != b.peer.name,
                builder: (context, state) {
                  final reply = state.replyingTo;
                  return MessageComposer(
                    replyAuthor: reply == null
                        ? null
                        : reply.isMine
                        ? 'yourself'
                        : state.peer.name,
                    replyText: reply?.text,
                    onSend: (text) => bloc.add(ChatRoomMessageSubmitted(text)),
                    onCancelReply: () => bloc.add(const ChatRoomReplyCleared()),
                    onTypingChanged: (typing) =>
                        bloc.add(ChatRoomTypingChanged(typing: typing)),
                    onAttach: () => _onAttach(context),
                    onVoice: () => _comingSoon(context, 'Voice messages'),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Thread extends StatelessWidget {
  const _Thread();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatRoomBloc, ChatRoomState>(
      buildWhen: (a, b) =>
          a.status != b.status ||
          a.messages != b.messages ||
          a.peerTyping != b.peerTyping ||
          a.peer != b.peer,
      builder: (context, state) {
        switch (state.status) {
          case ChatRoomStatus.loading:
            return const AppLoadingView();
          case ChatRoomStatus.failure when state.messages.isEmpty:
            return AppErrorView(
              title: 'Couldn’t open this chat',
              message: state.failure?.message,
              retryLabel: 'Try again',
              onRetry: () =>
                  context.read<ChatRoomBloc>().add(const ChatRoomStarted()),
            );
          case ChatRoomStatus.failure:
          case ChatRoomStatus.ready:
            if (state.messages.isEmpty && !state.peerTyping) {
              return _EmptyThread(peer: state.peer);
            }
            final items = _threadItems(state);
            return NotificationListener<ScrollNotification>(
              // Reversed list: the top of the thread is the max extent.
              onNotification: (n) {
                if (n.metrics.extentAfter < 300) {
                  context.read<ChatRoomBloc>().add(
                    const ChatRoomOlderRequested(),
                  );
                }
                return false;
              },
              child: ListView.builder(
                // Newest at the bottom, and the list opens there.
                reverse: true,
                padding: EdgeInsets.fromLTRB(16.w, 8.w, 16.w, 16.w),
                itemCount: items.length,
                itemBuilder: (context, i) =>
                    _buildItem(context, state, items[items.length - 1 - i]),
              ),
            );
        }
      },
    );
  }

  Widget _buildItem(BuildContext context, ChatRoomState state, _Item item) {
    return switch (item) {
      _DayItem(:final day) => Padding(
        padding: EdgeInsets.symmetric(vertical: 12.w),
        child: Center(
          child: Text(
            TimeLabels.day(day),
            style: figmaText(13, 18, color: kMsgGrey500),
          ),
        ),
      ),
      _MessageItem(:final message, :final gap) => Padding(
        padding: EdgeInsets.only(top: gap.w),
        child: MessageBubble(
          message: message,
          peerName: state.peer.name,
          onReply: () => context.read<ChatRoomBloc>().add(
            ChatRoomReplySelected(message),
          ),
          onLongPress: () => _ChatRoomView._onMessageMenu(context, message),
          onRetry: () => context.read<ChatRoomBloc>().add(
            ChatRoomRetryRequested(message),
          ),
        ),
      ),
      _CallItem(:final message) => Padding(
        padding: EdgeInsets.symmetric(vertical: 8.w),
        child: CallLogLine(message.callLog!, at: message.sentAt),
      ),
      _StatusItem(:final status) => MessageStatusLabel(status),
      _TypingItem() => Padding(
        padding: EdgeInsets.only(top: 16.w),
        child: const TypingBubble(),
      ),
    };
  }

  /// Oldest first: a divider per day, 4pt between one sender's run and
  /// 12pt when the sender changes, the status under the newest own
  /// message, and the typing bubble last.
  static List<_Item> _threadItems(ChatRoomState state) {
    final messages = state.messages;
    // final lastMine = messages.lastIndexWhere((m) => m.isMine);
    // Call records carry no delivery status.
    final lastMine = messages.lastIndexWhere((m) => m.isMine && !m.isCall);
    final items = <_Item>[];
    DateTime? day;
    for (var i = 0; i < messages.length; i++) {
      final m = messages[i];
      final d = DateUtils.dateOnly(m.sentAt);
      final newDay = d != day;
      if (newDay) {
        items.add(_DayItem(d));
        day = d;
      }
      if (m.isCall) {
        items.add(_CallItem(m));
        continue;
      }
      final sameSender =
          i > 0 &&
          !messages[i - 1].isCall &&
          messages[i - 1].isMine == m.isMine;
      items.add(_MessageItem(m, gap: newDay ? 0 : (sameSender ? 4 : 12)));
      // if (i == lastMine) items.add(_StatusItem(m.status));
      // A failed message keeps its "Not sent" row even once a newer one
      // exists, so it never looks delivered (tap the bubble to retry).
      if (i == lastMine || (m.isMine && m.status == MessageStatus.failed)) {
        items.add(_StatusItem(m.status));
      }
    }
    if (state.peerTyping) items.add(const _TypingItem());
    return items;
  }
}

sealed class _Item {
  const _Item();
}

final class _DayItem extends _Item {
  const _DayItem(this.day);
  final DateTime day;
}

final class _MessageItem extends _Item {
  const _MessageItem(this.message, {required this.gap});
  final ChatMessage message;
  final double gap;
}

final class _CallItem extends _Item {
  const _CallItem(this.message);
  final ChatMessage message;
}

final class _StatusItem extends _Item {
  const _StatusItem(this.status);
  final MessageStatus status;
}

final class _TypingItem extends _Item {
  const _TypingItem();
}

class _EmptyThread extends StatelessWidget {
  const _EmptyThread({required this.peer});

  final ChatPeer peer;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(32.w, 96.w, 32.w, 24.w),
      child: Column(
        children: [
          AppAvatar(peer.photoUrl, size: 88),
          SizedBox(height: 16.w),
          Text(
            'You matched with ${peer.name}',
            textAlign: TextAlign.center,
            style: figmaText(18, 24, weight: FontWeight.w700),
          ),
          SizedBox(height: 8.w),
          Text(
            'Say salaam to start the conversation.',
            textAlign: TextAlign.center,
            style: figmaText(14, 20, color: kMsgGrey500),
          ),
        ],
      ),
    );
  }
}
