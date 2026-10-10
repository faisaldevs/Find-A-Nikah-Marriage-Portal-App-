import 'package:flutter/material.dart';

/// The mockups' premium crown: three-point crown over a separate bar.
/// Drawn rather than an icon font because no Material icon matches it.
/// [width] × 0.74 high (the mockup's 22 × 16). Shared by the Marriage
/// full-profile hero/teaser and the Explore tab's premium badges.
class CrownIcon extends StatelessWidget {
  const CrownIcon({required this.width, required this.color, super.key});

  final double width;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(width, width * 0.74),
      painter: _CrownPainter(color),
    );
  }
}

class _CrownPainter extends CustomPainter {
  const _CrownPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    Offset p(double x, double y) => Offset(x * w, y * h);
    final paint = Paint()
      ..color = color
      ..isAntiAlias = true;
    // Points traced from the 4x mockup, normalised to the icon box.
    final body = Path()
      ..moveTo(p(0, .26).dx, p(0, .26).dy)
      ..lineTo(p(.273, .43).dx, p(.273, .43).dy)
      ..lineTo(p(.511, 0).dx, p(.511, 0).dy)
      ..lineTo(p(.761, .43).dx, p(.761, .43).dy)
      ..lineTo(p(1, .26).dx, p(1, .26).dy)
      ..lineTo(p(.909, .754).dx, p(.909, .754).dy)
      ..lineTo(p(.09, .754).dx, p(.09, .754).dy)
      ..close();
    final bar = Path()
      ..moveTo(p(.09, .846).dx, p(.09, .846).dy)
      ..lineTo(p(.909, .846).dx, p(.909, .846).dy)
      ..lineTo(p(.886, 1).dx, p(.886, 1).dy)
      ..lineTo(p(.114, 1).dx, p(.114, 1).dy)
      ..close();
    canvas
      ..drawPath(body, paint)
      ..drawPath(bar, paint);
  }

  @override
  bool shouldRepaint(_CrownPainter old) => old.color != color;
}
