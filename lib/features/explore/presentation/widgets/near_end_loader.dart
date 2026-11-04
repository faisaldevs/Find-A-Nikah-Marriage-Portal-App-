import 'package:flutter/widgets.dart';

/// Owns the [ScrollController] of a paged strip or grid and asks for the
/// next page when it is within [threshold] of its end: on scroll, once at
/// first layout, and each time the list grows ([itemCount] changes). The
/// last one matters: a page landing can leave a short strip as short as it
/// was (the loading shimmer swaps for real cards), so no scroll event
/// follows. A failed page doesn't change [itemCount], so it isn't retried
/// until the user scrolls again.
class NearEndLoader extends StatefulWidget {
  const NearEndLoader({
    required this.builder,
    required this.threshold,
    required this.itemCount,
    this.onLoadMore,
    this.loading = false,
    super.key,
  });

  final Widget Function(ScrollController controller) builder;
  final double threshold;
  final int itemCount;
  final VoidCallback? onLoadMore;
  final bool loading;

  @override
  State<NearEndLoader> createState() => _NearEndLoaderState();
}

class _NearEndLoaderState extends State<NearEndLoader> {
  final _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_check);
    _checkAfterLayout();
  }

  @override
  void didUpdateWidget(NearEndLoader old) {
    super.didUpdateWidget(old);
    if (old.itemCount != widget.itemCount) _checkAfterLayout();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _checkAfterLayout() => WidgetsBinding.instance.addPostFrameCallback(
    (_) => _check(),
  );

  void _check() {
    final load = widget.onLoadMore;
    if (!mounted || load == null || widget.loading) return;
    if (!_controller.hasClients) return;
    final position = _controller.position;
    if (!position.hasContentDimensions) return;
    if (position.extentAfter < widget.threshold) load();
  }

  @override
  Widget build(BuildContext context) => widget.builder(_controller);
}
