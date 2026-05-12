/// Chest reward provider (Spec §9.5).
///
/// Every 5th lesson completion plays a chest animation and awards one of:
///   - extra heart
///   - gem bundle (50 gems)
///   - theme unlock
///   - double-XP for next lesson
///   - mascot sticker
/// Variable-ratio randomness intentional — strongest habit formation.
library;

import 'dart:math';

enum ChestReward {
  extraHeart,
  gemBundle,
  themeUnlock,
  doubleXpNextLesson,
  mascotSticker;

  String get label => switch (this) {
        ChestReward.extraHeart => 'An extra heart!',
        ChestReward.gemBundle => '50 gems!',
        ChestReward.themeUnlock => 'A new theme!',
        ChestReward.doubleXpNextLesson => 'Double XP next lesson!',
        ChestReward.mascotSticker => 'A new sticker!',
      };
}

class ChestProvider {
  const ChestProvider._();

  static bool shouldOpenAfter(int lessonsCompleted) =>
      lessonsCompleted > 0 && lessonsCompleted % 5 == 0;

  static ChestReward roll([Random? rng]) {
    final r = rng ?? Random();
    return ChestReward.values[r.nextInt(ChestReward.values.length)];
  }
}
