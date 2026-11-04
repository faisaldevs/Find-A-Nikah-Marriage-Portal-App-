import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// Standard skeleton-loading sweep, so every first load looks the same.
/// Wrap a layout of [AppShimmerBox]es that mirrors the real content.
class AppShimmer extends StatelessWidget {
  const AppShimmer({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) => Shimmer.fromColors(
    baseColor: Colors.grey.shade200,
    highlightColor: Colors.grey.shade50,
    child: child,
  );
}

/// One placeholder block inside an [AppShimmer].
class AppShimmerBox extends StatelessWidget {
  const AppShimmerBox({
    required this.width,
    required this.height,
    super.key,
    this.radius = 4,
  });

  final double width;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) => Container(
    width: width,
    height: height,
    decoration: BoxDecoration(
      // Any opaque colour — Shimmer paints over it.
      color: Colors.white,
      borderRadius: BorderRadius.circular(radius),
    ),
  );
}
