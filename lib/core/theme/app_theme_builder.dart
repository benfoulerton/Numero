/// Builds [ThemeData] from a [ThemePreset], a [Brightness], and
/// (optionally) a system [ColorScheme] from `dynamic_color`.
///
/// Spec §12.1: Material 3 Expressive — `useMaterial3: true`, surface tone
/// containers, spring-based motion. Spec §12.3: typography scale.
library;

import 'package:flutter/material.dart';

import 'theme_presets.dart';
import 'typography.dart';

class AppThemeBuilder {
  const AppThemeBuilder._();

  static ThemeData build({
    required ThemePreset preset,
    required Brightness brightness,
    ColorScheme? systemScheme,
  }) {
    final ColorScheme scheme;
    if (preset.isDynamic && systemScheme != null) {
      scheme = systemScheme;
    } else {
      scheme = ColorScheme.fromSeed(
        seedColor: preset.seed,
        brightness: brightness,
        // Material 3 Expressive variant — vibrant, characterful palette.
        dynamicSchemeVariant: DynamicSchemeVariant.expressive,
      );
    }

    final base = ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      brightness: brightness,
      scaffoldBackgroundColor: scheme.surface,
      splashFactory: InkSparkle.splashFactory,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: PredictiveBackPageTransitionsBuilder(),
        },
      ),
    );

    return base.copyWith(
      textTheme: AppTypography.build(base.textTheme, scheme.onSurface),
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: AppTypography.build(base.textTheme, scheme.onSurface)
            .titleLarge,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          textStyle: AppTypography.build(base.textTheme, scheme.onPrimary)
              .labelLarge,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: scheme.surfaceContainerLow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: scheme.surfaceContainer,
        indicatorColor: scheme.secondaryContainer,
        height: 72,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return TextStyle(
              color: scheme.onSurface,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            );
          }
          return TextStyle(
            color: scheme.onSurfaceVariant,
            fontWeight: FontWeight.w500,
            fontSize: 12,
          );
        }),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: scheme.surfaceContainerHigh,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: scheme.inverseSurface,
        contentTextStyle: TextStyle(color: scheme.onInverseSurface),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: scheme.primary,
        inactiveTrackColor: scheme.surfaceContainerHighest,
        thumbColor: scheme.primary,
        overlayColor: scheme.primary.withValues(alpha: 0.12),
        valueIndicatorColor: scheme.primary,
        trackHeight: 6,
      ),
    );
  }
}     
