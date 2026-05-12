/// Splash screen (Spec §4.1).
///
/// Full-screen primary background, Numero logo springs from 0.6 -> 1.0,
/// then fades out and routes to /onboarding (first launch) or /home.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/animation_constants.dart';
import '../../core/constants/app_constants.dart';
import '../../core/router/routes.dart';
import '../../core/services/accessibility_service.dart';
import '../../core/services/storage_service.dart';
import '../../core/widgets/numero_logo.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  double _opacity = 1.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _runFlow());
  }

  Future<void> _runFlow() async {
    if (!mounted) return;
    final reduced =
        ref.read(accessibilityServiceProvider).reducedMotion(context);
    final dwell = reduced
        ? AppConstants.reducedMotionDuration
        : AppConstants.splashDuration;

    await Future.delayed(dwell);
    if (!mounted) return;

    // Begin fade.
    setState(() => _opacity = 0.0);
    await Future.delayed(AnimationConstants.medium);
    if (!mounted) return;

    final storage = ref.read(storageServiceProvider);
    final next =
        storage.onboardingComplete ? Routes.home : Routes.onboarding;
    context.go(next);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colors.primary,
      body: AnimatedOpacity(
        opacity: _opacity,
        duration: AnimationConstants.medium,
        curve: Curves.easeOut,
        child: Center(
          child: NumeroLogo(
            size: 180,
            tintColor: colors.onPrimary,
          ),
        ),
      ),
    );
  }
}
