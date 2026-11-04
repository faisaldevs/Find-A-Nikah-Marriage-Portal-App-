import 'dart:async';
import 'dart:ui' show ImageFilter;

import 'package:find_a_nikah/core/ui/ui.dart';
import 'package:find_a_nikah/features/calling/domain/domain.dart';
import 'package:find_a_nikah/features/calling/presentation/widgets/call_style.dart';
import 'package:find_a_nikah/features/messaging/domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

/// Canned replies offered while an incoming call rings.
const kCallQuickReplies = [
  'Can’t talk now, what’s up?',
  'I’ll call you back in a bit',
  'In a meeting, text me?',
  'Can’t pick up, is it urgent?',
  'I’m busy right now, I’ll reply soon.',
];

/// Dialing, ringing (outgoing) and connected: avatar, name and status
/// centred; mute · speaker · end along the bottom.
class ActiveCallView extends StatelessWidget {
  const ActiveCallView({
    required this.peer,
    required this.session,
    required this.onBack,
    required this.onProfile,
    required this.onMute,
    required this.onSpeaker,
    required this.onHangUp,
    super.key,
  });

  final ChatPeer peer;

  /// Null while the call is still being placed.
  final CallSession? session;
  final VoidCallback onBack;
  final VoidCallback onProfile;
  final VoidCallback onMute;
  final VoidCallback onSpeaker;
  final VoidCallback onHangUp;

