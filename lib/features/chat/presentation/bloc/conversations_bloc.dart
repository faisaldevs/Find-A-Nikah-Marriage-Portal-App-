import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:find_a_nikah/core/core.dart';
import 'package:find_a_nikah/features/messaging/domain/domain.dart';

sealed class ConversationsEvent {
  const ConversationsEvent();
}

final class ConversationsSubscribed extends ConversationsEvent {
  const ConversationsSubscribed();
}

/// The Matches panel opened: refetch now so a match made a moment ago shows.
final class ConversationsRefreshRequested extends ConversationsEvent {
  const ConversationsRefreshRequested();
}

/// A match was picked in the Matches panel: it takes the [slot] that
/// opened the panel.
final class ConversationStartRequested extends ConversationsEvent {
  const ConversationStartRequested(this.peer, {this.slot});

  final ChatPeer peer;
  final int? slot;
}

enum ConversationsStatus { loading, ready, failure }

class ConversationsState extends Equatable {
  const ConversationsState({
    this.status = ConversationsStatus.loading,
    this.conversations = const <Conversation>[],
    this.matches = const <ChatPeer>[],
    this.failure,
  });

  final ConversationsStatus status;

  /// Most recent first.
  final List<Conversation> conversations;

  /// Matches with no conversation yet — the Matches panel.
  final List<ChatPeer> matches;

  /// Set when starting a conversation fails; shown once by the listener.
  final Failure? failure;

  ConversationsState copyWith({
    ConversationsStatus? status,
    List<Conversation>? conversations,
    List<ChatPeer>? matches,
    Object? failure = unchanged,
  }) {
    return ConversationsState(
      status: status ?? this.status,
      conversations: conversations ?? this.conversations,
      matches: matches ?? this.matches,
      failure: identical(failure, unchanged)
          ? this.failure
          : failure as Failure?,
    );
  }

  @override
  List<Object?> get props => [
    status,
    conversations,
    matches,
    failure,
  ];
}

/// The Chat tab's Marriage list and Matches panel, kept live from the
/// messaging repository (a send in the room re-sorts the list here).
class ConversationsBloc extends Bloc<ConversationsEvent, ConversationsState> {
  ConversationsBloc(this._repo) : super(const ConversationsState()) {
    on<ConversationsSubscribed>(_onSubscribed, transformer: restartable());
    on<ConversationStartRequested>(
      _onStartRequested,
      transformer: droppable(),
    );
    on<ConversationsRefreshRequested>(
      (_, _) => _repo.refresh(),
      transformer: droppable(),
    );
  }

  final MessagingRepository _repo;

  Future<void> _onSubscribed(
    ConversationsSubscribed event,
    Emitter<ConversationsState> emit,
  ) async {
    await Future.wait([
      emit.forEach<List<Conversation>>(
        _repo.watchConversations(),
        onData: (c) => state.copyWith(
          status: ConversationsStatus.ready,
          conversations: c,
        ),
        onError: (e, st) {
          addError(e, st);
          return state.copyWith(status: ConversationsStatus.failure);
        },
      ),
      emit.forEach<List<ChatPeer>>(
        _repo.watchMatches(),
        onData: (m) => state.copyWith(matches: m),
        onError: (e, st) {
          addError(e, st);
          return state;
        },
      ),
    ]);
  }

  /// The new row arrives through [MessagingRepository.watchConversations].
  Future<void> _onStartRequested(
    ConversationStartRequested event,
    Emitter<ConversationsState> emit,
  ) async {
    if (state.failure != null) emit(state.copyWith(failure: null));
    final started = await _repo.openConversation(
      event.peer.id,
      slot: event.slot,
    );
    started.match((f) => emit(state.copyWith(failure: f)), (_) {});
  }
}
