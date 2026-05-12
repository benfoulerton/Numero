/// Animation tuning constants.
///
/// Material 3 Expressive uses spring physics rather than easing curves
/// (Spec §12.1). These presets give a consistent feel across the app.
library;

import 'package:flutter/physics.dart';

class AnimationConstants {
  const AnimationConstants._();

  /// Used for snappy UI feedback (button taps, tile selections, segment fills).
  /// Quick to settle, slight overshoot.
  static const SpringDescription snappy = SpringDescription(
    mass: 1.0,
    stiffness: 500.0,
    damping: 25.0,
  );

  /// Used for content reveals (feedback panel slide-up, reward screen).
  /// Moderate overshoot, pleasingly bouncy.
  static const SpringDescription playful = SpringDescription(
    mass: 1.0,
    stiffness: 350.0,
    damping: 18.0,
  );

  /// Used for screen transitions and large element entrances.
  /// Gentle, no overshoot.
  static const SpringDescription gentle = SpringDescription(
    mass: 1.0,
    stiffness: 200.0,
    damping: 22.0,
  );

  /// Splash logo scale-up (Spec §4.1: 0.6 → 1.0).
  static const SpringDescription splash = SpringDescription(
    mass: 1.0,
    stiffness: 250.0,
    damping: 14.0,
  );

  static const Duration ultraFast = Duration(milliseconds: 100);
  static const Duration fast = Duration(milliseconds: 200);
  static const Duration medium = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 400);
}
