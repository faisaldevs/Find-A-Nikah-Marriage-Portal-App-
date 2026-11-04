import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// The member's own photo with a disk cache (like Explore's cards), so
/// Menu, Edit profile and Preview show it at once on later visits.
/// `AppPhoto`'s plain `Image.network` refetched it every time, with a
/// spinner. Grey while loading; grey + icon when the URL fails.
class ProfilePhoto extends StatelessWidget {
  const ProfilePhoto(this.url, {super.key, this.fit = BoxFit.cover});

  final String url;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    if (url.isEmpty) return const _Missing();
    return CachedNetworkImage(
      imageUrl: url,
      fit: fit,
      fadeInDuration: const Duration(milliseconds: 150),
      placeholder: (_, _) => ColoredBox(color: Colors.grey.shade200),
      errorWidget: (_, _, _) => const _Missing(),
    );
  }
}

/// Downloads [url] into the photo cache ahead of time (errors ignored).
void precacheProfilePhoto(BuildContext context, String url) {
  if (url.isEmpty) return;
  precacheImage(
    CachedNetworkImageProvider(url),
    context,
    onError: (_, _) {},
  ).ignore();
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
