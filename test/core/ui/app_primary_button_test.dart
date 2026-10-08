import 'package:find_a_nikah/core/ui/components/app_primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_app.dart';

void main() {
  testWidgets('loading state shows progress and keeps the button opaque', (
    tester,
  ) async {
    await tester.pumpPage(
      Scaffold(
        body: AppPrimaryButton(
          label: 'Sign In',
          isLoading: true,
          loadingLabel: 'Signing in...',
          onPressed: () {},
        ),
      ),
    );

    final button = tester.widget<FilledButton>(find.byType(FilledButton));
    final background = button.style!.backgroundColor!.resolve({
      WidgetState.disabled,
    });

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('Signing in...'), findsOneWidget);
    expect(button.onPressed, isNull);
    expect(background, isNot(Colors.transparent));
  });
}
