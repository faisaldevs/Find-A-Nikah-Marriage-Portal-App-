import 'dart:math' as math;

import 'package:find_a_nikah/core/ui/ui.dart';
import 'package:find_a_nikah/features/menu/presentation/widgets/menu_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:share_plus/share_plus.dart';

/// "Coming soon" for actions whose screen/API doesn't exist yet.
void showComingSoon(BuildContext context, [String? what]) =>
    CustomToast.showInfo(
      context,
      what == null ? 'Coming soon' : '$what is coming soon',
    );

/// Opens the platform share sheet.
Future<void> shareText(String text, {String? subject}) =>
    SharePlus.instance.share(ShareParams(text: text, subject: subject));

/// 38pt round outlined icon button (Figma: border Grey/200).
class MenuCircleButton extends StatelessWidget {
  const MenuCircleButton({
    required this.icon,
    required this.iconSize,
    required this.onTap,
    required this.semanticLabel,
    this.borderColor = kMenuGrey200,
    super.key,
  });

  final String icon;
  final double iconSize;
  final VoidCallback? onTap;
  final String semanticLabel;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: semanticLabel,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Container(
          width: 38.w,
          height: 38.w,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: borderColor),
          ),
          child: AssetIcon(icon, size: iconSize),
        ),
      ),
    );
  }
}

enum MenuPillStyle { primary, soft, white }

/// Figma "Action": 36pt pill, 16 side padding, Satoshi Bold 14/20.
class MenuPillButton extends StatelessWidget {
  const MenuPillButton({
    required this.label,
    required this.onTap,
    this.style = MenuPillStyle.primary,
    this.fontSize = 14,
    super.key,
  });

  final String label;
  final VoidCallback? onTap;
  final MenuPillStyle style;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    final (bg, fg) = switch (style) {
      MenuPillStyle.primary => (AppColors.primaryColor, Colors.white),
      MenuPillStyle.soft => (kMenuPrimary50, AppColors.primaryColor),
      MenuPillStyle.white => (Colors.white, kMenuGrey950),
    };
    return Material(
      color: bg,
      shape: const StadiumBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const StadiumBorder(),
        child: Container(
          height: 36.w,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          // Hug the label (an `alignment` would stretch to the parent).
          child: Center(
            widthFactor: 1,
            child: Text(
              label,
              style: menuText(fontSize, 20, weight: FontWeight.w700, color: fg),
            ),
          ),
        ),
      ),
    );
  }
}

/// Small pink pill — "76%", "New".
class MenuTag extends StatelessWidget {
  const MenuTag(this.label, {this.fontSize = 12, super.key});

  final String label;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.w),
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(30.r),
      ),
      child: Text(
        label,
        style: menuText(
          fontSize,
          20,
          weight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    );
  }
}

/// Figma "Anonymous off" switch: 46×28; on = brand fill, knob right;
/// off = Grey/300 fill with a #DCDADB edge, knob left.
class MenuToggle extends StatelessWidget {
  const MenuToggle({
    required this.value,
    required this.onChanged,
    required this.semanticLabel,
    super.key,
  });

