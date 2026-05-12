/// XP provider (Spec §9.1).
///
/// Tracks total XP and XP earned today. Award rules:
///   - +1 per correct micro-screen answer
///   - +10 base per completed lesson
///   - +5 perfect-lesson bonus (no wrong answers)
///   - +5 streak-bonus if the lesson continues a daily streak
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/services/storage_service.dart';
import '../../core/utils/extensions.dart';

class XpState {
  const XpState({required this.total, required this.today});

  final int total;
  final int today;

  XpState copyWith({int? total, int? today}) =>
      XpState(total: total ?? this.total, today: today ?? this.today);
}

class XpController extends StateNotifier<XpState> {
  XpController(this._storage) : super(_load(_storage));

  final StorageService _storage;

  static XpState _load(StorageService s) {
    final today = DateTime.now().dateOnly.toDateString();
    final storedDay = s.xpTodayDate;
    if (storedDay != today) {
      return XpState(total: s.totalXp, today: 0);
    }
    return XpState(total: s.totalXp, today: s.xpToday);
  }

  Future<void> awardCorrect() => _award(1);
  Future<void> awardLessonBase() => _award(10);
  Future<void> awardPerfectBonus() => _award(5);
  Future<void> awardStreakBonus() => _award(5);

  Future<void> _award(int amount) async {
    final today = DateTime.now().dateOnly.toDateString();
    final stored = _storage.xpTodayDate;
    final todayBase = stored == today ? state.today : 0;

    final newTotal = state.total + amount;
    final newToday = todayBase + amount;

    state = XpState(total: newTotal, today: newToday);
    await _storage.setTotalXp(newTotal);
    await _storage.setXpToday(newToday);
    await _storage.setXpTodayDate(today);
  }
}

final xpControllerProvider =
    StateNotifierProvider<XpController, XpState>((ref) {
  return XpController(ref.watch(storageServiceProvider));
});
