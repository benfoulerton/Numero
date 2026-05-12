import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:numero/core/theme/theme_provider.dart';
import 'package:numero/features/lesson/interactions/interaction_types.dart';
import 'package:numero/features/lesson/interactions/numeric_free_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('Numeric keypad submits and reports correct/incorrect',
      (tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    AnswerResult? captured;

    await tester.pumpWidget(
      ProviderScope(
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
        child: MaterialApp(
          home: Scaffold(
            body: NumericFreeResponse(
              config: const NumericResponseConfig(
                prompt: 'What is 6 × 7?',
                correctValue: 42,
              ),
              onAnswer: (r) => captured = r,
            ),
          ),
        ),
      ),
    );

    // Type "42".
    await tester.tap(find.text('4'));
    await tester.pump();
    await tester.tap(find.text('2'));
    await tester.pump();

    // Submit.
    await tester.tap(find.widgetWithText(FilledButton, 'Check'));
    await tester.pump();

    expect(captured, isNotNull);
    expect(captured!.correct, isTrue);
    expect(captured!.userAnswer, '42');
  });
}
