/// Riverpod providers governing the app's theme.
///
/// Persists the selected preset and brightness mode in SharedPreferences
/// (Spec §12.2: persist the selected theme).
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'theme_presets.dart';

const _kPresetKey = 'theme_preset';
const _kBrightnessKey = 'theme_brightness'; // 'light' | 'dark' | 'system'

/// Bound at app start in [main] via [ProviderScope.overrides].
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences must be overridden at startup');
});

class ThemeState {
  const ThemeState({
    required this.preset,
    required this.brightness,
  });

  final ThemePreset preset;
  final ThemeMode brightness;

  ThemeState copyWith({ThemePreset? preset, ThemeMode? brightness}) =>
      ThemeState(
        preset: preset ?? this.preset,
        brightness: brightness ?? this.brightness,
      );
}

class ThemeController extends StateNotifier<ThemeState> {
  ThemeController(this._prefs) : super(_loadInitial(_prefs));

  final SharedPreferences _prefs;

  static ThemeState _loadInitial(SharedPreferences prefs) {
    final preset = ThemePreset.fromId(prefs.getString(_kPresetKey));
    final brightnessId = prefs.getString(_kBrightnessKey) ?? 'system';
    final mode = switch (brightnessId) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
    return ThemeState(preset: preset, brightness: mode);
  }

  Future<void> setPreset(ThemePreset preset) async {
    state = state.copyWith(preset: preset);
    await _prefs.setString(_kPresetKey, preset.id);
  }

  Future<void> setBrightness(ThemeMode mode) async {
    state = state.copyWith(brightness: mode);
    final id = switch (mode) {
      ThemeMode.light => 'light',
      ThemeMode.dark => 'dark',
      ThemeMode.system => 'system',
    };
    await _prefs.setString(_kBrightnessKey, id);
  }
}

final themeControllerProvider =
    StateNotifierProvider<ThemeController, ThemeState>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return ThemeController(prefs);
});
