import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:numero/core/theme/theme_provider.dart';
import 'package:numero/features/lesson/interactions/interaction_types.dart';
import 'package:numero/features/lesson/interactions/multiple_choice.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('Multiple choice reports the chosen option', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    AnswerResult? captured;

    await tester.pumpWidget(
      ProviderScope(
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
        child: MaterialApp(
          home: Scaffold(
            body: MultipleChoice(
              config: const McqConfig(
                prompt: 'Which is the largest?',
                options: ['12', '7', '21', '15'],
                correctIndex: 2,
              ),
              onAnswer: (r) => captured = r,
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('21'));
    await tester.pump();
    await tester.tap(find.widgetWithText(FilledButton, 'Check'));
    await tester.pump();

    expect(captured?.correct, isTrue);
    expect(captured?.userAnswer, '21');
  });
}
