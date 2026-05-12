/// Leitner box system (Spec §10.1, v1).
///
/// 5 boxes with doubling review intervals: 1, 2, 4, 8, 16 days.
/// On correct answer the item is promoted; on incorrect it returns to box 1.
library;

class LeitnerBox {
  const LeitnerBox._();

  /// Intervals in days, keyed by box number (1-indexed).
  static const intervals = <int>[1, 2, 4, 8, 16];

  static const int minBox = 1;
  static const int maxBox = 5;

  static int promote(int box) => (box + 1).clamp(minBox, maxBox);
  static int demote(int _) => minBox;

  static Duration intervalFor(int box) {
    final clamped = box.clamp(minBox, maxBox);
    return Duration(days: intervals[clamped - 1]);
  }

  /// Returns the next review timestamp given the current time and box.
  static DateTime nextReviewAt(DateTime now, int box) =>
      now.add(intervalFor(box));
}
