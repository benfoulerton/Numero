import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:numero/core/theme/app_theme_builder.dart';
import 'package:numero/core/theme/theme_presets.dart';

void main() {
  group('ThemePreset', () {
    test('round-trips through fromId', () {
      for (final p in ThemePreset.values) {
        expect(ThemePreset.fromId(p.id), p);
      }
    });

    test('falls back to ocean for unknown ids', () {
      expect(ThemePreset.fromId(null), ThemePreset.ocean);
      expect(ThemePreset.fromId('not-a-real-preset'), ThemePreset.ocean);
    });

    test('system preset is the only dynamic one', () {
      for (final p in ThemePreset.values) {
        expect(p.isDynamic, p == ThemePreset.system);
      }
    });
  });

  group('AppThemeBuilder', () {
    test('builds light + dark schemes for every preset', () {
      for (final p in ThemePreset.values) {
        for (final b in [Brightness.light, Brightness.dark]) {
          final theme = AppThemeBuilder.build(preset: p, brightness: b);
          expect(theme.useMaterial3, isTrue);
          expect(theme.colorScheme.brightness, b);
        }
      }
    });
  });
}
