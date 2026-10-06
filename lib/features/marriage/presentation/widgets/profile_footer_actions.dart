import 'package:find_a_nikah/core/constants/text_font_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import 'profile_style.dart';

/// End of a profile: centred "Share profile", a divider, then Favourite ·
/// Block · Report.
class ProfileFooterActions extends StatelessWidget {
  const ProfileFooterActions({
    super.key,
    required this.onShare,
    required this.onFavourite,
    required this.onBlock,
    required this.onReport,
  });

  final VoidCallback onShare;
  final VoidCallback onFavourite;
  final VoidCallback onBlock;
  final VoidCallback onReport;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 37.4.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: InkWell(
              onTap: onShare,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 5.35.h),
                    child: _TrayUpIcon(size: 16.5.r),
                  ),
                  SizedBox(width: 11.w),
                  Text(
                    'Share profile',
                    style: TextFontStyle.headline16w500textDarkStyleSatoshi
                        .copyWith(color: kProfileInk)
                        .lh(22),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 31.6.h),
          Padding(
            padding: EdgeInsets.only(left: 19.5.w, right: 20.5.w),
            child: const Divider(
              height: 1,
              thickness: 1,
              color: kProfileBorder,
            ),
          ),
          SizedBox(height: 19.h),
          Padding(
            padding: EdgeInsets.only(left: 40.w, right: 41.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Mockup reuses the share glyph for Favourite.
                _Action(
                  icon: _TrayUpIcon(size: 14.5.r),
                  label: 'Favourite',
                  onTap: onFavourite,
                ),
                _Action(
                  icon: Icon(Icons.block, size: 19.2.r, color: kProfileInk),
                  label: 'Block',
                  onTap: onBlock,
                ),
                _Action(
                  icon: CustomPaint(
                    size: Size(12.r, 14.5.r),
                    painter: const _FlagPainter(kProfileInk),
                  ),
                  label: 'Report',
                  onTap: onReport,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Action extends StatelessWidget {
  const _Action({required this.icon, required this.label, required this.onTap});

  final Widget icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Column(
        children: [
          SizedBox(
            height: 16.h,
            child: Center(child: icon),
          ),
          SizedBox(height: 9.2.h),
          Text(
            label,
            style: TextFontStyle.headline14w400textDarkStyleSatoshi
                .copyWith(color: kProfileInk)
                .lh(20),
          ),
        ],
      ),
    );
  }
}

/// Open tray with an arrow pointing up out of it (the mockup's share glyph).
class _TrayUpIcon extends StatelessWidget {
  const _TrayUpIcon({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) => CustomPaint(
    size: Size.square(size),
    painter: const _TrayUpPainter(kProfileInk),
  );
}

class _TrayUpPainter extends CustomPainter {
  const _TrayUpPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final sw = w * 0.085;
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = sw
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final i = sw / 2;
    final r = w * 0.12;
    // Tray: up the sides to half height, rounded bottom corners.
    final tray = Path()
      ..moveTo(i, h * 0.5)
      ..lineTo(i, h - i - r)
      ..quadraticBezierTo(i, h - i, i + r, h - i)
      ..lineTo(w - i - r, h - i)
      ..quadraticBezierTo(w - i, h - i, w - i, h - i - r)
      ..lineTo(w - i, h * 0.5);
    final arrow = Path()
      ..moveTo(w / 2, h * 0.68)
      ..lineTo(w / 2, i)
      ..moveTo(w * 0.27, h * 0.24)
      ..lineTo(w / 2, i)
      ..lineTo(w * 0.73, h * 0.24);
    canvas
      ..drawPath(tray, paint)
      ..drawPath(arrow, paint);
  }

  @override
  bool shouldRepaint(_TrayUpPainter old) => old.color != color;
}

/// Pole with a flat pennant (the mockup's Report glyph).
class _FlagPainter extends CustomPainter {
  const _FlagPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final sw = w * 0.1;
    final i = sw / 2;
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = sw
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final path = Path()
      ..moveTo(i, h - i)
      ..lineTo(i, i)
      ..quadraticBezierTo(w * 0.3, h * 0.12, w * 0.55, i + h * 0.04)
      ..quadraticBezierTo(w * 0.8, -h * 0.02, w - i, i + h * 0.03)
      ..lineTo(w - i, h * 0.55)
      ..quadraticBezierTo(w * 0.8, h * 0.5, w * 0.55, h * 0.58)
      ..quadraticBezierTo(w * 0.3, h * 0.66, i, h * 0.58);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_FlagPainter old) => old.color != color;
}
