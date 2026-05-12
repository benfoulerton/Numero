/// Scheduler that records review outcomes into the SQLite review_items
/// table and pulls due items for the practice queue.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/services/database_service.dart';
import 'leitner_box.dart';

class ReviewItem {
  const ReviewItem({
    required this.id,
    required this.lessonId,
    required this.microScreenId,
    required this.box,
    required this.nextReviewAt,
    required this.correctCount,
    required this.incorrectCount,
  });

  final int id;
  final String lessonId;
  final String microScreenId;
  final int box;
  final DateTime nextReviewAt;
  final int correctCount;
  final int incorrectCount;
}

class LeitnerScheduler {
  LeitnerScheduler(this._db);

  final DatabaseService _db;

  Future<void> recordOutcome({
    required String lessonId,
    required String microScreenId,
    required bool correct,
  }) async {
    final now = DateTime.now();
    final existing = await _db.db.query(
      'review_items',
      where: 'lesson_id = ? AND micro_screen_id = ?',
      whereArgs: [lessonId, microScreenId],
      limit: 1,
    );

    if (existing.isEmpty) {
      final box = correct ? 2 : 1;
      await _db.db.insert('review_items', {
        'lesson_id': lessonId,
        'micro_screen_id': microScreenId,
        'box': box,
        'next_review_at': LeitnerBox.nextReviewAt(now, box).toIso8601String(),
        'last_review_at': now.toIso8601String(),
        'correct_count': correct ? 1 : 0,
        'incorrect_count': correct ? 0 : 1,
      });
      return;
    }

    final row = existing.first;
    final currentBox = row['box'] as int;
    final nextBox =
        correct ? LeitnerBox.promote(currentBox) : LeitnerBox.demote(currentBox);

    await _db.db.update(
      'review_items',
      {
        'box': nextBox,
        'next_review_at': LeitnerBox.nextReviewAt(now, nextBox).toIso8601String(),
        'last_review_at': now.toIso8601String(),
        'correct_count':
            (row['correct_count'] as int) + (correct ? 1 : 0),
        'incorrect_count':
            (row['incorrect_count'] as int) + (correct ? 0 : 1),
      },
      where: 'id = ?',
      whereArgs: [row['id']],
    );
  }

  Future<List<ReviewItem>> dueItems({int limit = 50}) async {
    final now = DateTime.now().toIso8601String();
    final rows = await _db.db.query(
      'review_items',
      where: 'next_review_at <= ?',
      whereArgs: [now],
      orderBy: 'next_review_at ASC',
      limit: limit,
    );
    return rows.map((r) => ReviewItem(
          id: r['id'] as int,
          lessonId: r['lesson_id'] as String,
          microScreenId: r['micro_screen_id'] as String,
          box: r['box'] as int,
          nextReviewAt:
              DateTime.parse(r['next_review_at'] as String),
          correctCount: r['correct_count'] as int,
          incorrectCount: r['incorrect_count'] as int,
        )).toList();
  }

  Future<int> totalItemCount() async {
    final rows = await _db.db
        .rawQuery('SELECT COUNT(*) AS c FROM review_items');
    return (rows.first['c'] as int?) ?? 0;
  }
}

final leitnerSchedulerProvider = Provider<LeitnerScheduler>((ref) {
  return LeitnerScheduler(ref.watch(databaseServiceProvider));
});