  final bool value;
  final ValueChanged<bool>? onChanged;
  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    final width = 46.w;
    final height = 28.w;
    return Semantics(
      toggled: value,
      label: semanticLabel,
      child: GestureDetector(
        onTap: onChanged == null ? null : () => onChanged!(!value),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: width,
          height: height,
          padding: EdgeInsets.symmetric(horizontal: 4.5.w),
          decoration: BoxDecoration(
            color: value ? AppColors.primaryColor : kMenuGrey300,
            borderRadius: BorderRadius.circular(height / 2),
            border: Border.all(
              color: value ? AppColors.primaryColor : const Color(0xFFDCDADB),
              width: 1.4,
            ),
          ),
          child: AnimatedAlign(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            alignment: value ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              // Figma: knob r6.5 when on, r7 when off.
              width: (value ? 13 : 14).w,
              height: (value ? 13 : 14).w,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Figma "Line 19": 1pt dashed Grey/300, 2 on / 2 off.
class MenuDashedDivider extends StatelessWidget {
  const MenuDashedDivider({super.key});

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 1,
    width: double.infinity,
    child: CustomPaint(painter: _DashPainter()),
  );
}

class _DashPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = kMenuGrey300
      ..strokeWidth = 1;
    for (var x = 0.0; x < size.width; x += 4) {
      canvas.drawLine(
        Offset(x, 0.5),
        Offset(math.min(x + 2, size.width), 0.5),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Section heading (Figma: Outfit SemiBold, 20 on Settings / 22 on Edit,
/// line height 1.4) with an optional trailing tag.
class MenuSectionTitle extends StatelessWidget {
  const MenuSectionTitle(this.text, {this.fontSize = 20, this.tag, super.key});

  final String text;
  final double fontSize;
  final Widget? tag;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: kMenuGutter),
      child: Row(
        children: [
          Flexible(
            child: Text(
              text,
              style: menuText(
                fontSize,
                fontSize * 1.4,
                weight: FontWeight.w600,
              ),
            ),
          ),
          if (tag != null) ...[SizedBox(width: 14.w), tag!],
        ],
      ),
    );
  }
}

/// One settings / edit-profile row: bold title (+ optional badge), value
/// line(s), and a trailing icon or toggle vertically centred on the right.
class MenuInfoRow extends StatelessWidget {
  const MenuInfoRow({
    required this.title,
    this.titleBadge,
    this.value,
    this.valueStyle,
    this.hint,
    this.hintStyle,
    this.trailing,
    this.onTap,
    this.showDivider = true,
    super.key,
  });

  final String title;
  final Widget? titleBadge;
  final String? value;
  final TextStyle? valueStyle;
  final String? hint;
  final TextStyle? hintStyle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final content = Padding(
      padding: EdgeInsets.only(top: 4.w),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        title,
                        style: menuText(
                          16,
                          20,
                          weight: FontWeight.w700,
                          color: kMenuRowTitle,
                        ),
                      ),
                    ),
                    if (titleBadge != null) ...[
                      SizedBox(width: 8.w),
                      titleBadge!,
                    ],
                  ],
                ),
                if (value != null) ...[
                  SizedBox(height: 8.w),
                  Text(
                    value!,
                    style: valueStyle ?? menuText(15, 20, color: kMenuGrey400),
                  ),
                ],
                if (hint != null) ...[
                  SizedBox(height: 4.w),
                  Text(
                    hint!,
                    style: hintStyle ?? menuText(14, 20, color: kMenuGrey400),
                  ),
                ],
              ],
            ),
          ),
          if (trailing != null) ...[SizedBox(width: 12.w), trailing!],
        ],
      ),
    );
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: kMenuGutter),
      child: Column(
        children: [
          if (onTap == null) content else InkWell(onTap: onTap, child: content),
          if (showDivider) ...[
            SizedBox(height: 16.w),
            const MenuDashedDivider(),
          ],
        ],
      ),
    );
  }
}

/// A list of [MenuInfoRow]s [gap] apart (Settings: 20, Edit profile: 24),
/// with the divider dropped after the last one.
class MenuRowGroup extends StatelessWidget {
  const MenuRowGroup({required this.rows, this.gap = 20, super.key});

  final List<MenuInfoRow> rows;
  final double gap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < rows.length; i++) ...[
          if (i > 0) SizedBox(height: gap.w),
          if (i == rows.length - 1)
            MenuInfoRow(
              title: rows[i].title,
              titleBadge: rows[i].titleBadge,
              value: rows[i].value,
              valueStyle: rows[i].valueStyle,
              hint: rows[i].hint,
              hintStyle: rows[i].hintStyle,
              trailing: rows[i].trailing,
              onTap: rows[i].onTap,
              showDivider: false,
            )
          else
            rows[i],
        ],
      ],
    );
  }
}

/// Member photo in a white 66pt disc with a red completeness arc around
/// it (Figma: white bg, #E5E7EB border, 60pt photo, #E54848 arc).
class MenuProfileAvatar extends StatelessWidget {
  const MenuProfileAvatar({
    required this.photoUrl,
    required this.completeness,
    super.key,
  });

  final String? photoUrl;

  /// 0–100: how much of the ring is drawn.
  final int completeness;

  @override
  Widget build(BuildContext context) {
    final outer = 66.w;
    final inner = 60.w;
    return SizedBox.square(
      dimension: outer,
      child: CustomPaint(
        painter: _ProgressRingPainter(completeness / 100),
        child: Center(
          child: ClipOval(
            child: SizedBox.square(
              dimension: inner,
              child: photoUrl == null
                  ? const ColoredBox(
                      color: Color(0xFFEEEEEE),
                      child: Icon(Icons.person, color: kMenuGrey400),
                    )
                  : AppPhoto(photoUrl!),
            ),
          ),
        ),
      ),
    );
  }
}

class _ProgressRingPainter extends CustomPainter {
  _ProgressRingPainter(this.progress);

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    canvas
      ..drawOval(rect, Paint()..color = Colors.white)
      ..drawOval(
        rect.deflate(0.5),
        Paint()
          ..style = PaintingStyle.stroke
          ..color = kMenuBorderLine,
      );
    if (progress <= 0) return;
    // Figma draws the arc from the bottom, sweeping clockwise.
    canvas.drawArc(
      rect.deflate(1.5),
      math.pi / 2,
      2 * math.pi * progress.clamp(0, 1),
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round
        ..color = kMenuRed,
    );
  }

  @override
  bool shouldRepaint(covariant _ProgressRingPainter old) =>
      old.progress != progress;
}
