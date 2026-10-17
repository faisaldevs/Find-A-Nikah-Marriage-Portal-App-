import 'dart:io';

import 'package:flutter/material.dart';

/// A user photo that may be a local file (just picked) or a URL (already
/// uploaded, e.g. prefilled profile photos). Shows a spinner while a
/// network image loads and a placeholder icon if it fails.
class AppPhoto extends StatelessWidget {
  const AppPhoto(this.source, {super.key, this.fit = BoxFit.cover});

  /// Local file path or `http(s)://` URL.
  final String source;
  final BoxFit fit;

  static bool isRemote(String source) =>
      source.startsWith('http://') || source.startsWith('https://');

  @override
  Widget build(BuildContext context) {
    if (!isRemote(source)) {
      return Image.file(
        File(source),
        fit: fit,
        errorBuilder: (_, _, _) => const _Broken(),
      );
    }
    return Image.network(
      source,
      fit: fit,
      loadingBuilder: (context, child, progress) => progress == null
          ? child
          : ColoredBox(
              color: Colors.grey.shade100,
              child: const Center(
                child: SizedBox.square(
                  dimension: 22,
                  child: CircularProgressIndicator(strokeWidth: 2.5),
                ),
              ),
            ),
      errorBuilder: (_, _, _) => const _Broken(),
    );
  }
}

class _Broken extends StatelessWidget {
  const _Broken();

  @override
  Widget build(BuildContext context) => ColoredBox(
    color: Colors.grey.shade200,
    child: Center(
      child: Icon(Icons.broken_image_outlined, color: Colors.grey.shade500),
    ),
  );
}
