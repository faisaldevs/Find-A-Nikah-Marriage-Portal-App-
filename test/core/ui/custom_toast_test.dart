import 'package:find_a_nikah/core/error/failure.dart';
import 'package:find_a_nikah/core/ui/states/custom_toast.dart';
import 'package:find_a_nikah/core/ui/states/failure_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:toastification/toastification.dart';

void main() {
  testWidgets('API failure message is displayed as the toast title', (
    tester,
  ) async {
    late BuildContext toastContext;
    await tester.pumpWidget(
      ToastificationWrapper(
        child: MaterialApp(
          home: Builder(
            builder: (context) {
              toastContext = context;
              return Scaffold(
                body: TextButton(
                  onPressed: () => showFailureToast(
                    toastContext,
                    const ApiResponseFailure(
                      fallback: ServerFailure(),
                      message: 'Invalid verification code',
                    ),
                  ),
                  child: const Text('Show toast'),
                ),
              );
            },
          ),
        ),
      ),
    );

    await tester.tap(find.text('Show toast'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Invalid verification code'), findsOneWidget);
    expect(find.text('Something went wrong on our side'), findsNothing);

    await tester.pump(const Duration(seconds: 3));
    await tester.pump(const Duration(milliseconds: 300));
  });

  testWidgets('shows title and description in the toast overlay', (
    tester,
  ) async {
    late BuildContext toastContext;
    await tester.pumpWidget(
      ToastificationWrapper(
        child: MaterialApp(
          home: Builder(
            builder: (context) {
              toastContext = context;
              return Scaffold(
                body: TextButton(
                  onPressed: () => CustomToast.showError(
                    toastContext,
                    'Sign-in failed',
                    description: 'Invalid credentials',
                  ),
                  child: const Text('Show toast'),
                ),
              );
            },
          ),
        ),
      ),
    );

    await tester.tap(find.text('Show toast'));
    await tester.pump();
    expect(toastification.managers.values.first.notifications, hasLength(1));
    expect(
      toastification.managers.values.first.listGlobalKey.currentState,
      isNotNull,
    );
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Sign-in failed'), findsOneWidget);
    expect(find.text('Invalid credentials'), findsOneWidget);

    await tester.pump(const Duration(seconds: 3));
    await tester.pump(const Duration(milliseconds: 300));
  });
}
