/// Layout constants for the lesson micro-screen template (Spec §6.3).
library;

import 'package:flutter/widgets.dart';

class LayoutConstants {
  const LayoutConstants._();

  /// Returns the visual-zone height (top 40% of screen, Spec §6.3).
  static double visualZoneHeight(BuildContext context) {
    return MediaQuery.sizeOf(context).height * 0.40;
  }

  /// Returns the prompt-zone height (middle 30%, Spec §6.3).
  static double promptZoneHeight(BuildContext context) {
    return MediaQuery.sizeOf(context).height * 0.30;
  }

  /// Returns the answer-zone height (bottom 30%, Spec §6.3).
  static double answerZoneHeight(BuildContext context) {
    return MediaQuery.sizeOf(context).height * 0.30;
  }

  /// Maximum content width on tablet-class devices. The app is a phone app,
  /// but we centre content if a larger viewport is ever encountered.
  static const double maxContentWidth = 480;
}
