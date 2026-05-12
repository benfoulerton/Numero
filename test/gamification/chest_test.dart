import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:numero/gamification/chests/chest_provider.dart';

void main() {
  group('ChestProvider', () {
    test('chests open every 5th lesson (Spec §9.5)', () {
      expect(ChestProvider.shouldOpenAfter(0), isFalse);
      expect(ChestProvider.shouldOpenAfter(4), isFalse);
      expect(ChestProvider.shouldOpenAfter(5), isTrue);
      expect(ChestProvider.shouldOpenAfter(10), isTrue);
      expect(ChestProvider.shouldOpenAfter(11), isFalse);
    });

    test('roll returns one of the five rewards', () {
      final rng = Random(42);
      for (var i = 0; i < 50; i++) {
        final r = ChestProvider.roll(rng);
        expect(ChestReward.values, contains(r));
      }
    });

    test('every ChestReward has a non-empty label', () {
      for (final r in ChestReward.values) {
        expect(r.label, isNotEmpty);
      }
    });
  });
}
