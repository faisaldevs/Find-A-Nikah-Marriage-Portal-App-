import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

/// White circle with a faint border around an icon — the mockups' top-bar
/// button (filters, sort, notifications on Marriage; filters on Explore).
class CircleIconButton extends StatelessWidget {
  const CircleIconButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
    super.key,
    this.size = 38,
  });

  final Widget icon;
  final String tooltip;
  final VoidCallback onTap;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkResponse(
        onTap: onTap,
        radius: (size / 2).r,
        child: Container(
          width: size.r,
          height: size.r,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFFE6E7EB)),
          ),
          child: icon,
        ),
      ),
    );
  }
}
