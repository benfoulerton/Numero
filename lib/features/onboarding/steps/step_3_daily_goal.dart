/// Step 3 — Daily goal (Spec §4.2 step 3).
///
/// Four large tappable cards. No default selection.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/haptic_service.dart';
import '../../../data/models/daily_goal.dart';
import '../onboarding_controller.dart';

class StepDailyGoal extends ConsumerWidget {
  const StepDailyGoal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onboardingControllerProvider);
    final controller = ref.read(onboardingControllerProvider.notifier);
    final haptic = ref.read(hapticServiceProvider);
    final text = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Pick a daily goal.',
            style: text.displaySmall?.copyWith(fontWeight: FontWeight.w800)),
        const SizedBox(height: 8),
        Text('You can change this any time.',
            style:
                text.bodyLarge?.copyWith(color: colors.onSurfaceVariant)),
        const SizedBox(height: 24),
        Expanded(
          child: ListView.separated(
            itemCount: DailyGoal.values.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, i) {
              final goal = DailyGoal.values[i];
              final selected = state.dailyGoal == goal;
              return _GoalCard(
                goal: goal,
                selected: selected,
                onTap: () {
                  haptic.selection();
                  controller.setGoal(goal);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class _GoalCard extends StatelessWidget {
  const _GoalCard({
    required this.goal,
    required this.selected,
    required this.onTap,
  });

  final DailyGoal goal;
  final bool selected;
  final VoidCallback onTap;

  IconData get _icon => switch (goal) {
        DailyGoal.casual => Icons.local_cafe_rounded,
        DailyGoal.regular => Icons.directions_walk_rounded,
        DailyGoal.serious => Icons.directions_run_rounded,
        DailyGoal.intense => Icons.bolt_rounded,
      };

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      decoration: BoxDecoration(
        color: selected
            ? colors.primaryContainer
            : colors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: selected ? colors.primary : Colors.transparent,
          width: 3,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: selected
                        ? colors.primary
                        : colors.surfaceContainerHigh,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    _icon,
                    color: selected
                        ? colors.onPrimary
                        : colors.onSurfaceVariant,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(goal.label,
                          style: text.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w700)),
                      const SizedBox(height: 2),
                      Text('${goal.minutes} min — ${goal.description}',
                          style: text.bodyMedium?.copyWith(
                              color: colors.onSurfaceVariant)),
                    ],
                  ),
                ),
                if (selected)
                  Icon(Icons.check_circle_rounded, color: colors.primary),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
