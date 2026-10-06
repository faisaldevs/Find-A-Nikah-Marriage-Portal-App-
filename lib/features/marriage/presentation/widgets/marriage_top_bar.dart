import 'package:find_a_nikah/gen/assets.gen.dart';
import 'package:find_a_nikah/gen/colors.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

/// Filters · Find A Nikah logo · Sort · Notifications.
class MarriageTopBar extends StatelessWidget {
  const MarriageTopBar({
    super.key,
    required this.onFilters,
    required this.onSort,
    required this.onNotifications,
  });

  final VoidCallback onFilters;
  final VoidCallback onSort;
  final VoidCallback onNotifications;

  @override
  Widget build(BuildContext context) {
    // Full-profile mockup: 38 circles at 19.5 / 20.5 from the edges, 10
    // apart on the right; the wordmark centred on the screen (not between
    // the buttons); 13 above and 17 below the circles.
    return Padding(
      padding: EdgeInsets.fromLTRB(19.5.w, 13.h, 20.5.w, 17.h),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Wordmark only (navy text, pink ∧) — the full logo's text is
          // white, so on this light bar only its heart showed. Offset by
          // half the asymmetric side padding so it centres on the screen.
          Padding(
            padding: EdgeInsets.only(right: 2.w),
            child: Image.asset(Assets.images.findANikahWordmark, height: 16.h),
          ),
          Row(
            children: [
              _CircleIconButton(
                icon: const _FiltersGlyph(),
                tooltip: 'Filters',
                onTap: onFilters,
              ),
              const Spacer(),
              _CircleIconButton(
                icon: Icon(
                  Icons.swap_vert,
                  size: 19.r,
                  color: AppColors.textDark,
                ),
                tooltip: 'Sort',
                onTap: onSort,
              ),
              SizedBox(width: 10.w),
              _CircleIconButton(
                icon: Icon(
                  Icons.notifications_none,
                  size: 17.5.r,
                  color: AppColors.textDark,
                ),
                tooltip: 'Notifications',
                onTap: onNotifications,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Before the full-profile mockup: 36 circles, logo centred between the
  // buttons (so off-centre on screen).
  // @override
  // Widget build(BuildContext context) {
  //   return Padding(
  //     padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 14.h),
  //     // padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 8.h),
  //     child: Row(
  //       children: [
  //         _CircleIconButton(
  //           icon: Icons.tune,
  //           tooltip: 'Filters',
  //           onTap: onFilters,
  //         ),
  //         Expanded(
  //           child: Center(
  //             // Wordmark only (navy text, pink ∧) — the full logo's text is
  //             // white, so on this light bar only its heart showed.
  //             child: Image.asset(
  //               Assets.images.findANikahWordmark,
  //               height: 16.h,
  //             ),
  //             // child: Image.asset(
  //             //   Assets.images.findANikahFullLogoImage4xColored,
  //             //   height: 22.h,
  //             // ),
  //           ),
  //         ),
  //         _CircleIconButton(
  //           icon: Icons.swap_vert,
  //           tooltip: 'Sort',
  //           onTap: onSort,
  //         ),
  //         SizedBox(width: 8.w),
  //         _CircleIconButton(
  //           icon: Icons.notifications_none,
  //           tooltip: 'Notifications',
  //           onTap: onNotifications,
  //         ),
  //       ],
  //     ),
  //   );
  // }
}

class _CircleIconButton extends StatelessWidget {
  const _CircleIconButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  final Widget icon;
  // final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkResponse(
        onTap: onTap,
        radius: 22.r,
        child: Container(
          width: 38.r,
          height: 38.r,
          alignment: Alignment.center,
          // width: 36.r,
          // height: 36.r,
          // White circle with a faint border, per the mockup.
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFFE6E7EB)),
            // border: Border.all(color: const Color(0xFFEBECEE)),
          ),
          // decoration: BoxDecoration(
          //   shape: BoxShape.circle,
          //   border: Border.all(color: Colors.grey.shade300),
          // ),
          child: icon,
          // child: Icon(icon, size: 18.r, color: AppColors.textDark),
        ),
      ),
    );
  }
}

/// The mockup's filters glyph: two rows, circle-then-line over
/// line-then-circle (Icons.tune has three sliders).
class _FiltersGlyph extends StatelessWidget {
  const _FiltersGlyph();

  @override
  Widget build(BuildContext context) => CustomPaint(
    size: Size(16.6.r, 14.r),
    painter: const _FiltersPainter(AppColors.textDark),
  );
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
