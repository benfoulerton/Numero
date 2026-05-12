/// Visual chest opening animation — the box bounces, then springs open.
/// Used on the reward screen every 5 lessons (Spec §9.5).
library;

import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/animation_constants.dart';
import '../../core/services/accessibility_service.dart';
import 'chest_provider.dart';

class ChestAnimation extends ConsumerStatefulWidget {
  const ChestAnimation({
    super.key,
    required this.reward,
    this.size = 200,
  });

  final ChestReward reward;
  final double size;

  @override
  ConsumerState<ChestAnimation> createState() => _ChestAnimationState();
}

class _ChestAnimationState extends ConsumerState<ChestAnimation>
    with TickerProviderStateMixin {
  late final AnimationController _bounce =
      AnimationController.unbounded(vsync: this, value: 1.0);
  late final AnimationController _open =
      AnimationController(vsync: this, duration: AnimationConstants.slow);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      final reduced =
          ref.read(accessibilityServiceProvider).reducedMotion(context);
      if (reduced) {
        _open.value = 1.0;
        return;
      }
      // Bounce 3 times.
      for (var i = 0; i < 3; i++) {
        await _bounce.animateWith(
          SpringSimulation(AnimationConstants.playful, 1.0, 1.15, 0),
        );
        if (!mounted) return;
        await _bounce.animateWith(
          SpringSimulation(AnimationConstants.playful, 1.15, 1.0, 0),
        );
        if (!mounted) return;
      }
      await _open.forward();
    });
  }

  @override
  void dispose() {
    _bounce.dispose();
    _open.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: Listenable.merge([_bounce, _open]),
        builder: (context, _) {
          return Transform.scale(
            scale: _bounce.value,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: widget.size,
                  height: widget.size * 0.8,
                  decoration: BoxDecoration(
                    color: colors.tertiaryContainer,
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                if (_open.value < 1.0)
                  Positioned(
                    top: widget.size * 0.15,
                    child: Transform.rotate(
                      angle: -_open.value * 0.6,
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        width: widget.size * 0.9,
                        height: widget.size * 0.35,
                        decoration: BoxDecoration(
                          color: colors.tertiary,
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ),
                if (_open.value > 0.8)
                  Opacity(
                    opacity: ((_open.value - 0.8) / 0.2).clamp(0.0, 1.0),
                    child: Icon(
                      Icons.auto_awesome,
                      size: widget.size * 0.4,
                      color: colors.onTertiaryContainer,
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
