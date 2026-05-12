/// Animated Numero logo.
///
/// Renders [assets/icon/numero_icon.svg]. On mount, scales from 0.6 → 1.0
/// with the splash spring (Spec §4.1). Respects reduced-motion: falls back
/// to a 150 ms fade.
library;

import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../constants/animation_constants.dart';
import '../services/accessibility_service.dart';

class NumeroLogo extends ConsumerStatefulWidget {
  const NumeroLogo({
    super.key,
    this.size = 160,
    this.animateIn = true,
    this.tintColor,
  });

  final double size;
  final bool animateIn;

  /// If non-null, the SVG is recoloured to this tint (useful for splash on
  /// a coloured background where the brand blue might clash).
  final Color? tintColor;

  @override
  ConsumerState<NumeroLogo> createState() => _NumeroLogoState();
}

class _NumeroLogoState extends ConsumerState<NumeroLogo>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController.unbounded(vsync: this, value: 0.6);
    if (widget.animateIn) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        final reduced =
            ref.read(accessibilityServiceProvider).reducedMotion(context);
        if (reduced) {
          _controller.value = 1.0;
        } else {
          _controller.animateWith(
            SpringSimulation(AnimationConstants.splash, 0.6, 1.0, 0),
          );
        }
      });
    } else {
      _controller.value = 1.0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _controller.value,
            child: child,
          );
        },
        child: SvgPicture.asset(
          'assets/icon/numero_icon.svg',
          width: widget.size,
          height: widget.size,
          colorFilter: widget.tintColor != null
              ? ColorFilter.mode(widget.tintColor!, BlendMode.srcIn)
              : null,
        ),
      ),
    );
  }
}
