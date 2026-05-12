import 'package:flutter_test/flutter_test.dart';
import 'package:numero/gamification/quests/quest_models.dart';
import 'package:numero/gamification/quests/quest_provider.dart';

void main() {
  group('QuestController', () {
    test('generates three quests for today', () {
      final c = QuestController();
      expect(c.state, hasLength(3));
    });

    test('progress increments for matching kind only', () {
      final c = QuestController();
      // Find the "complete lessons" quest if present in the day's set.
      final lessonQuest =
          c.state.where((q) => q.kind == QuestKind.completeLessons);
      final before =
          lessonQuest.isEmpty ? 0 : lessonQuest.first.progress;

      c.recordProgress(QuestKind.completeLessons);

      final after = c.state
          .where((q) => q.kind == QuestKind.completeLessons)
          .map((q) => q.progress);
      if (after.isNotEmpty) {
        expect(after.first, before + 1);
      }
    });

    test('progress is clamped at target', () {
      final c = QuestController();
      for (var i = 0; i < 50; i++) {
        c.recordProgress(QuestKind.completeLessons);
      }
      for (final q in c.state) {
        if (q.kind == QuestKind.completeLessons) {
          expect(q.progress, q.target);
          expect(q.completed, isTrue);
          expect(q.fraction, 1.0);
        }
      }
    });
  });
}
