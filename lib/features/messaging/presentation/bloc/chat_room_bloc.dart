import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:find_a_nikah/core/core.dart';
import 'package:find_a_nikah/features/messaging/domain/domain.dart';

sealed class ChatRoomEvent {
  const ChatRoomEvent();
}

/// Opens (or creates) the conversation and starts watching it.
final class ChatRoomStarted extends ChatRoomEvent {
  const ChatRoomStarted();
}

final class ChatRoomMessageSubmitted extends ChatRoomEvent {
  const ChatRoomMessageSubmitted(this.text);

  final String text;
}

/// A message was swiped to quote it in the next send.
final class ChatRoomReplySelected extends ChatRoomEvent {
  const ChatRoomReplySelected(this.message);

  final ChatMessage message;
}

final class ChatRoomReplyCleared extends ChatRoomEvent {
  const ChatRoomReplyCleared();
}

/// The thread was scrolled to its oldest loaded message.
final class ChatRoomOlderRequested extends ChatRoomEvent {
  const ChatRoomOlderRequested();
}

/// The user started / stopped typing in the composer.
final class ChatRoomTypingChanged extends ChatRoomEvent {
  const ChatRoomTypingChanged({required this.typing});

  final bool typing;
}

/// A picture was picked (already compressed) to send.
final class ChatRoomImageSelected extends ChatRoomEvent {
  const ChatRoomImageSelected(this.path);

  final String path;
}

/// Delete for me.
final class ChatRoomMessageDeleted extends ChatRoomEvent {
  const ChatRoomMessageDeleted(this.message);

  final ChatMessage message;
}

/// Resend a message that failed.
final class ChatRoomRetryRequested extends ChatRoomEvent {
  const ChatRoomRetryRequested(this.message);

  final ChatMessage message;
}

final class ChatRoomBlockRequested extends ChatRoomEvent {
  const ChatRoomBlockRequested();
}

final class ChatRoomUnmatchRequested extends ChatRoomEvent {
  const ChatRoomUnmatchRequested();
}

final class ChatRoomReportRequested extends ChatRoomEvent {
  const ChatRoomReportRequested(this.reason, {this.description});

  final String reason;
  final String? description;
}

final class ChatRoomMuteToggled extends ChatRoomEvent {
  const ChatRoomMuteToggled();
}

/// Clear chat: every message deleted for this user.
final class ChatRoomClearRequested extends ChatRoomEvent {
  const ChatRoomClearRequested();
}

final class ChatRoomArchiveRequested extends ChatRoomEvent {
  const ChatRoomArchiveRequested();
}

/// What a safety action ended with; the page shows it once (and leaves the
/// room for the ones that end the chat).
enum ChatRoomOutcome {
  blocked,
  unmatched,
  reported,
  archived,
  muted,
  unmuted,
  cleared,
}

enum ChatRoomStatus { loading, ready, failure }

class ChatRoomState extends Equatable {
  const ChatRoomState({
    required this.peer,
    this.status = ChatRoomStatus.loading,
    this.conversationId,
    this.messages = const <ChatMessage>[],
    this.peerTyping = false,
    this.isMuted = false,
    this.replyingTo,
    this.failure,
    this.outcome,
  });

  final ChatPeer peer;
  final ChatRoomStatus status;
  final String? conversationId;

  /// Oldest first.
  final List<ChatMessage> messages;

  final bool peerTyping;

  /// This user muted the chat.
  final bool isMuted;

  /// Quoted by the next send.
  final ChatMessage? replyingTo;

  /// Set when a send fails; shown once by the page's listener.
  final Failure? failure;

  /// Set when a block / unmatch / report / archive succeeded.
  final ChatRoomOutcome? outcome;

  ChatRoomState copyWith({
    ChatPeer? peer,
    ChatRoomStatus? status,
    Object? conversationId = unchanged,
    List<ChatMessage>? messages,
    bool? peerTyping,
    bool? isMuted,
    Object? replyingTo = unchanged,
    Object? failure = unchanged,
    Object? outcome = unchanged,
  }) {
    return ChatRoomState(
      peer: peer ?? this.peer,
      status: status ?? this.status,
      conversationId: identical(conversationId, unchanged)
          ? this.conversationId
          : conversationId as String?,
      messages: messages ?? this.messages,
      peerTyping: peerTyping ?? this.peerTyping,
      isMuted: isMuted ?? this.isMuted,
      replyingTo: identical(replyingTo, unchanged)
          ? this.replyingTo
          : replyingTo as ChatMessage?,
      failure: identical(failure, unchanged)
          ? this.failure
          : failure as Failure?,
      outcome: identical(outcome, unchanged)
          ? this.outcome
          : outcome as ChatRoomOutcome?,
    );
  }

