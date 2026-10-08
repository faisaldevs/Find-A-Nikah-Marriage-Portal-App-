import 'package:find_a_nikah/core/ui/ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

// Button colours from the mockup. Local until the design's colour tokens are
// added to assets/color/colors.xml.
// Sampled from the mockup.
const _cancelColor = Color(0xFF404040);
const _previousColor = Color(0xFF17A34A);
const _messageColor = Color(0xFFAE53DE);
// const _cancelColor = Color(0xFF3A3A3C);
// const _previousColor = Color(0xFF16A34A);
// const _messageColor = Color(0xFFA855F7);

/// Diameter of each round button (full-profile mockup: 58 on 390 wide).
const kProfileActionButtonSize = 58.0;
// const kProfileActionButtonSize = 56.0;

/// The 4 buttons floating over the profile: Cancel · Previous · Message ·
/// Save. UI-only for now — Cancel/Save move to the next profile, Previous
/// goes back one, Message does nothing yet.
class ProfileActionButtons extends StatelessWidget {
  const ProfileActionButtons({
    required this.onCancel,
    required this.onPrevious,
    required this.onMessage,
    required this.onSave,
    super.key,
  });

  final VoidCallback onCancel;

  /// Null → disabled (first profile).
  final VoidCallback? onPrevious;
  final VoidCallback onMessage;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    // Full-profile mockup: 33.5 side margins, ≈30 gaps (centres at 62.5,
    // 151, 239, 327.5). Previously spaceEvenly (equal margins and gaps).
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 33.5.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _RoundAction(
            icon: Icons.close,
            color: _cancelColor,
            tooltip: 'Cancel',
            onTap: onCancel,
          ),
          _RoundAction(
            icon: Icons.undo_rounded,
            color: _previousColor,
            tooltip: 'Previous',
            onTap: onPrevious,
          ),
          _RoundAction(
            icon: Icons.send_outlined,
            // Mockup's paper plane points up-right.
            iconTurns: -0.1,
            color: _messageColor,
            tooltip: 'Message',
            onTap: onMessage,
          ),
          _RoundAction(
            icon: Icons.check,
            color: AppColors.primaryColor,
            tooltip: 'Save',
            onTap: onSave,
          ),
        ],
      ),
    );
    // Previous centred row with fixed 20 gaps:
    // return Row(
    //   mainAxisAlignment: MainAxisAlignment.center,
    //   children: [
    //     _RoundAction(
    //       icon: Icons.close,
    //       color: _cancelColor,
    //       tooltip: 'Cancel',
    //       onTap: onCancel,
    //     ),
    //     SizedBox(width: 20.w),
    //     _RoundAction(
    //       icon: Icons.undo,
    //       color: _previousColor,
    //       tooltip: 'Previous',
    //       onTap: onPrevious,
    //     ),
    //     SizedBox(width: 20.w),
    //     _RoundAction(
    //       icon: Icons.send_outlined,
    //       color: _messageColor,
    //       tooltip: 'Message',
    //       onTap: onMessage,
    //     ),
    //     SizedBox(width: 20.w),
    //     _RoundAction(
    //       icon: Icons.check,
    //       color: AppColors.primaryColor,
    //       tooltip: 'Save',
    //       onTap: onSave,
    //     ),
    //   ],
    // );
  }
}

class _RoundAction extends StatelessWidget {
  const _RoundAction({
    required this.icon,
    required this.color,
    required this.tooltip,
    required this.onTap,
    this.iconTurns = 0,
  });

  final IconData icon;
  final double iconTurns;
  final Color color;
  final String tooltip;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    return Tooltip(
      message: tooltip,
      child: Material(
        color: enabled ? color : color.withValues(alpha: 0.4),
        shape: const CircleBorder(),
        elevation: enabled ? 6 : 0,
        shadowColor: Colors.black45,
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: SizedBox(
            width: kProfileActionButtonSize.r,
            height: kProfileActionButtonSize.r,
            child: RotationTransition(
              turns: AlwaysStoppedAnimation(iconTurns),
              child: Icon(icon, color: Colors.white, size: 22.r),
            ),
          ),
          // child: SizedBox(
          //   width: 54.r,
          //   height: 54.r,
          //   child: Icon(icon, color: Colors.white, size: 26.r),
          // ),
        ),
      ),
    );
  }
}
