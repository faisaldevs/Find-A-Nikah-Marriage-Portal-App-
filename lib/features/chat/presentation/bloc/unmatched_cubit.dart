import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:find_a_nikah/features/messaging/domain/domain.dart';

class UnmatchedState extends Equatable {
  const UnmatchedState({this.people = const <ChatPeer>[]});

  final List<ChatPeer> people;

  @override
  List<Object?> get props => [people];
}

/// The Unmatched page: people whose match ended. A failed load just leaves
/// the page on its empty state.
class UnmatchedCubit extends Cubit<UnmatchedState> {
  UnmatchedCubit(this._repo) : super(const UnmatchedState());

  final MessagingRepository _repo;

  Future<void> load() async {
    final res = await _repo.fetchUnmatched();
    res.match((_) {}, (people) => emit(UnmatchedState(people: people)));
  }
}
