/// App-wide constants.
///
/// Centralised so the production-readiness checklist (Spec §15) can be
/// verified by static inspection. Do not duplicate these values elsewhere.
library;

import 'package:flutter/widgets.dart';

class AppConstants {
  const AppConstants._();

  // ── Spec §12.4 ── Accessibility: minimum tap target.
  static const double minTapTarget = 48.0;

  // ── Spec §4.1 ── Splash: 1.5–2 s.
  static const Duration splashDuration = Duration(milliseconds: 1700);

  // ── Spec §8 ── Feedback within 150 ms of every gesture.
  static const Duration feedbackLatencyBudget = Duration(milliseconds: 150);

  // ── Spec §11.2 ── Spring animations capped at 400 ms.
  static const Duration maxSpringDuration = Duration(milliseconds: 400);

  // Reduced-motion fade duration (Spec §11.2).
  static const Duration reducedMotionDuration = Duration(milliseconds: 150);

  // ── Spec §6.3 ── Micro-screen layout proportions.
  static const double visualZoneFraction = 0.40;
  static const double promptZoneFraction = 0.30;
  static const double answerZoneFraction = 0.30;

  // ── Spec §9 ── Gamification values.
  static const int maxHearts = 5;
  static const int heartRefillMinutes = 30;
  static const int heartRefillGemCost = 350;
  static const int heartlessLessonCount = 10; // first 10 lessons no penalty
  static const int xpPerCorrectAnswer = 1;
  static const int xpPerLesson = 10;
  static const int xpPerfectLessonBonus = 5;
  static const int xpStreakBonus = 5;
  static const int streakFreezesPerWeek = 2;
  static const int chestEveryNLessons = 5;
  static const int crownLevelsPerUnit = 5;
  static const int dailyQuestsPerDay = 3;

  // ── Spec §10 ── Spaced repetition mix policy.
  static const int reviewMixThreshold = 200; // items before mix flips
  static const double newRatioBefore = 0.70;
  static const double newRatioAfter = 0.30;

  // Padding scale — small, medium, large, xlarge.
  static const EdgeInsets paddingS = EdgeInsets.all(8);
  static const EdgeInsets paddingM = EdgeInsets.all(16);
  static const EdgeInsets paddingL = EdgeInsets.all(24);
  static const EdgeInsets paddingXl = EdgeInsets.all(32);

  // Common corner radii.
  static const double radiusS = 8;
  static const double radiusM = 16;
  static const double radiusL = 24;
  static const double radiusPill = 999;

  // Common screen breakpoints (Spec §15: 360 / 393 / 412 dp).
  static const double phoneSmall = 360;
  static const double phoneMedium = 393;
  static const double phoneLarge = 412;
}
