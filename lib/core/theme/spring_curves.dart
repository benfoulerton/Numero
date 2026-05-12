/// Spring curve presets compatible with [SpringSimulation].
///
/// Use with [AnimationController.animateWith] for the M3 Expressive
/// spring-driven motion required by Spec §12.1.
library;

import 'package:flutter/physics.dart';

import '../constants/animation_constants.dart';

class SpringCurves {
  const SpringCurves._();

  /// Spring simulation from [start] to [end] with a chosen description.
  static SpringSimulation simulation({
    required double start,
    required double end,
    double velocity = 0.0,
    SpringDescription description = AnimationConstants.snappy,
  }) {
    return SpringSimulation(description, start, end, velocity);
  }
}
