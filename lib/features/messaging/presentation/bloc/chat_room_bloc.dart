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

enum ChatRoomStatus { loading, ready, failure }

class ChatRoomState extends Equatable {
  const ChatRoomState({
    required this.peer,
    this.status = ChatRoomStatus.loading,
    this.conversationId,
    this.messages = const <ChatMessage>[],
    this.peerTyping = false,
    this.replyingTo,
    this.failure,
  });

  final ChatPeer peer;
  final ChatRoomStatus status;
  final String? conversationId;

  /// Oldest first.
  final List<ChatMessage> messages;

  final bool peerTyping;

  /// Quoted by the next send.
  final ChatMessage? replyingTo;

  /// Set when a send fails; shown once by the page's listener.
  final Failure? failure;

  ChatRoomState copyWith({
    ChatPeer? peer,
    ChatRoomStatus? status,
    Object? conversationId = unchanged,
    List<ChatMessage>? messages,
    bool? peerTyping,
    Object? replyingTo = unchanged,
    Object? failure = unchanged,
  }) {
    return ChatRoomState(
      peer: peer ?? this.peer,
      status: status ?? this.status,
      conversationId: identical(conversationId, unchanged)
          ? this.conversationId
          : conversationId as String?,
      messages: messages ?? this.messages,
      peerTyping: peerTyping ?? this.peerTyping,
      replyingTo: identical(replyingTo, unchanged)
          ? this.replyingTo
          : replyingTo as ChatMessage?,
      failure: identical(failure, unchanged)
          ? this.failure
          : failure as Failure?,
    );
  }

  @override
  List<Object?> get props => [
    peer,
    status,
    conversationId,
    messages,
    peerTyping,
    replyingTo,
    failure,
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
    emit(state.copyWith(conversationId: id, peer: conversation.peer));
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
