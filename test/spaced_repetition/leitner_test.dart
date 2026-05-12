import 'package:flutter_test/flutter_test.dart';
import 'package:numero/spaced_repetition/leitner/leitner_box.dart';

void main() {
  group('LeitnerBox', () {
    test('intervals are 1, 2, 4, 8, 16 days (Spec §10.1)', () {
      expect(LeitnerBox.intervalFor(1), const Duration(days: 1));
      expect(LeitnerBox.intervalFor(2), const Duration(days: 2));
      expect(LeitnerBox.intervalFor(3), const Duration(days: 4));
      expect(LeitnerBox.intervalFor(4), const Duration(days: 8));
      expect(LeitnerBox.intervalFor(5), const Duration(days: 16));
    });

    test('promote caps at max box', () {
      expect(LeitnerBox.promote(LeitnerBox.maxBox), LeitnerBox.maxBox);
      expect(LeitnerBox.promote(2), 3);
    });

    test('demote always returns to box 1', () {
      expect(LeitnerBox.demote(1), 1);
      expect(LeitnerBox.demote(3), 1);
      expect(LeitnerBox.demote(5), 1);
    });

    test('out-of-range box numbers are clamped', () {
      expect(LeitnerBox.intervalFor(0), const Duration(days: 1));
      expect(LeitnerBox.intervalFor(99), const Duration(days: 16));
    });

    test('nextReviewAt adds the box interval', () {
      final t = DateTime(2026, 1, 1);
      expect(LeitnerBox.nextReviewAt(t, 1),
          t.add(const Duration(days: 1)));
      expect(LeitnerBox.nextReviewAt(t, 5),
          t.add(const Duration(days: 16)));
    });
  });
}
