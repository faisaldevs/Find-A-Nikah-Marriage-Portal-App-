import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// Card photo with a disk cache, so a cached feed opens with its photos
/// too (plain `Image.network` refetched them every launch). Grey while
/// loading; grey + icon when the URL is empty or fails.
class ExplorePhoto extends StatelessWidget {
  const ExplorePhoto(this.url, {super.key});

  final String url;

  @override
  Widget build(BuildContext context) {
    if (url.isEmpty) return const _Missing();
    return CachedNetworkImage(
      imageUrl: url,
      fit: BoxFit.cover,
      placeholder: (_, _) => ColoredBox(color: Colors.grey.shade200),
      errorWidget: (_, _, _) => const _Missing(),
    );
  }
}

class _Missing extends StatelessWidget {
  const _Missing();

  @override
  Widget build(BuildContext context) => ColoredBox(
    color: Colors.grey.shade300,
    child: Center(
      child: Icon(Icons.person_outline, color: Colors.grey.shade500),
    ),
  );
}