  @override
  List<Object?> get props => [
    peer,
    status,
    conversationId,
    messages,
    peerTyping,
    isMuted,
    replyingTo,
    failure,
    outcome,
  ];
}

/// One conversation with [ChatRoomState.peer], scoped to the chat room page.
class ChatRoomBloc extends Bloc<ChatRoomEvent, ChatRoomState> {
  ChatRoomBloc(this._repo, ChatPeer peer) : super(ChatRoomState(peer: peer)) {
    on<ChatRoomStarted>(_onStarted, transformer: restartable());
    on<ChatRoomMessageSubmitted>(_onSubmitted, transformer: sequential());
    on<ChatRoomOlderRequested>(_onOlder, transformer: droppable());
    on<ChatRoomReplySelected>(
      (e, emit) => emit(state.copyWith(replyingTo: e.message)),
      transformer: sequential(),
    );
    on<ChatRoomReplyCleared>(
      (_, emit) => emit(state.copyWith(replyingTo: null)),
      transformer: sequential(),
    );
    on<ChatRoomTypingChanged>(
      (e, _) {
        final id = state.conversationId;
        if (id != null) _repo.setTyping(id, typing: e.typing);
      },
      transformer: sequential(),
    );
    on<ChatRoomImageSelected>(_onImage, transformer: sequential());
    on<ChatRoomMessageDeleted>(_onDeleted, transformer: sequential());
    on<ChatRoomRetryRequested>(_onRetry, transformer: sequential());
    on<ChatRoomBlockRequested>(_onBlock, transformer: droppable());
    on<ChatRoomUnmatchRequested>(_onUnmatch, transformer: droppable());
    on<ChatRoomReportRequested>(_onReport, transformer: droppable());
    on<ChatRoomArchiveRequested>(_onArchive, transformer: droppable());
    on<ChatRoomMuteToggled>(_onMute, transformer: droppable());
    on<ChatRoomClearRequested>(_onClear, transformer: droppable());
  }

  final MessagingRepository _repo;

  /// Newest incoming message already marked read — stops a markRead per
  /// stream emission.
  String? _readUpTo;

  Future<void> _onStarted(
    ChatRoomStarted event,
    Emitter<ChatRoomState> emit,
  ) async {
    final opened = await _repo.openConversation(state.peer.id);
    final conversation = opened.toNullable();
    if (conversation == null) {
      emit(
        state.copyWith(
          status: ChatRoomStatus.failure,
          failure: opened.getLeft().toNullable(),
        ),
      );
      return;
    }
    final id = conversation.id;
    emit(
      state.copyWith(
        conversationId: id,
        peer: conversation.peer,
        isMuted: conversation.isMuted,
      ),
    );
    // Join the socket room: from here on incoming messages count as seen.
    _repo.enterConversation(id);
    await Future.wait([
      emit.forEach<List<ChatMessage>>(
        _repo.watchMessages(id),
        onData: (messages) {
          _markReadIfNeeded(id, messages);
          return state.copyWith(
            status: ChatRoomStatus.ready,
            messages: messages,
          );
        },
        onError: (e, st) {
          addError(e, st);
          return state.copyWith(status: ChatRoomStatus.failure);
        },
      ),
      emit.forEach<bool>(
        _repo.watchPeerTyping(id),
        onData: (typing) => state.copyWith(peerTyping: typing),
      ),
      // Presence / last seen, and the match's profile, as they change.
      emit.forEach<ChatPeer>(
        _repo.watchPeer(id),
        onData: (peer) => state.copyWith(
          peer: peer.copyWith(
            matchId: peer.matchId ?? state.peer.matchId,
            profile: peer.profile ?? state.peer.profile,
          ),
        ),
        onError: (_, _) => state,
      ),
    ]);
  }

  Future<void> _onSubmitted(
    ChatRoomMessageSubmitted event,
    Emitter<ChatRoomState> emit,
  ) async {
    final text = event.text.trim();
    final id = state.conversationId;
    if (text.isEmpty || id == null) return;
    final quoted = state.replyingTo;
    emit(state.copyWith(replyingTo: null, failure: null));
    final sent = await _repo.sendMessage(
      conversationId: id,
      text: text,
      replyToMessageId: quoted?.id,
    );
    sent.match((f) => emit(state.copyWith(failure: f)), (_) {});
  }

  Future<void> _onImage(
    ChatRoomImageSelected event,
    Emitter<ChatRoomState> emit,
  ) async {
    final id = state.conversationId;
    if (id == null) return;
    final sent = await _repo.sendImage(conversationId: id, path: event.path);
    sent.match((f) => emit(state.copyWith(failure: f)), (_) {});
  }

  Future<void> _onDeleted(
    ChatRoomMessageDeleted event,
    Emitter<ChatRoomState> emit,
  ) async {
    final id = state.conversationId;
    if (id == null) return;
    final done = await _repo.deleteMessage(
      conversationId: id,
      messageId: event.message.id,
    );
    done.match((f) => emit(state.copyWith(failure: f)), (_) {});
  }

