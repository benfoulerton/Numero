/// Onboarding flow — three breathing-room screens:
///   1. Welcome
///   2. Name
///   3. Theme
///
/// Daily goal selection is moved to the Profile screen — keeping onboarding
/// short means the user reaches their first lesson faster.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/animation_constants.dart';
import '../../core/router/routes.dart';
import '../../core/services/storage_service.dart';
import '../../core/theme/theme_provider.dart';
import 'onboarding_controller.dart';
import 'steps/step_1_welcome.dart';
import 'steps/step_2_name_entry.dart';
import 'steps/step_3_theme_picker.dart';

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
      await storage.setOnboardingComplete(true);
      if (context.mounted) context.go(Routes.home);
    }

    final pages = <Widget>[
      StepWelcome(onContinue: controller.next),
      StepNameEntry(
        onContinue: state.name.isNotEmpty ? controller.next : null,
      ),
      StepThemePicker(
        onContinue: state.themePreset != null ? finish : null,
      ),
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
                begin: const Offset(0.05, 0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            ),
          ),
          child: KeyedSubtree(
            key: ValueKey(state.step),
            child: pages[state.step.clamp(0, pages.length - 1)],
          ),
        ),
      ),
    );
  }
}
