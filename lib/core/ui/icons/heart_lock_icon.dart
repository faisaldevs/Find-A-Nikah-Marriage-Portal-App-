import 'package:flutter/material.dart';

/// A padlock shackle open above a solid heart — the Explore tab's "this
/// profile is behind a premium gate" glyph, overlaid centred on a card's
/// photo. The heart is `Icons.favorite` (a hand-drawn path misrendered as
/// a lopsided blob — Material's is battle-tested, so it's simpler and more
/// reliable to build around it than to keep hand-tuning bezier/circle
/// math). Only the shackle is custom-painted, since no Material icon has
/// an open ring. Box: [width] × [width] × 1.08.
class HeartLockIcon extends StatelessWidget {
  const HeartLockIcon({required this.width, required this.color, super.key});

  final double width;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final height = width * 1.08;
    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: 0,
            left: width * 0.17,
            child: CustomPaint(
              size: Size(width * 0.66, width * 0.5),
              painter: _ShacklePainter(color),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Icon(Icons.favorite, size: width * 0.86, color: color),
          ),
        ],
      ),
    );
  }
}

class _ShacklePainter extends CustomPainter {
  const _ShacklePainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.22
      ..strokeCap = StrokeCap.round;
    final radius = size.width * 0.34;
    final centre = Offset(size.width / 2, size.height * 0.56);
    canvas.drawArc(
      Rect.fromCircle(center: centre, radius: radius),
      -2.6, // ~210° past 3 o'clock — opens toward the upper-left.
      4.9, // sweep leaves a gap rather than a full circle.
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(_ShacklePainter old) => old.color != color;
}
