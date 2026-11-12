import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:find_a_nikah/features/messaging/domain/domain.dart';

/// Total unread messages across chats, for the Chat tab's badge. Kept live
/// by the messaging repository (socket pushes, plus a slow refresh).
class UnreadCountCubit extends Cubit<int> {
  UnreadCountCubit(this._repo) : super(0);

  final MessagingRepository _repo;
  StreamSubscription<int>? _sub;

  void start() {
    _sub ??= _repo.watchUnreadCount().listen(
      emit,
      // A badge that can't load stays at its last value.
      onError: (Object _) {},
    );
  }

  @override
  Future<void> close() async {
    await _sub?.cancel();
    return super.close();
  }
}
