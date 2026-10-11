import 'package:find_a_nikah/core/ui/ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const _sections = [
  [('a', 'A'), ('b', 'B'), ('c', 'C')],
  [('d', 'D'), ('e', 'E')],
];

void main() {
  group('WizardHeader', () {
    testWidgets('shows the back arrow by default', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: WizardHeader(title: 'Title')),
      );

      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    });

    testWidgets('showBack: false removes it entirely', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: WizardHeader(title: 'Title', showBack: false),
        ),
      );

      expect(find.byIcon(Icons.arrow_back), findsNothing);
    });
  });

  group('WizardProgress.previousPathFor', () {
    test('steps back within a section', () {
      expect(WizardProgress.previousPathFor(_sections, 'c'), 'b');
    });

    test('crosses a section boundary', () {
      expect(WizardProgress.previousPathFor(_sections, 'd'), 'c');
    });

    test("the flow's first page has no previous", () {
      expect(WizardProgress.previousPathFor(_sections, 'a'), isNull);
    });

    test('a path outside the flow has no previous', () {
      expect(WizardProgress.previousPathFor(_sections, 'z'), isNull);
    });
  });
}
