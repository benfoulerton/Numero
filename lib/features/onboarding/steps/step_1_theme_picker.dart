/// Step 1 — Theme picker (Spec §4.2 step 1).
///
/// Six swatches. Tapping one instantly re-themes the app via [AnimatedTheme].
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/haptic_service.dart';
import '../../../core/theme/theme_presets.dart';
import '../../../core/theme/theme_provider.dart';
import '../onboarding_controller.dart';

class StepThemePicker extends ConsumerWidget {
  const StepThemePicker({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onboardingControllerProvider);
    final controller = ref.read(onboardingControllerProvider.notifier);
    final themeCtl = ref.read(themeControllerProvider.notifier);
    final haptic = ref.read(hapticServiceProvider);
    final text = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Make it yours.',
            style: text.displaySmall?.copyWith(fontWeight: FontWeight.w800)),
        const SizedBox(height: 8),
        Text('Pick a theme. You can change it later.',
            style: text.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant)),
        const SizedBox(height: 24),
        Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1.05,
            ),
            itemCount: ThemePreset.values.length,
            itemBuilder: (context, i) {
              final preset = ThemePreset.values[i];
              final selected = state.themePreset == preset;
              return _ThemeSwatch(
                preset: preset,
                selected: selected,
                onTap: () {
                  haptic.selection();
                  controller.setTheme(preset);
                  // Re-theme immediately so the user sees the effect.
                  themeCtl.setPreset(preset);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class _ThemeSwatch extends StatelessWidget {
  const _ThemeSwatch({
    required this.preset,
    required this.selected,
    required this.onTap,
  });

  final ThemePreset preset;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return Semantics(
      button: true,
      selected: selected,
      label: '${preset.label} theme',
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        decoration: BoxDecoration(
          color: preset.seed.withValues(alpha: 0.16),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: selected ? colors.primary : Colors.transparent,
            width: 3,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(24),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: preset.seed,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    alignment: Alignment.center,
                    child: Text(preset.emoji,
                        style: const TextStyle(fontSize: 28)),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(preset.label,
                          style: text.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w700)),
                      const SizedBox(height: 2),
                      Text(preset.description,
                          style: text.bodySmall?.copyWith(
                              color: colors.onSurfaceVariant)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