  @override
  Widget build(BuildContext context) {
    final s = session;
    final connected = s?.phase == CallPhase.connected;
    return DecoratedBox(
      decoration: const BoxDecoration(gradient: kCallGradient),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.w, 8.w, 20.w, 24.w),
          child: Column(
            children: [
              Row(
                children: [
                  CallRoundButton(
                    icon: Icons.arrow_back_rounded,
                    tooltip: 'End call',
                    size: 36,
                    onTap: onBack,
                  ),
                  const Spacer(),
                  CallRoundButton(
                    icon: Icons.person_rounded,
                    tooltip: 'View profile',
                    size: 36,
                    onTap: onProfile,
                  ),
                ],
              ),
              const Spacer(),
              AppAvatar(peer.photoUrl, size: 112),
              SizedBox(height: 16.w),
              _Name(peer.name),
              SizedBox(height: 6.w),
              if (connected)
                _CallTimer(s!.connectedAt!)
              else
                Text(
                  s?.phase == CallPhase.ringing ? 'Ringing…' : 'Calling…',
                  style: _subtitle,
                ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CallRoundButton(
                    icon: s?.muted ?? false
                        ? Icons.mic_off_rounded
                        : Icons.mic_none_rounded,
                    tooltip: 'Mute',
                    active: s?.muted ?? false,
                    onTap: s == null ? null : onMute,
                  ),
                  SizedBox(width: 24.w),
                  CallRoundButton(
                    icon: Icons.volume_up_rounded,
                    tooltip: 'Speaker',
                    active: s?.speakerOn ?? false,
                    onTap: s == null ? null : onSpeaker,
                  ),
                  SizedBox(width: 24.w),
                  CallRoundButton(
                    icon: Icons.call_end_rounded,
                    tooltip: 'End call',
                    background: kCallRed,
                    onTap: onHangUp,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// "Calling from" + name on top, big avatar, Decline / Accept, and the
/// quick-message link that opens canned replies over the buttons.
class IncomingCallView extends StatefulWidget {
  const IncomingCallView({
    required this.peer,
    required this.ready,
    required this.onBack,
    required this.onDecline,
    required this.onAccept,
    required this.onQuickReply,
    super.key,
  });

  final ChatPeer peer;

  /// The call is ringing (buttons live).
  final bool ready;
  final VoidCallback onBack;
  final VoidCallback onDecline;
  final VoidCallback onAccept;
  final ValueChanged<String> onQuickReply;

  @override
  State<IncomingCallView> createState() => _IncomingCallViewState();
}

class _IncomingCallViewState extends State<IncomingCallView> {
  bool _repliesOpen = false;

  @override
  Widget build(BuildContext context) {
    final ready = widget.ready;
    return DecoratedBox(
      decoration: const BoxDecoration(gradient: kCallGradient),
      child: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 8.w, 20.w, 16.w),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: CallRoundButton(
                      icon: Icons.arrow_back_rounded,
                      tooltip: 'Decline',
                      size: 36,
                      onTap: widget.onBack,
                    ),
                  ),
                  SizedBox(height: 8.w),
                  Text('Calling from', style: _subtitle),
                  SizedBox(height: 6.w),
                  _Name(widget.peer.name, size: 24),
                  const Spacer(),
                  DecoratedBox(
                    // Painted over the photo — behind it, the clip hid the
                    // ring.
                    position: DecorationPosition.foreground,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2.w),
                    ),
                    child: AppAvatar(widget.peer.photoUrl, size: 168),
                  ),
                  const Spacer(),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CallRoundButton(
                          icon: Icons.call_end_rounded,
                          tooltip: 'Decline',
                          label: 'Decline',
                          background: kCallRed,
                          size: 60,
                          onTap: ready ? widget.onDecline : null,
                        ),
                        CallRoundButton(
                          icon: Icons.call_rounded,
                          tooltip: 'Accept',
                          label: 'Accept',
                          background: kCallGreen,
                          size: 60,
                          onTap: ready ? widget.onAccept : null,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 28.w),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: ready
                        ? () => setState(() => _repliesOpen = !_repliesOpen)
                        : null,
                    // A single 13pt line was too small a target.
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 10.w,
                      ),
                      child: Text.rich(
                        TextSpan(
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: kCallWhite70,
                          ),
                          children: const [
                            TextSpan(text: 'Can’t talk now? Send a '),
                            TextSpan(
                              text: 'quick message.',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                decoration: TextDecoration.underline,
                                decorationColor: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (_repliesOpen) ...[
              Positioned.fill(
                child: GestureDetector(
                  onTap: () => setState(() => _repliesOpen = false),
                  behavior: HitTestBehavior.opaque,
                ),
              ),
              Positioned(
                left: 48.w,
                right: 48.w,
                bottom: 52.w,
                child: _QuickReplies(
                  onPick: (text) {
                    setState(() => _repliesOpen = false);
                    widget.onQuickReply(text);
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Frosted card of canned replies, one per row.
class _QuickReplies extends StatelessWidget {
  const _QuickReplies({required this.onPick});

  final ValueChanged<String> onPick;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16.w),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Material(
          color: const Color(0x3D8FA3C8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var i = 0; i < kCallQuickReplies.length; i++) ...[
                if (i > 0)
                  const Divider(
                    height: 1,
                    thickness: 1,
                    color: Colors.white12,
                  ),
                InkWell(
                  onTap: () => onPick(kCallQuickReplies[i]),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 18.w,
                      vertical: 13.w,
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      child: Text(
                        kCallQuickReplies[i],
                        style: TextStyle(fontSize: 14.sp, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Avatar and name at the top, "Call ended" (with the talk time) in the
/// middle, on charcoal. Shown briefly before the page closes.
class EndedCallView extends StatelessWidget {
  const EndedCallView({required this.peer, required this.session, super.key});

  final ChatPeer peer;
  final CallSession session;

  @override
  Widget build(BuildContext context) {
    final talk = session.talkTime();
    final detail = switch (session.outcome) {
      CallOutcome.completed => TimeLabels.duration(talk),
      CallOutcome.missed => 'Missed',
      CallOutcome.declined => 'Declined',
      CallOutcome.cancelled => 'Cancelled',
      null => null,
    };
    // return DecoratedBox(
    // The column alone sizes to its content, so the charcoal only covered
    // a strip on the left — fill the screen.
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(gradient: kCallEndedGradient),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            children: [
              SizedBox(height: 24.w),
              AppAvatar(peer.photoUrl, size: 72),
              SizedBox(height: 12.w),
              _Name(peer.name, size: 16),
              SizedBox(height: 4.w),
              Text(
                'Voice call',
                style: _subtitle.copyWith(color: kCallWhite70),
              ),
              const Spacer(),
              Text(
                'Call ended',
                style: TextStyle(fontSize: 14.sp, color: kCallWhite70),
              ),
              if (detail != null) ...[
                SizedBox(height: 4.w),
                Text(
                  detail,
                  style: TextStyle(fontSize: 13.sp, color: Colors.white38),
                ),
              ],
              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }
}

TextStyle get _subtitle => TextStyle(fontSize: 14.sp, color: kCallSubtitle);

class _Name extends StatelessWidget {
  const _Name(this.name, {this.size = 20});

  final String name;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Text(
      name,
      textAlign: TextAlign.center,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: figmaText(
        size,
        size * 1.3,
        weight: FontWeight.w700,
        color: Colors.white,
      ),
    );
  }
}

/// mm:ss since [connectedAt], ticking every second.
class _CallTimer extends StatefulWidget {
  const _CallTimer(this.connectedAt);

  final DateTime connectedAt;

  @override
  State<_CallTimer> createState() => _CallTimerState();
}

class _CallTimerState extends State<_CallTimer> {
  late final Timer _ticker;

  @override
  void initState() {
    super.initState();
    _ticker = Timer.periodic(
      const Duration(seconds: 1),
      (_) => setState(() {}),
    );
  }

  @override
  void dispose() {
    _ticker.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      TimeLabels.duration(DateTime.now().difference(widget.connectedAt)),
      style: _subtitle.copyWith(color: kCallWhite70),
    );
  }
}
