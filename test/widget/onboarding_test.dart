import 'package:flutter_test/flutter_test.dart';
import 'package:numero/core/theme/theme_presets.dart';
import 'package:numero/data/models/daily_goal.dart';
import 'package:numero/features/onboarding/onboarding_controller.dart';

void main() {
  group('OnboardingController', () {
    test('starts at step 0', () {
      final c = OnboardingController();
      expect(c.state.step, 0);
    });

    test('advances and goes back', () {
      final c = OnboardingController();
      c.next();
      c.next();
      expect(c.state.step, 2);
      c.back();
      expect(c.state.step, 1);
    });

    test('setters update state', () {
      final c = OnboardingController()
        ..setTheme(ThemePreset.forest)
        ..setName('  Ben  ')
        ..setGoal(DailyGoal.serious)
        ..completeTutorial();
      expect(c.state.themePreset, ThemePreset.forest);
      expect(c.state.name, 'Ben');
      expect(c.state.dailyGoal, DailyGoal.serious);
      expect(c.state.gestureTutorialDone, isTrue);
    });

    test('back at step 0 is a no-op', () {
      final c = OnboardingController()..back();
      expect(c.state.step, 0);
    });
  });
}
