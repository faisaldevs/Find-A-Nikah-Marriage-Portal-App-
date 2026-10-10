import 'package:find_a_nikah/core/ui/ui.dart';
import 'package:flutter/material.dart';

/// Centred heart-lock glyph shown on a card whose profile is behind the
/// premium gate (no background shape — just the white icon on the photo,
/// readable thanks to the card's own bottom gradient).
class ExploreLockOverlay extends StatelessWidget {
  const ExploreLockOverlay({required this.size, super.key});

  final double size;

  @override
  Widget build(BuildContext context) =>
      HeartLockIcon(width: size, color: Colors.white);
}
