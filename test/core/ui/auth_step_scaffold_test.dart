import 'package:find_a_nikah/features/auth/presentation/widgets/auth_step_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_app.dart';

void main() {
  testWidgets('shows the Continue loading state while a signup step submits', (
    tester,
  ) async {
    await tester.pumpPage(
      const AuthStepScaffold(
        title: 'Create your password',
        body: SizedBox.shrink(),
        onContinue: null,
        isLoading: true,
        loadingLabel: 'Creating account...',
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('Creating account...'), findsOneWidget);

    final button = tester.widget<FilledButton>(find.byType(FilledButton));
    expect(button.onPressed, isNull);
    expect(
      button.style!.backgroundColor!.resolve({WidgetState.disabled}),
      isNot(Colors.transparent),
    );
  });
}
