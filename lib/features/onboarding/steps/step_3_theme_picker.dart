/// Step 3 — Theme picker.
///
/// Six theme tiles in a 2-column grid. Tapping a tile re-themes the app
/// live. The Let's go button is disabled until a theme is selected.
///
/// Important layout notes (fixes a 3.4px overflow seen in earlier builds):
///   • The grid uses a generous childAspectRatio (wider than tall) so the
///     description never wraps onto a third line.
///   • Description text is capped to two lines with ellipsis as a safety
///     net on very narrow devices.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/haptic_service.dart';
import '../../../core/theme/theme_presets.dart';
import '../../../core/theme/theme_provider.dart';
import '../../../core/widgets/numero_button.dart';
import '../onboarding_controller.dart';

class StepThemePicker extends ConsumerWidget {
  const StepThemePicker({super.key, required this.onContinue});

  /// `null` disables the Let's go button.
  final VoidCallback? onContinue;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onboardingControllerProvider);
    final controller = ref.read(onboardingControllerProvider.notifier);
    final themeCtl = ref.read(themeControllerProvider.notifier);
    final haptic = ref.read(hapticServiceProvider);
    final text = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Choose your theme',
            style: text.displaySmall?.copyWith(
              fontWeight: FontWeight.w800,
              height: 1.05,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'You can change it later.',
            style: text.bodyLarge?.copyWith(color: colors.onSurfaceVariant),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.zero,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                // Wider than tall — leaves enough vertical room for the
                // two-line description without overflowing.
                childAspectRatio: 0.82,
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
                    themeCtl.setPreset(preset);
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          NumeroButton(
            label: "Let's go",
            icon: Icons.arrow_forward_rounded,
            onPressed: onContinue,
          ),
        ],
      ),
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
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: selected ? colors.primary : Colors.transparent,
            width: 3,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(22),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: preset.seed,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      preset.emoji,
                      style: const TextStyle(fontSize: 26),
                    ),
                  ),
                  // Title + description grouped at the bottom. Both use
                  // maxLines + ellipsis so a narrow device cannot cause
                  // the card to overflow.
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        preset.label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: text.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        preset.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: text.bodySmall?.copyWith(
                          color: colors.onSurfaceVariant,
                          height: 1.25,
                        ),
                      ),
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
