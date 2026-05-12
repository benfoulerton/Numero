/// Wraps [child] in a spring-driven scale animation.
///
/// Used wherever the M3 Expressive 'springy' feel is wanted on press —
/// path nodes, MCQ options, tile selections.
library;

import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/animation_constants.dart';
import '../services/accessibility_service.dart';

class SpringScale extends ConsumerStatefulWidget {
  const SpringScale({
    super.key,
    required this.child,
    this.pressed = false,
    this.pressedScale = 0.95,
    this.description = AnimationConstants.snappy,
  });

  final Widget child;
  final bool pressed;
  final double pressedScale;
  final SpringDescription description;

  @override
  ConsumerState<SpringScale> createState() => _SpringScaleState();
}

class _SpringScaleState extends ConsumerState<SpringScale>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController.unbounded(vsync: this, value: 1.0);
  }

  @override
  void didUpdateWidget(SpringScale oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.pressed != widget.pressed) {
      _animateTo(widget.pressed ? widget.pressedScale : 1.0);
    }
  }

  void _animateTo(double target) {
    final reduced =
        ref.read(accessibilityServiceProvider).reducedMotion(context);
    if (reduced) {
      _controller.value = target;
      return;
    }
    _controller.animateWith(
      SpringSimulation(widget.description, _controller.value, target, 0),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(scale: _controller.value, child: child);
      },
      child: widget.child,
    );
  }
}
