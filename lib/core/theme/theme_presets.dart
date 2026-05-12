/// Theme presets (Spec §12.2).
///
/// Each preset has a seed colour. The ColorScheme is generated via
/// [ColorScheme.fromSeed] with `DynamicSchemeVariant.expressive`.
library;

import 'package:flutter/material.dart';

enum ThemePreset {
  ocean(
    id: 'ocean',
    label: 'Ocean',
    description: 'Cool, calm, focused',
    seed: Color(0xFF0077B6),
    emoji: '🌊',
  ),
  forest(
    id: 'forest',
    label: 'Forest',
    description: 'Warm green, natural, grounded',
    seed: Color(0xFF2D6A4F),
    emoji: '🌳',
  ),
  sunset(
    id: 'sunset',
    label: 'Sunset',
    description: 'Energetic, warm, motivating',
    seed: Color(0xFFE76F51),
    emoji: '🌅',
  ),
  synthwave(
    id: 'synthwave',
    label: 'Synthwave',
    description: 'Vibrant, bold, high-energy',
    seed: Color(0xFFFF006E),
    emoji: '🌆',
  ),
  mono(
    id: 'mono',
    label: 'Mono',
    description: 'Low-saturation, minimal distraction',
    seed: Color(0xFF1F2937),
    emoji: '⚫',
  ),
  system(
    id: 'system',
    label: 'System',
    description: 'Match your phone wallpaper',
    seed: Color(0xFF4A5AFA), // fallback if dynamic_color unavailable
    emoji: '🎨',
  );

  const ThemePreset({
    required this.id,
    required this.label,
    required this.description,
    required this.seed,
    required this.emoji,
  });

  final String id;
  final String label;
  final String description;
  final Color seed;
  final String emoji;

  /// Whether this preset should derive its colours from the platform
  /// (Android 12+ wallpaper-based dynamic colour).
  bool get isDynamic => this == ThemePreset.system;

  static ThemePreset fromId(String? id) {
    if (id == null) return ThemePreset.ocean;
    return ThemePreset.values.firstWhere(
      (p) => p.id == id,
      orElse: () => ThemePreset.ocean,
    );
  }
}
