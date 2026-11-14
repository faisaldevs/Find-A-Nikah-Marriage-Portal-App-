import 'dart:async';

import 'package:find_a_nikah/core/ui/ui.dart';
import 'package:find_a_nikah/features/messaging/presentation/widgets/messaging_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:just_audio/just_audio.dart';

/// Play / pause, a progress bar and the length of a voice message. [source]
/// is a URL, or a local file path while the note is still uploading.
class VoiceBubble extends StatefulWidget {
  const VoiceBubble({
    required this.source,
    required this.duration,
    required this.onPink,
    super.key,
  });

  final String source;
  final Duration duration;

  /// Inside an own (pink) bubble: white controls.
  final bool onPink;

  @override
  State<VoiceBubble> createState() => _VoiceBubbleState();
}

class _VoiceBubbleState extends State<VoiceBubble> {
  /// Only one voice note plays at a time.
  static _VoiceBubbleState? _current;

  AudioPlayer? _player;
  StreamSubscription<PlayerState>? _stateSub;
  StreamSubscription<Duration>? _posSub;
  var _playing = false;
  var _failed = false;
  var _position = Duration.zero;
  late Duration _total = widget.duration;

  bool get _remote => widget.source.startsWith('http');

  Future<void> _toggle() async {
    if (_playing) {
      await _player?.pause();
      return;
    }
    if (_current != null && _current != this) {
      await _current!._player?.pause();
    }
    _current = this;
    try {
      if (_player == null) {
        final player = AudioPlayer();
        _player = player;
        _stateSub = player.playerStateStream.listen((s) {
          if (!mounted) return;
          if (s.processingState == ProcessingState.completed) {
            unawaited(player.seek(Duration.zero));
            unawaited(player.pause());
            setState(() {
              _playing = false;
              _position = Duration.zero;
            });
          } else {
            setState(() => _playing = s.playing);
          }
        });
        _posSub = player.positionStream.listen((p) {
          if (mounted) setState(() => _position = p);
        });
        final loaded = _remote
            ? await player.setUrl(widget.source)
            : await player.setFilePath(widget.source);
        if (loaded != null && loaded > Duration.zero) _total = loaded;
      }
      await _player!.play();
    } on Object {
      if (mounted) setState(() => _failed = true);
    }
  }

  @override
  void dispose() {
    if (_current == this) _current = null;
    unawaited(_stateSub?.cancel());
    unawaited(_posSub?.cancel());
    unawaited(_player?.dispose());
    super.dispose();
  }

  String _clock(Duration d) =>
      '${d.inMinutes}:${(d.inSeconds % 60).toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final fg = widget.onPink ? Colors.white : AppColors.primaryColor;
    final track = widget.onPink
        ? Colors.white.withValues(alpha: 0.35)
        : kMsgGrey200;
    final progress = _total.inMilliseconds == 0
        ? 0.0
        : (_position.inMilliseconds / _total.inMilliseconds).clamp(0.0, 1.0);
    return SizedBox(
      width: 200.w,
      child: Row(
        children: [
          InkResponse(
            onTap: _toggle,
            child: Icon(
              _failed
                  ? Icons.error_outline_rounded
                  : _playing
                  ? Icons.pause_circle_filled_rounded
                  : Icons.play_circle_fill_rounded,
              size: 36.r,
              color: fg,
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(2.w),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 4.w,
                    backgroundColor: track,
                    valueColor: AlwaysStoppedAnimation(fg),
                  ),
                ),
                SizedBox(height: 4.w),
                Text(
                  _failed
                      ? 'Couldn’t play'
                      : _clock(_playing ? _position : _total),
                  style: figmaText(
                    11,
                    14,
                    color: widget.onPink
                        ? Colors.white.withValues(alpha: 0.85)
                        : kMsgGrey500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
