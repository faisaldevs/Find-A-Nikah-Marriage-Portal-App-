import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

/// Network profile photo with a grey placeholder until the first frame (and
/// if it fails), so a slow or broken image never leaves a blank hole.
class ProfilePhoto extends StatelessWidget {
  const ProfilePhoto({super.key, required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      url,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      // frameBuilder (not loadingBuilder): loadingBuilder only fires once
      // bytes arrive, leaving the area blank before that.
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) =>
          frame == null && !wasSynchronouslyLoaded
          ? const _PhotoPlaceholder()
          : child,
      errorBuilder: (_, _, _) => const _PhotoPlaceholder(),
    );
  }
}

class _PhotoPlaceholder extends StatelessWidget {
  const _PhotoPlaceholder();

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.grey.shade300,
      child: Center(
        child: Icon(Icons.person, size: 64.r, color: Colors.white),
      ),
    );
  }
}
