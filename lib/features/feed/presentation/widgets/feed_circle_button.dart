import 'package:find_a_nikah/core/ui/ui.dart';
import 'package:find_a_nikah/features/feed/presentation/widgets/feed_icon.dart';
import 'package:flutter/material.dart';

/// Figma's 38pt outlined top-bar circle around a Feed-flow icon.
class FeedCircleButton extends StatelessWidget {
  const FeedCircleButton({
    required this.asset,
    required this.iconSize,
    required this.tooltip,
    required this.onTap,
    this.iconColor,
    super.key,
  });

  final String asset;
  final double iconSize;
  final String tooltip;
  final VoidCallback onTap;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return CircleIconButton(
      // 40.r renders Figma's 38pt (`.r` ≈ 0.95 on phones).
      size: 40,
      icon: FeedIcon(asset, size: iconSize, color: iconColor),
      tooltip: tooltip,
      onTap: onTap,
    );
  }
}
