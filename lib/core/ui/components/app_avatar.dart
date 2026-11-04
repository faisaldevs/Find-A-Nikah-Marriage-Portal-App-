import 'package:find_a_nikah/core/ui/components/app_photo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

/// Round photo with an optional green "online" dot at the bottom right.
/// [size] is in design points.
class AppAvatar extends StatelessWidget {
  const AppAvatar(
    this.photoUrl, {
    required this.size,
    this.online = false,
    super.key,
  });

  final String photoUrl;
  final double size;
  final bool online;

  static const _onlineGreen = Color(0xFF22C55E);

  @override
  Widget build(BuildContext context) {
    final s = size.w;
    final dot = (size * 0.26).w;
    return SizedBox.square(
      dimension: s,
      child: Stack(
        children: [
          ClipOval(
            child: SizedBox.square(dimension: s, child: AppPhoto(photoUrl)),
          ),
          if (online)
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: dot,
                height: dot,
                decoration: BoxDecoration(
                  color: _onlineGreen,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2.w),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
