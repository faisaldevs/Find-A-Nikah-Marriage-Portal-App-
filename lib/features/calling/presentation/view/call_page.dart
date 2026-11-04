import 'dart:async';

import 'package:find_a_nikah/app/di.dart';
import 'package:find_a_nikah/core/ui/ui.dart';
import 'package:find_a_nikah/features/calling/domain/domain.dart';
import 'package:find_a_nikah/features/calling/presentation/bloc/call_bloc.dart';
import 'package:find_a_nikah/features/calling/presentation/widgets/call_views.dart';
import 'package:find_a_nikah/features/messaging/domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// A voice call with [peer], over everything. Opened from the chat room's
/// call button, or (dev) its "Simulate incoming call" item with
/// [incoming] set. The peer travels as the route's `extra`.
class CallPage extends StatelessWidget {
  const CallPage({required this.peer, this.incoming = false, super.key});

  final ChatPeer peer;
  final bool incoming;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          getIt<CallBloc>(param1: peer, param2: incoming)
            ..add(const CallStarted()),
      child: const _CallView(),
    );
  }
}

class _CallView extends StatefulWidget {
  const _CallView();

  @override
  State<_CallView> createState() => _CallViewState();
}

class _CallViewState extends State<_CallView> {
  /// "Call ended" stays up this long before the page closes.
  static const _endedHold = Duration(seconds: 2);

  Timer? _close;

  @override
  void dispose() {
    _close?.cancel();
    super.dispose();
  }

  void _leave() {
    if (mounted && context.canPop()) context.pop();
  }

  /// Back (arrow or system) ends the call — there's no minimised call bar
  /// yet to keep it running behind other screens.
  void _endFromBack(CallState state) {
    final bloc = context.read<CallBloc>();
    final session = state.session;
    if (session == null || state.status == CallStatus.failure) {
      _leave();
    } else if (session.phase == CallPhase.ringing && !session.isOutgoing) {
      bloc.add(const CallDeclined());
    } else {
      bloc.add(const CallHungUp());
    }
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<CallBloc>();
    return MultiBlocListener(
      listeners: [
        BlocListener<CallBloc, CallState>(
          listenWhen: (a, b) => b.failure != null && a.failure != b.failure,
          listener: (context, state) =>
              showFailureToast(context, state.failure!),
        ),
        BlocListener<CallBloc, CallState>(
          listenWhen: (a, b) =>
              !(a.session?.isEnded ?? false) && (b.session?.isEnded ?? false),
          listener: (_, _) => _close ??= Timer(_endedHold, _leave),
        ),
      ],
      child: BlocBuilder<CallBloc, CallState>(
        builder: (context, state) {
          final session = state.session;
          final ended = session?.isEnded ?? false;
          return PopScope(
            canPop: ended || state.status == CallStatus.failure,
            onPopInvokedWithResult: (didPop, _) {
              if (!didPop) _endFromBack(state);
            },
            child: Scaffold(
              backgroundColor: const Color(0xFF061128),
              body: switch (state) {
                CallState(status: CallStatus.failure, session: null) =>
                  AppErrorView(
                    title: 'Couldn’t start the call',
                    message: state.failure?.message,
                    retryLabel: 'Close',
                    onRetry: _leave,
                  ),
                CallState(session: final s?) when s.isEnded => EndedCallView(
                  peer: state.peer,
                  session: s,
                ),
                CallState(incoming: true, :final session)
                    when session == null ||
                        session.phase == CallPhase.ringing =>
                  IncomingCallView(
                    peer: state.peer,
                    ready: session != null,
                    onBack: () => _endFromBack(state),
                    onDecline: () => bloc.add(const CallDeclined()),
                    onAccept: () => bloc.add(const CallAccepted()),
                    onQuickReply: (text) => bloc.add(CallQuickReplySent(text)),
                  ),
                _ => ActiveCallView(
                  peer: state.peer,
                  session: session,
                  onBack: () => _endFromBack(state),
                  onProfile: () => CustomToast.showInfo(
                    context,
                    'Profile — coming soon',
                  ),
                  onMute: () => bloc.add(const CallMuteToggled()),
                  onSpeaker: () => bloc.add(const CallSpeakerToggled()),
                  onHangUp: () => bloc.add(const CallHungUp()),
                ),
              },
            ),
          );
        },
      ),
    );
  }
}
