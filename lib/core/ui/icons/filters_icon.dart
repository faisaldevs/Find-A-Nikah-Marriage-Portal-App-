import 'package:flutter/material.dart';

/// The mockups' filters glyph: two rows, circle-then-line over
/// line-then-circle (`Icons.tune` has three sliders, not two). Shared by
/// the Marriage and Explore top bars' filter button.
class FiltersIcon extends StatelessWidget {
  const FiltersIcon({required this.size, required this.color, super.key});

  final Size size;
  final Color color;

  @override
  Widget build(BuildContext context) =>
      CustomPaint(size: size, painter: _FiltersPainter(color));
}

class _FiltersPainter extends CustomPainter {
  const _FiltersPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final sw = w * 0.08;
    final r = h * 0.17;
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = sw
      ..strokeCap = StrokeCap.round;
    final top = r + sw / 2;
    final bottom = h - r - sw / 2;
    final left = r + sw / 2;
    final right = w - r - sw / 2;
    canvas
      ..drawCircle(Offset(left, top), r, paint)
      ..drawLine(
        Offset(left + r + w * 0.12, top),
        Offset(w - sw / 2, top),
        paint,
      )
      ..drawCircle(Offset(right, bottom), r, paint)
      ..drawLine(
        Offset(sw / 2, bottom),
        Offset(right - r - w * 0.12, bottom),
        paint,
      );
  }

  @override
  bool shouldRepaint(_FiltersPainter old) => old.color != color;
}
