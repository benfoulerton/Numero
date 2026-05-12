/// Lesson-progress repository — writes finished-lesson records into the
/// SQLite lesson_progress table.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart';

import '../../core/services/database_service.dart';
import '../models/lesson_progress.dart';

class ProgressRepository {
  ProgressRepository(this._db);
  final DatabaseService _db;

  /// Inserts or replaces the row for [p.lessonId].
  Future<void> recordLesson(LessonProgress p) async {
    await _db.db.insert(
      'lesson_progress',
      {
        'lesson_id': p.lessonId,
        'completed_at': p.completedAt.toIso8601String(),
        'crown_level': p.crownLevel,
        'perfect': p.perfect ? 1 : 0,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> lessonCount() async {
    final rows = await _db.db
        .rawQuery('SELECT COUNT(*) AS c FROM lesson_progress');
    return (rows.first['c'] as int?) ?? 0;
  }
}

final progressRepositoryProvider = Provider<ProgressRepository>((ref) {
  return ProgressRepository(ref.watch(databaseServiceProvider));
});
