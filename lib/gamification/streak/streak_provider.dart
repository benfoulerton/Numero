/// Streak provider (Spec §9.2).
///
/// Increments by 1 each day the user completes at least one lesson.
/// If a day is missed and a streak freeze is available, the freeze is
/// consumed and the streak is preserved. Otherwise the streak resets to 0
/// and the next lesson awards a comeback bonus (handled in XP code).
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/services/storage_service.dart';
import '../../core/utils/extensions.dart';

class StreakState {
  const StreakState({
    required this.count,
    required this.longest,
    required this.freezes,
    required this.completedToday,
  });

  final int count;
  final int longest;
  final int freezes;
  final bool completedToday;

  StreakState copyWith({
    int? count,
    int? longest,
    int? freezes,
    bool? completedToday,
  }) =>
      StreakState(
        count: count ?? this.count,
        longest: longest ?? this.longest,
        freezes: freezes ?? this.freezes,
        completedToday: completedToday ?? this.completedToday,
      );
}

class StreakController extends StateNotifier<StreakState> {
  StreakController(this._storage) : super(_load(_storage));

  final StorageService _storage;

  static StreakState _load(StorageService s) {
    final today = DateTime.now().dateOnly.toDateString();
    final last = s.streakLastDay;
    final completedToday = last == today;
    return StreakState(
      count: s.streak,
      longest: s.longestStreak,
      freezes: s.streakFreezes,
      completedToday: completedToday,
    );
  }

  /// Called when a lesson is completed. Returns true if this was the
  /// first lesson today (so a streak bonus should be awarded).
  Future<bool> registerLessonCompleted() async {
    final now = DateTime.now().dateOnly;
    final today = now.toDateString();
    final last = _storage.streakLastDay;

    if (last == today) {
      // Already counted today — no streak change.
      return false;
    }

    int newCount;
    if (last == null) {
      newCount = 1;
    } else {
      final lastDate = DateTime.parse(last);
      final dayGap = now.difference(lastDate).inDays;
      if (dayGap == 1) {
        newCount = state.count + 1;
      } else if (dayGap > 1 && state.freezes > 0) {
        // Consume one freeze; preserve streak.
        await _storage.setStreakFreezes(state.freezes - 1);
        newCount = state.count + 1;
      } else {
        // Missed and no freeze — reset.
        newCount = 1;
      }
    }

    final newLongest =
        newCount > state.longest ? newCount : state.longest;

    state = state.copyWith(
      count: newCount,
      longest: newLongest,
      freezes: _storage.streakFreezes,
      completedToday: true,
    );
    await _storage.setStreak(newCount);
    await _storage.setLongestStreak(newLongest);
    await _storage.setStreakLastDay(today);

    return true;
  }
}

final streakControllerProvider =
    StateNotifierProvider<StreakController, StreakState>((ref) {
  return StreakController(ref.watch(storageServiceProvider));
});
