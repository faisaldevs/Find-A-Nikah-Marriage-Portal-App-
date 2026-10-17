import 'package:find_a_nikah/core/ui/ui.dart';
import 'package:find_a_nikah/features/chat/presentation/widgets/chat_style.dart';
import 'package:find_a_nikah/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

/// Title centred on the screen with a 38pt circle on one side: the
/// [action] on the right ("Your Chats"), or a back button on the left
/// (pushed pages).
class ChatHeader extends StatelessWidget {
  const ChatHeader({
    required this.title,
    this.onBack,
    this.action,
    super.key,
  });

  final String title;
  final VoidCallback? onBack;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Padding(
      // Figma: circle 70pt from the top of the 844 frame.
      padding: EdgeInsets.fromLTRB(20.w, 5.4.h, 20.w, 0),
      child: SizedBox(
        height: 38.w,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Text(title, style: figmaText(20, 28, weight: FontWeight.w700)),
            if (onBack != null)
              Align(
                alignment: Alignment.centerLeft,
                child: ChatCircleButton(
                  icon: Assets.icons.feedBack,
                  tooltip: 'Back',
                  onTap: onBack!,
                ),
              ),
            if (action != null)
              Align(alignment: Alignment.centerRight, child: action),
          ],
        ),
      ),
    );
  }
}

/// Figma's 38pt outlined circle around a 24pt icon.
class ChatCircleButton extends StatelessWidget {
  const ChatCircleButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
    super.key,
  });

  final String icon;
  final String tooltip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return CircleIconButton(
      // 40.r renders Figma's 38pt (`.r` ≈ 0.95 on phones).
      size: 40,
      icon: AssetIcon(icon, size: 24, color: kChatIconDark),
      tooltip: tooltip,
      onTap: onTap,
    );
  }
}

/// Fully-rounded pink button with a Bold 16 white label.
class ChatPinkButton extends StatelessWidget {
  const ChatPinkButton({
    required this.label,
    required this.onTap,
    required this.height,
    this.width,
    super.key,
  });

  final String label;
  final VoidCallback onTap;
  final double height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width?.w ?? double.infinity,
        height: height.w,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.circular(height.w / 2),
        ),
        child: Text(
          label,
          style: figmaText(
            16,
            22,
            weight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

/// Illustration, Bold 20 heading and grey Regular 16 body, centred — the
/// Unmatched / Archived empty states.
class ChatEmptyMessage extends StatelessWidget {
  const ChatEmptyMessage({
    required this.illustration,
    required this.title,
    required this.message,
    this.horizontalPadding = 20,
    this.illustrationShift = 0,
    super.key,
  });

  final String illustration;
  final String title;
  final String message;
  final double horizontalPadding;

  /// Sideways nudge where Figma doesn't centre the art exactly.
  final double illustrationShift;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding.w),
      child: Column(
        children: [
          Transform.translate(
            offset: Offset(illustrationShift.w, 0),
            child: Image.asset(illustration, width: 110.w, height: 102.w),
          ),
          SizedBox(height: 62.2.w),
          Text(
            title,
            textAlign: TextAlign.center,
            style: figmaText(20, 26, weight: FontWeight.w700),
          ),
          SizedBox(height: 15.4.w),
          Text(
            message,
            textAlign: TextAlign.center,
            style: figmaText(16, 24, color: kChatGrey500),
          ),
        ],
      ),
    );
  }
}
