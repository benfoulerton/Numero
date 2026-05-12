/// A short confetti burst overlay. Used at the end of the onboarding
/// gesture tutorial (Spec §4.2 step 4) and on streak milestones.
library;

import 'dart:math' as math;

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

class ConfettiBurst extends StatefulWidget {
  const ConfettiBurst({
    super.key,
    required this.fire,
    this.numberOfParticles = 24,
    this.duration = const Duration(milliseconds: 800),
  });

  /// Controlled fire — every time this changes truthily, the confetti plays.
  final int fire;
  final int numberOfParticles;
  final Duration duration;

  @override
  State<ConfettiBurst> createState() => _ConfettiBurstState();
}

class _ConfettiBurstState extends State<ConfettiBurst> {
  late final ConfettiController _controller =
      ConfettiController(duration: widget.duration);

  @override
  void didUpdateWidget(ConfettiBurst oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.fire != widget.fire) {
      _controller.play();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Align(
      alignment: Alignment.center,
      child: ConfettiWidget(
        confettiController: _controller,
        blastDirectionality: BlastDirectionality.explosive,
        blastDirection: -math.pi / 2,
        emissionFrequency: 0.0,
        numberOfParticles: widget.numberOfParticles,
        gravity: 0.3,
        shouldLoop: false,
        colors: [
          colors.primary,
          colors.tertiary,
          colors.secondary,
          colors.primaryContainer,
        ],
      ),
    );
  }
}
