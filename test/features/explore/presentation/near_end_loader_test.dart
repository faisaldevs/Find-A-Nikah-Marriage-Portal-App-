import 'package:find_a_nikah/features/explore/presentation/widgets/near_end_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// A strip fed 3 items per page, like the server paging a short feed.
/// Regression: with the loading shimmer swapped for real cards the strip
/// is no wider than before, so no scroll event followed and paging stalled
/// halfway (6 of 8 profiles shown).
class _Strip extends StatefulWidget {
  const _Strip({required this.total, this.failFirstMore = false});

  final int total;
  final bool failFirstMore;

  @override
  State<_Strip> createState() => _StripState();
}

class _StripState extends State<_Strip> {
  int shown = 3;
  bool loading = false;
  int requests = 0;
  bool _failed = false;

  Future<void> _more() async {
    requests++;
    setState(() => loading = true);
    await Future<void>.delayed(const Duration(milliseconds: 50));
    if (widget.failFirstMore && !_failed) {
      _failed = true;
      setState(() => loading = false);
      return;
    }
    setState(() {
      shown = (shown + 3).clamp(0, widget.total);
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: SizedBox(
        height: 100,
        child: NearEndLoader(
          threshold: 200,
          itemCount: shown,
          loading: loading,
          onLoadMore: shown < widget.total ? _more : null,
          builder: (controller) => ListView.builder(
            controller: controller,
            scrollDirection: Axis.horizontal,
            itemCount: shown + (loading ? 1 : 0),
            itemBuilder: (_, i) => SizedBox(width: 90, child: Text('item $i')),
          ),
        ),
      ),
    );
  }
}

void main() {
  testWidgets('a short strip keeps loading pages until it is full', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(2000, 400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: _Strip(total: 8))),
    );
    await tester.pumpAndSettle();
    final state = tester.state<_StripState>(find.byType(_Strip));
    expect(state.shown, 8);
    expect(state.requests, 2, reason: '3 -> 6 -> 8');
  });

  testWidgets('a failed page is not retried until the user scrolls', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(2000, 400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: _Strip(total: 8, failFirstMore: true)),
      ),
    );
    await tester.pumpAndSettle();
    final state = tester.state<_StripState>(find.byType(_Strip));
    expect(state.requests, 1, reason: 'one attempt, no retry loop');
    expect(state.shown, 3);
  });

  testWidgets('a long strip waits until the user scrolls near its end', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(400, 400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: _Strip(total: 30))),
    );
    await tester.pumpAndSettle();
    final state = tester.state<_StripState>(find.byType(_Strip));
    // 3 items = 270 wide, screen 400: too short, so it loads until it
    // overflows the screen by more than the threshold, then stops.
    final loadedWhileShort = state.requests;
    expect(state.shown * 90, greaterThan(400 + 200));
    await tester.drag(find.byType(ListView), const Offset(-400, 0));
    await tester.pumpAndSettle();
    expect(state.requests, greaterThan(loadedWhileShort));
  });
}
