import 'package:find_a_nikah/core/ui/ui.dart';
import 'package:flutter/material.dart';

/// Full-screen picture with pinch-zoom; tap the picture or ✕ to close.
/// [source] is an `http(s)` URL or, while a send is in flight, a file path.
Future<void> showImageViewer(BuildContext context, String source) {
  return Navigator.of(context, rootNavigator: true).push<void>(
    PageRouteBuilder<void>(
      opaque: false,
      barrierColor: Colors.black,
      pageBuilder: (_, _, _) => _ImageViewer(source: source),
      transitionsBuilder: (_, animation, _, child) =>
          FadeTransition(opacity: animation, child: child),
    ),
  );
}

class _ImageViewer extends StatelessWidget {
  const _ImageViewer({required this.source});

  final String source;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: InteractiveViewer(
                maxScale: 5,
                child: Center(child: AppPhoto(source, fit: BoxFit.contain)),
              ),
            ),
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.topRight,
              child: IconButton(
                tooltip: 'Close',
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close_rounded, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
