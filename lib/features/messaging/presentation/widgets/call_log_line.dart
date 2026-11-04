import 'package:find_a_nikah/core/ui/ui.dart';
import 'package:find_a_nikah/features/messaging/domain/domain.dart';
import 'package:find_a_nikah/features/messaging/presentation/widgets/messaging_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

/// A finished voice call, as a centred grey pill in the thread:
/// "Voice call · 02:14 · 14:05", red when the user missed it.
class CallLogLine extends StatelessWidget {
  const CallLogLine(this.call, {required this.at, super.key});

  final CallLog call;
  final DateTime at;

  @override
  Widget build(BuildContext context) {
    final missed =
        !call.outgoing &&
        (call.outcome == CallOutcome.missed ||
            call.outcome == CallOutcome.declined);
    final color = missed ? AppColors.errorColor : kMsgGrey500;
    final (icon, label) = switch (call.outcome) {
      CallOutcome.completed => (
        call.outgoing ? Icons.call_made_rounded : Icons.call_received_rounded,
        'Voice call · ${TimeLabels.duration(call.duration)}',
      ),
      CallOutcome.missed => (Icons.call_missed_rounded, 'Missed voice call'),
      CallOutcome.declined => (
        Icons.call_missed_rounded,
        'Declined voice call',
      ),
      CallOutcome.cancelled => (
        Icons.call_made_rounded,
        call.outgoing ? 'Cancelled voice call' : 'Missed voice call',
      ),
    };
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.w),
        decoration: BoxDecoration(
          color: kMsgGrey100,
          borderRadius: BorderRadius.circular(20.w),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16.r, color: color),
            SizedBox(width: 6.w),
            Text(
              '$label · ${TimeLabels.clock(at)}',
              style: figmaText(13, 18, weight: FontWeight.w500, color: color),
            ),
          ],
        ),
      ),
    );
  }
}
