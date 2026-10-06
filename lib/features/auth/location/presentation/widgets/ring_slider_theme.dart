import 'package:find_a_nikah/gen/colors.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

/// Wraps a [Slider]/[RangeSlider] in the mockup's look: thin black active
/// track, light grey inactive track, hollow white thumb with a dark ring.
/// Material's stock thumb is a filled disc, hence the two custom shapes.
class RingSliderTheme extends StatelessWidget {
  const RingSliderTheme({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: SliderThemeData(
        trackHeight: 3.h,
        activeTrackColor: AppColors.textDark,
        inactiveTrackColor: const Color(0xFFD9D9D9),
        thumbColor: Colors.white,
        overlayColor: AppColors.textDark.withValues(alpha: 0.08),
        overlayShape: RoundSliderOverlayShape(overlayRadius: 20.r),
        thumbShape: _RingThumbShape(radius: 12.r),
        rangeThumbShape: _RingRangeThumbShape(radius: 12.r),
        trackShape: const RoundedRectSliderTrackShape(),
        rangeTrackShape: const RoundedRectRangeSliderTrackShape(),
        showValueIndicator: ShowValueIndicator.never,
      ),
      child: child,
    );
  }
}

void _paintRing(Canvas canvas, Offset center, double radius) {
  canvas.drawCircle(center, radius, Paint()..color = Colors.white);
  canvas.drawCircle(
    center,
    radius - 1,
    Paint()
      ..color = AppColors.textDark
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2,
  );
}

class _RingThumbShape extends SliderComponentShape {
  const _RingThumbShape({required this.radius});

  final double radius;

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) =>
      Size.fromRadius(radius);

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    _paintRing(context.canvas, center, radius);
  }
}

class _RingRangeThumbShape extends RangeSliderThumbShape {
  const _RingRangeThumbShape({required this.radius});

  final double radius;

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) =>
      Size.fromRadius(radius);

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    bool isDiscrete = false,
    bool isEnabled = false,
    bool? isOnTop,
    required SliderThemeData sliderTheme,
    TextDirection? textDirection,
    Thumb? thumb,
    bool? isPressed,
  }) {
    _paintRing(context.canvas, center, radius);
  }
}
