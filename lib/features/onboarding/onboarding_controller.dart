/// Onboarding step-state controller.
///
/// Spec §4.2: 4 steps, ≤ 90 seconds total. Progress saved locally; account
/// creation prompted after lesson 3 (not in v1).
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/theme_presets.dart';
import '../../data/models/daily_goal.dart';

class OnboardingState {
  const OnboardingState({
    required this.step,
    this.themePreset,
    this.name = '',
    this.dailyGoal,
    this.gestureTutorialDone = false,
  });

  /// 0 = theme picker, 1 = name, 2 = daily goal, 3 = gesture tutorial.
  final int step;
  final ThemePreset? themePreset;
  final String name;
  final DailyGoal? dailyGoal;
  final bool gestureTutorialDone;

  OnboardingState copyWith({
    int? step,
    ThemePreset? themePreset,
    String? name,
    DailyGoal? dailyGoal,
    bool? gestureTutorialDone,
  }) =>
      OnboardingState(
        step: step ?? this.step,
        themePreset: themePreset ?? this.themePreset,
        name: name ?? this.name,
        dailyGoal: dailyGoal ?? this.dailyGoal,
        gestureTutorialDone: gestureTutorialDone ?? this.gestureTutorialDone,
      );
}

class OnboardingController extends StateNotifier<OnboardingState> {
  OnboardingController() : super(const OnboardingState(step: 0));

  void next() => state = state.copyWith(step: state.step + 1);
  void back() {
    if (state.step > 0) state = state.copyWith(step: state.step - 1);
  }

  void setTheme(ThemePreset preset) =>
      state = state.copyWith(themePreset: preset);

  void setName(String name) => state = state.copyWith(name: name.trim());

  void setGoal(DailyGoal goal) => state = state.copyWith(dailyGoal: goal);

  void completeTutorial() =>
      state = state.copyWith(gestureTutorialDone: true);
}

final onboardingControllerProvider =
    StateNotifierProvider<OnboardingController, OnboardingState>((ref) {
  return OnboardingController();
});