  /// A failed text goes out again as a new message; the failed bubble is
  /// dropped locally.
  Future<void> _onRetry(
    ChatRoomRetryRequested event,
    Emitter<ChatRoomState> emit,
  ) async {
    final id = state.conversationId;
    final m = event.message;
    if (id == null || m.status != MessageStatus.failed) return;
    await _repo.deleteMessage(conversationId: id, messageId: m.id);
    final imageUrl = m.imageUrl;
    final sent = imageUrl != null
        ? await _repo.sendImage(conversationId: id, path: imageUrl)
        : await _repo.sendMessage(conversationId: id, text: m.text);
    sent.match((f) => emit(state.copyWith(failure: f)), (_) {});
  }

  Future<void> _onBlock(
    ChatRoomBlockRequested event,
    Emitter<ChatRoomState> emit,
  ) async {
    final done = await _repo.blockUser(state.peer.id);
    done.match(
      (f) => emit(state.copyWith(failure: f)),
      (_) => emit(state.copyWith(outcome: ChatRoomOutcome.blocked)),
    );
  }

  Future<void> _onUnmatch(
    ChatRoomUnmatchRequested event,
    Emitter<ChatRoomState> emit,
  ) async {
    final matchId = state.peer.matchId;
    if (matchId == null) {
      emit(state.copyWith(failure: const NotFoundFailure()));
      return;
    }
    final done = await _repo.unmatch(matchId);
    done.match(
      (f) => emit(state.copyWith(failure: f)),
      (_) => emit(state.copyWith(outcome: ChatRoomOutcome.unmatched)),
    );
  }

  Future<void> _onReport(
    ChatRoomReportRequested event,
    Emitter<ChatRoomState> emit,
  ) async {
    final done = await _repo.reportUser(
      peerId: state.peer.id,
      reason: event.reason,
      description: event.description,
    );
    done.match(
      (f) => emit(state.copyWith(failure: f)),
      (_) => emit(state.copyWith(outcome: ChatRoomOutcome.reported)),
    );
  }

  Future<void> _onArchive(
    ChatRoomArchiveRequested event,
    Emitter<ChatRoomState> emit,
  ) async {
    final id = state.conversationId;
    if (id == null) return;
    final done = await _repo.setArchived(id, archived: true);
    done.match(
      (f) => emit(state.copyWith(failure: f)),
      (_) => emit(state.copyWith(outcome: ChatRoomOutcome.archived)),
    );
  }

  Future<void> _onMute(
    ChatRoomMuteToggled event,
    Emitter<ChatRoomState> emit,
  ) async {
    final id = state.conversationId;
    if (id == null) return;
    final to = !state.isMuted;
    emit(state.copyWith(outcome: null));
    final done = await _repo.setMuted(id, muted: to);
    done.match(
      (f) => emit(state.copyWith(failure: f)),
      (_) => emit(
        state.copyWith(
          isMuted: to,
          outcome: to ? ChatRoomOutcome.muted : ChatRoomOutcome.unmuted,
        ),
      ),
    );
  }

  Future<void> _onClear(
    ChatRoomClearRequested event,
    Emitter<ChatRoomState> emit,
  ) async {
    final id = state.conversationId;
    if (id == null) return;
    emit(state.copyWith(outcome: null));
    final done = await _repo.clearChat(id);
    done.match(
      (f) => emit(state.copyWith(failure: f)),
      (_) => emit(state.copyWith(outcome: ChatRoomOutcome.cleared)),
    );
  }

  @override
  Future<void> close() {
    final id = state.conversationId;
    if (id != null) _repo.leaveConversation(id);
    return super.close();
  }

  /// Older messages arrive through the messages stream.
  Future<void> _onOlder(
    ChatRoomOlderRequested event,
    Emitter<ChatRoomState> emit,
  ) async {
    final id = state.conversationId;
    if (id == null || _noMoreOlder) return;
    final more = await _repo.loadOlderMessages(id);
    more.match(
      (f) => emit(state.copyWith(failure: f)),
      (hasMore) => _noMoreOlder = !hasMore,
    );
  }

  var _noMoreOlder = false;

  /// The room is open, so anything that arrives is read.
  void _markReadIfNeeded(String id, List<ChatMessage> messages) {
    final latest = messages.lastWhereOrNull((m) => !m.isMine);
    if (latest == null || latest.id == _readUpTo) return;
    _readUpTo = latest.id;
    unawaited(_repo.markRead(id));
  }
}

extension<T> on List<T> {
  T? lastWhereOrNull(bool Function(T) test) {
    for (var i = length - 1; i >= 0; i--) {
      if (test(this[i])) return this[i];
    }
    return null;
  }
}
