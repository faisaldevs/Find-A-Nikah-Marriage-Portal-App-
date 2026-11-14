import 'dart:async';
import 'dart:io';

import 'package:find_a_nikah/core/ui/ui.dart';
import 'package:find_a_nikah/features/messaging/presentation/widgets/messaging_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

/// Longest voice note the API accepts.
const kMaxVoiceSeconds = 120;

/// Shortest one worth sending.
const kMinVoiceSeconds = 1;

/// Replaces the composer while a voice note is being recorded: a pulsing
/// dot and timer, trash to throw it away, send to finish. Starts recording
/// as soon as it appears and stops itself at [kMaxVoiceSeconds].
class VoiceRecorderBar extends StatefulWidget {
  const VoiceRecorderBar({
    required this.onCancel,
    required this.onDone,
    this.onDenied,
    super.key,
  });

  /// Thrown away (trash, too short, or permission refused).
  final VoidCallback onCancel;

  /// A finished AAC file and how long it is.
  final void Function(String path, Duration duration) onDone;

  /// The microphone permission was refused.
  final VoidCallback? onDenied;

  @override
  State<VoiceRecorderBar> createState() => _VoiceRecorderBarState();
}

class _VoiceRecorderBarState extends State<VoiceRecorderBar> {
  final _recorder = AudioRecorder();
  Timer? _ticker;
  final _watch = Stopwatch();
  var _seconds = 0;
  var _finished = false;
  String? _path;

  @override
  void initState() {
    super.initState();
    unawaited(_start());
  }

  Future<void> _start() async {
    try {
      if (!await _recorder.hasPermission()) {
        widget.onDenied?.call();
        widget.onCancel();
        return;
      }
      final dir = await getTemporaryDirectory();
      final path =
          '${dir.path}/voice_${DateTime.now().millisecondsSinceEpoch}.m4a';
      await _recorder.start(
        const RecordConfig(bitRate: 64000, numChannels: 1),
        path: path,
      );
      _path = path;
      _watch.start();
      _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
        if (!mounted) return;
        setState(() => _seconds = _watch.elapsed.inSeconds);
        if (_seconds >= kMaxVoiceSeconds) unawaited(_finish());
      });
    } on Object {
      widget.onDenied?.call();
      widget.onCancel();
    }
  }

  Future<void> _finish() async {
    if (_finished) return;
    _finished = true;
    _ticker?.cancel();
    final elapsed = _watch.elapsed;
    final path = await _recorder.stop() ?? _path;
    if (path == null || elapsed.inSeconds < kMinVoiceSeconds) {
      await _discard(path);
      widget.onCancel();
      return;
    }
    widget.onDone(
      path,
      Duration(seconds: elapsed.inSeconds.clamp(1, kMaxVoiceSeconds)),
    );
  }

  Future<void> _cancel() async {
    if (_finished) return;
    _finished = true;
    _ticker?.cancel();
    final path = await _recorder.stop() ?? _path;
    await _discard(path);
    widget.onCancel();
  }

  Future<void> _discard(String? path) async {
    if (path == null) return;
    try {
      await File(path).delete();
    } on Object {
      // A temp file: the OS cleans it up eventually.
    }
  }

  @override
  void dispose() {
    _ticker?.cancel();
    unawaited(_recorder.dispose());
    super.dispose();
  }

  String get _clock {
    final m = _seconds ~/ 60;
    final s = (_seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: kMsgGrey200)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(8.w, 10.w, 12.w, 10.w),
          child: Row(
            children: [
              IconButton(
                tooltip: 'Delete recording',
                onPressed: _cancel,
                icon: Icon(
                  Icons.delete_outline_rounded,
                  size: 26.r,
                  color: AppColors.errorColor,
                ),
              ),
              SizedBox(width: 4.w),
              Icon(Icons.fiber_manual_record, size: 14.r, color: Colors.red),
              SizedBox(width: 8.w),
              Text(_clock, style: figmaText(16, 22, weight: FontWeight.w700)),
              const Spacer(),
              Text(
                'Recording…',
                style: figmaText(14, 20, color: kMsgGrey500),
              ),
              SizedBox(width: 12.w),
              Tooltip(
                message: 'Send voice message',
                child: InkResponse(
                  onTap: _finish,
                  child: Container(
                    width: 44.r,
                    height: 44.r,
                    decoration: const BoxDecoration(
                      color: AppColors.primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.send_rounded,
                      size: 20.r,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
