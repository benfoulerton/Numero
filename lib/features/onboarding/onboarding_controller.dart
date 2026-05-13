/// Onboarding step-state controller.
///
/// Three steps: 0 = welcome, 1 = name, 2 = theme picker.
/// Daily goal selection has been moved to the Profile screen — keeping
/// onboarding short means users reach their first lesson faster.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/theme_presets.dart';

class OnboardingState {
  const OnboardingState({
    required this.step,
    this.themePreset,
    this.name = '',
  });

  /// 0 = welcome, 1 = name, 2 = theme.
  final int step;
  final ThemePreset? themePreset;
  final String name;

  OnboardingState copyWith({
    int? step,
    ThemePreset? themePreset,
    String? name,
  }) =>
      OnboardingState(
        step: step ?? this.step,
        themePreset: themePreset ?? this.themePreset,
        name: name ?? this.name,
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
}

final onboardingControllerProvider =
    StateNotifierProvider<OnboardingController, OnboardingState>((ref) {
  return OnboardingController();
});
