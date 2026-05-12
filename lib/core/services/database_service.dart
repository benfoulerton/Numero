/// SQLite-backed storage for richer data than SharedPreferences handles —
/// review queue items, lesson completion history, achievement unlocks.
///
/// Spec §2: sqflite for user progress and FSRS data.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  DatabaseService._(this._db);

  final Database _db;

  Database get db => _db;

  static Future<DatabaseService> open() async {
    final dir = await getApplicationDocumentsDirectory();
    final path = p.join(dir.path, 'numero.db');
    final db = await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
    return DatabaseService._(db);
  }

  static Future<void> _onCreate(Database db, int version) async {
    // Review queue items for Leitner / FSRS.
    await db.execute('''
      CREATE TABLE review_items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        lesson_id TEXT NOT NULL,
        micro_screen_id TEXT NOT NULL,
        box INTEGER NOT NULL DEFAULT 1,
        next_review_at TEXT NOT NULL,
        last_review_at TEXT,
        correct_count INTEGER NOT NULL DEFAULT 0,
        incorrect_count INTEGER NOT NULL DEFAULT 0,
        UNIQUE(lesson_id, micro_screen_id)
      );
    ''');

    // Lesson progress per user (single user for v1).
    await db.execute('''
      CREATE TABLE lesson_progress (
        lesson_id TEXT PRIMARY KEY,
        completed_at TEXT NOT NULL,
        crown_level INTEGER NOT NULL DEFAULT 1,
        perfect INTEGER NOT NULL DEFAULT 0
      );
    ''');

    // Daily quests state.
    await db.execute('''
      CREATE TABLE daily_quests (
        date TEXT NOT NULL,
        quest_id TEXT NOT NULL,
        progress INTEGER NOT NULL DEFAULT 0,
        target INTEGER NOT NULL,
        completed INTEGER NOT NULL DEFAULT 0,
        PRIMARY KEY (date, quest_id)
      );
    ''');

    // Achievements.
    await db.execute('''
      CREATE TABLE achievements (
        id TEXT PRIMARY KEY,
        unlocked_at TEXT NOT NULL
      );
    ''');

    await db.execute(
      'CREATE INDEX idx_review_due ON review_items (next_review_at);',
    );
  }

  Future<void> close() => _db.close();

  /// Wipes every row in every table. Called from Settings' reset action.
  Future<void> clearAll() async {
    final batch = _db.batch();
    batch.delete('review_items');
    batch.delete('lesson_progress');
    batch.delete('daily_quests');
    batch.delete('achievements');
    await batch.commit(noResult: true);
  }
}

final databaseServiceProvider = Provider<DatabaseService>((ref) {
  throw UnimplementedError('Override at startup with DatabaseService.open()');
});
