/// Splash screen (Spec §4.1).
///
/// Brand-coloured background, animated Numero logo with a spring-driven
/// scale-in, and an orbital loading animation while we route to the next
/// destination (onboarding for first launch, home otherwise).
library;

import 'dart:math' as math;

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

class _SplashScreenState extends ConsumerState<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _logoIn = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 700),
  );

  late final AnimationController _orbit = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  )..repeat();

  late final AnimationController _fadeOut = AnimationController(
    vsync: this,
    duration: AnimationConstants.medium,
  );

  late final Animation<double> _logoScale = CurvedAnimation(
    parent: _logoIn,
    curve: const Cubic(0.18, 0.89, 0.32, 1.28), // overshoot spring
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _runFlow());
  }

  Future<void> _runFlow() async {
    if (!mounted) return;
    final reduced =
        ref.read(accessibilityServiceProvider).reducedMotion(context);

    // 1. Spring the logo in.
    if (reduced) {
      _logoIn.value = 1.0;
    } else {
      await _logoIn.forward();
    }
    if (!mounted) return;

    // 2. Hold for a beat so the orbit is visible.
    final hold = reduced
        ? AppConstants.reducedMotionDuration
        : AppConstants.splashDuration;
    await Future.delayed(hold);
    if (!mounted) return;

    // 3. Fade everything out.
    await _fadeOut.forward();
    if (!mounted) return;

    final storage = ref.read(storageServiceProvider);
    final next =
        storage.onboardingComplete ? Routes.home : Routes.onboarding;
    context.go(next);
  }

  @override
  void dispose() {
    _logoIn.dispose();
    _orbit.dispose();
    _fadeOut.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colors.primary,
      body: AnimatedBuilder(
        animation: Listenable.merge([_logoIn, _orbit, _fadeOut]),
        builder: (context, _) {
          final fade = 1.0 - _fadeOut.value;
          return Opacity(
            opacity: fade,
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  // Orbiting loading dots — only animate once the logo has
                  // arrived, so the entrance doesn't feel busy.
                  Opacity(
                    opacity: _logoIn.value.clamp(0.0, 1.0),
                    child: CustomPaint(
                      size: const Size(240, 240),
                      painter: _OrbitPainter(
                        progress: _orbit.value,
                        color: colors.onPrimary,
                      ),
                    ),
                  ),
                  // Logo with spring scale-in.
                  Transform.scale(
                    scale: 0.4 + 0.6 * _logoScale.value,
                    child: Opacity(
                      opacity: _logoIn.value.clamp(0.0, 1.0),
                      child: NumeroLogo(
                        size: 132,
                        tintColor: colors.onPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Paints three dots travelling around a circular orbit. They stagger so
/// the eye picks up a graceful comet rather than a strobe.
class _OrbitPainter extends CustomPainter {
  _OrbitPainter({required this.progress, required this.color});

  final double progress; // 0..1 fraction through a full revolution
  final Color color;

  static const int _dotCount = 3;
  static const double _phaseSpread = 0.18; // fraction of a revolution between dots

  @override
  void paint(Canvas canvas, Size size) {
    final centre = size.center(Offset.zero);
    final radius = math.min(size.width, size.height) / 2 - 6;
    final paint = Paint()..color = color;

    for (var i = 0; i < _dotCount; i++) {
      final phase = (progress - i * _phaseSpread) % 1.0;
      final angle = phase * 2 * math.pi - math.pi / 2;
      final pos = Offset(
        centre.dx + radius * math.cos(angle),
        centre.dy + radius * math.sin(angle),
      );
      // Older dots in the trail are smaller and dimmer for a comet feel.
      final fade = 1.0 - (i / _dotCount) * 0.6;
      final r = 6.0 * fade;
      paint.color = color.withValues(alpha: fade);
      canvas.drawCircle(pos, r, paint);
    }
  }

  @override
  bool shouldRepaint(_OrbitPainter old) =>
      old.progress != progress || old.color != color;
}
