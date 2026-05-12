/// Quest provider — generates and tracks today's three daily quests
/// (Spec §9.7). Resets at midnight local time.
library;

import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/extensions.dart';
import 'quest_models.dart';

class QuestController extends StateNotifier<List<DailyQuest>> {
  QuestController() : super([]) {
    _ensureToday();
  }

  String? _generatedFor;

  void _ensureToday() {
    final today = DateTime.now().dateOnly.toDateString();
    if (_generatedFor == today && state.isNotEmpty) return;
    _generatedFor = today;
    state = _generate(today);
  }

  static List<DailyQuest> _generate(String dateSeed) {
    final rng = Random(dateSeed.hashCode);
    final pool = <DailyQuest>[
      DailyQuest(
        id: '${dateSeed}_lessons',
        kind: QuestKind.completeLessons,
        label: 'Complete 2 lessons',
        target: 2,
        progress: 0,
        gemReward: 10,
      ),
      DailyQuest(
        id: '${dateSeed}_correct',
        kind: QuestKind.correctStreak,
        label: 'Answer 10 questions correctly in a row',
        target: 10,
        progress: 0,
        gemReward: 15,
      ),
      DailyQuest(
        id: '${dateSeed}_practice',
        kind: QuestKind.practiceForgotten,
        label: "Practice a skill you haven't touched in 3 days",
        target: 1,
        progress: 0,
        gemReward: 20,
      ),
    ];
    pool.shuffle(rng);
    return pool.take(3).toList();
  }

  /// Marks progress toward all quests of a given [kind].
  void recordProgress(QuestKind kind, [int delta = 1]) {
    _ensureToday();
    state = [
      for (final q in state)
        if (q.kind == kind && !q.completed)
          q.copyWith(progress: (q.progress + delta).clamp(0, q.target))
        else
          q,
    ];
  }

  bool get allComplete => state.every((q) => q.completed);
}

final questControllerProvider =
    StateNotifierProvider<QuestController, List<DailyQuest>>((ref) {
  return QuestController();
});
