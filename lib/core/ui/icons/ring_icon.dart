import 'package:flutter/material.dart';

/// Outline engagement ring with a small diamond on top — the mockups'
/// "Marriage" glyph (bottom nav, marriage-intentions pill). No Material icon
/// matches it. Drawn in a box of [width] × [width] × 1.28.
class RingIcon extends StatelessWidget {
  const RingIcon({required this.width, required this.color, super.key});

  final double width;
  final Color color;

  @override
  Widget build(BuildContext context) => CustomPaint(
    size: Size(width, width * 1.28),
    painter: _RingPainter(color),
  );
}

class _RingPainter extends CustomPainter {
  const _RingPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final stroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.09
      ..strokeJoin = StrokeJoin.round;
    // Band: outer and inner circle filling the lower ~3/4.
    final r = w / 2 - stroke.strokeWidth / 2;
    final centre = Offset(w / 2, h - r - stroke.strokeWidth / 2);
    canvas
      ..drawCircle(centre, r, stroke)
      ..drawCircle(centre, r * 0.72, stroke..strokeWidth = w * 0.06);
    // Gem: a flat-topped diamond resting on the band.
    final base = centre.dy - r;
    final gemTop = h * 0.04;
    final gem = Path()
      ..moveTo(w * 0.22, base - (base - gemTop) * 0.55)
      ..lineTo(w * 0.36, gemTop)
      ..lineTo(w * 0.64, gemTop)
      ..lineTo(w * 0.78, base - (base - gemTop) * 0.55)
      ..lineTo(w * 0.5, base)
      ..close()
      ..moveTo(w * 0.22, base - (base - gemTop) * 0.55)
      ..lineTo(w * 0.78, base - (base - gemTop) * 0.55);
    canvas.drawPath(gem, stroke..strokeWidth = w * 0.07);
  }

  @override
  bool shouldRepaint(_RingPainter old) => old.color != color;
}
