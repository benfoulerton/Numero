/// Onboarding flow (Spec §4.2).
///
/// Runs once on first launch. Saves theme, name, daily goal, and tutorial
/// completion. Routes to /home on finish.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/animation_constants.dart';
import '../../core/router/routes.dart';
import '../../core/services/storage_service.dart';
import '../../core/theme/theme_provider.dart';
import 'onboarding_controller.dart';
import 'steps/step_1_theme_picker.dart';
import 'steps/step_2_name_entry.dart';
import 'steps/step_3_daily_goal.dart';
import 'steps/step_4_gesture_tutorial.dart';

class OnboardingFlow extends ConsumerWidget {
  const OnboardingFlow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onboardingControllerProvider);
    final controller = ref.read(onboardingControllerProvider.notifier);

    Future<void> finish() async {
      final storage = ref.read(storageServiceProvider);
      if (state.themePreset != null) {
        await ref
            .read(themeControllerProvider.notifier)
            .setPreset(state.themePreset!);
      }
      if (state.name.isNotEmpty) {
        await storage.setDisplayName(state.name);
      }
      if (state.dailyGoal != null) {
        await storage.setDailyGoalMinutes(state.dailyGoal!.minutes);
      }
      await storage.setOnboardingComplete(true);
      if (context.mounted) context.go(Routes.home);
    }

    final pages = <Widget>[
      const StepThemePicker(),
      const StepNameEntry(),
      const StepDailyGoal(),
      StepGestureTutorial(onFinished: finish),
    ];

    return Scaffold(
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: AnimationConstants.medium,
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeInCubic,
          transitionBuilder: (child, animation) => FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.06, 0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            ),
          ),
          child: Padding(
            key: ValueKey(state.step),
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
            child: Column(
              children: [
                _StepIndicator(step: state.step, total: pages.length),
                const SizedBox(height: 24),
                Expanded(child: pages[state.step.clamp(0, pages.length - 1)]),
                _BottomBar(
                  step: state.step,
                  canBack: state.step > 0 && state.step < pages.length - 1,
                  canContinue: _canContinue(state),
                  onBack: controller.back,
                  onContinue: state.step == pages.length - 1
                      ? null // step 4 calls onFinished itself
                      : controller.next,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool _canContinue(OnboardingState s) {
    return switch (s.step) {
      0 => s.themePreset != null,
      1 => s.name.isNotEmpty,
      2 => s.dailyGoal != null,
      _ => false,
    };
  }
}

class _StepIndicator extends StatelessWidget {
  const _StepIndicator({required this.step, required this.total});

  final int step;
  final int total;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Row(
      children: List.generate(total, (i) {
        final filled = i <= step;
        return Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 3),
            height: 6,
            decoration: BoxDecoration(
              color:
                  filled ? colors.primary : colors.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
        );
      }),
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar({
    required this.step,
    required this.canBack,
    required this.canContinue,
    required this.onBack,
    required this.onContinue,
  });

  final int step;
  final bool canBack;
  final bool canContinue;
  final VoidCallback onBack;
  final VoidCallback? onContinue;

  @override
  Widget build(BuildContext context) {
    // Step 4 (gesture tutorial) handles its own finish CTA, so we hide
    // the bottom bar there.
    if (onContinue == null) return const SizedBox.shrink();

    return Row(
      children: [
        if (canBack)
          IconButton.filledTonal(
            onPressed: onBack,
            icon: const Icon(Icons.arrow_back_rounded),
          ),
        if (canBack) const SizedBox(width: 12),
        Expanded(
          child: FilledButton(
            onPressed: canContinue ? onContinue : null,
            child: const Text('Continue'),
          ),
        ),
      ],
    );
  }
}
