import 'dart:math' as math;

import 'package:find_a_nikah/features/messaging/presentation/widgets/messaging_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

/// Grey bubble with three dots rising in turn — the peer is typing.
class TypingBubble extends StatefulWidget {
  const TypingBubble({super.key});

  @override
  State<TypingBubble> createState() => _TypingBubbleState();
}

class _TypingBubbleState extends State<TypingBubble>
    with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.w),
        decoration: BoxDecoration(
          color: kMsgGrey100,
          borderRadius: BorderRadius.circular(16.w),
        ),
        child: AnimatedBuilder(
          animation: _controller,
          builder: (_, _) => Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var i = 0; i < 3; i++) ...[
                if (i > 0) SizedBox(width: 4.w),
                _dot(i),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _dot(int i) {
    // Each dot lifts during its own third of the cycle.
    final t = (_controller.value - i / 3) % 1;
    final lift = t < 1 / 3 ? math.sin(t * 3 * math.pi) : 0.0;
    return Transform.translate(
      offset: Offset(0, -3.w * lift),
      child: Container(
        width: 6.w,
        height: 6.w,
        decoration: BoxDecoration(
          color: Color.lerp(kMsgGrey400, kMsgGrey500, lift),
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
