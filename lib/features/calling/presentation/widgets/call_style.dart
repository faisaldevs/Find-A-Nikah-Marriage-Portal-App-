import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

/// Navy-blue fade behind a live / ringing call.
const kCallGradient = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [Color(0xFF1E4BC4), Color(0xFF0B1B44), Color(0xFF061128)],
  stops: [0, 0.35, 1],
);

/// Charcoal fade behind "Call ended".
const kCallEndedGradient = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [Color(0xFF2B2B2B), Color(0xFF1B1B1B)],
);

const kCallRed = Color(0xFFE5383B);
const kCallGreen = Color(0xFF2FBF5B);
const kCallSubtitle = Color(0xFF9DB4F2);
const kCallGlass = Color(0x29FFFFFF);
const kCallWhite70 = Color(0xB3FFFFFF);

/// A round call control, optionally labelled underneath. [active] draws it
/// white with a dark icon (mute on, speaker on).
class CallRoundButton extends StatelessWidget {
  const CallRoundButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
    this.background = kCallGlass,
    this.size = 52,
    this.active = false,
    this.label,
    super.key,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback? onTap;
  final Color background;
  final double size;
  final bool active;
  final String? label;

  @override
  Widget build(BuildContext context) {
    final button = Tooltip(
      message: tooltip,
      child: Material(
        color: active ? Colors.white : background,
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: SizedBox.square(
            dimension: size.r,
            child: Icon(
              icon,
              size: (size * 0.46).r,
              color: active ? const Color(0xFF0B1B44) : Colors.white,
            ),
          ),
        ),
      ),
    );
    final text = label;
    if (text == null) return button;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        button,
        SizedBox(height: 10.w),
        Text(
          text,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
