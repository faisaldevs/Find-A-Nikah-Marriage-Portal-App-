import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:find_a_nikah/core/core.dart';
import 'package:find_a_nikah/features/messaging/domain/domain.dart';

enum ArchivedChatsStatus { loading, ready, failure }

class ArchivedChatsState extends Equatable {
  const ArchivedChatsState({
    this.status = ArchivedChatsStatus.loading,
    this.chats = const <Conversation>[],
    this.failure,
  });

  final ArchivedChatsStatus status;
  final List<Conversation> chats;

  /// Set when a restore fails; shown once.
  final Failure? failure;

  ArchivedChatsState copyWith({
    ArchivedChatsStatus? status,
    List<Conversation>? chats,
    Object? failure = unchanged,
  }) => ArchivedChatsState(
    status: status ?? this.status,
    chats: chats ?? this.chats,
    failure: identical(failure, unchanged) ? this.failure : failure as Failure?,
  );

  @override
  List<Object?> get props => [status, chats, failure];
}

/// The archived-chats page: what the user archived, and putting it back.
class ArchivedChatsCubit extends Cubit<ArchivedChatsState> {
  ArchivedChatsCubit(this._repo) : super(const ArchivedChatsState());

  final MessagingRepository _repo;

  Future<void> load() async {
    emit(state.copyWith(status: ArchivedChatsStatus.loading, failure: null));
    final res = await _repo.fetchArchived();
    res.match(
      (f) => emit(
        state.copyWith(status: ArchivedChatsStatus.failure, failure: f),
      ),
      (chats) => emit(
        state.copyWith(status: ArchivedChatsStatus.ready, chats: chats),
      ),
    );
  }

  Future<void> restore(Conversation chat) async {
    final res = await _repo.setArchived(chat.id, archived: false);
    res.match(
      (f) => emit(state.copyWith(failure: f)),
      (_) => emit(
        state.copyWith(
          chats: [
            for (final c in state.chats)
              if (c.id != chat.id) c,
          ],
          failure: null,
        ),
      ),
    );
  }
}
