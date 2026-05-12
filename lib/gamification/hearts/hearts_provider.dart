/// Hearts provider (Spec §9.3).
///
/// Max 5. Lost on wrong answer. Disabled for the first 10 lessons of the
/// entire app — no punishment during onboarding learning.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_constants.dart';
import '../../core/services/storage_service.dart';

class HeartsState {
  const HeartsState({required this.count, required this.disabled});

  final int count;
  final bool disabled; // true during first 10 lessons of all time

  HeartsState copyWith({int? count, bool? disabled}) =>
      HeartsState(
        count: count ?? this.count,
        disabled: disabled ?? this.disabled,
      );
}

class HeartsController extends StateNotifier<HeartsState> {
  HeartsController(this._storage)
      : super(HeartsState(
          count: _storage.hearts,
          disabled: _storage.lessonsCompleted < AppConstants.heartlessLessonCount,
        ));

  final StorageService _storage;

  /// Returns true if a heart was actually lost.
  Future<bool> loseOne() async {
    if (state.disabled) return false;
    if (state.count <= 0) return false;
    final newCount = state.count - 1;
    state = state.copyWith(count: newCount);
    await _storage.setHearts(newCount);
    return true;
  }

  Future<void> refill() async {
    state = state.copyWith(count: AppConstants.maxHearts);
    await _storage.setHearts(AppConstants.maxHearts);
  }

  Future<void> onLessonCompleted() async {
    // Refresh the disabled flag.
    final completed = _storage.lessonsCompleted;
    state = state.copyWith(
      disabled: completed < AppConstants.heartlessLessonCount,
    );
  }
}

final heartsControllerProvider =
    StateNotifierProvider<HeartsController, HeartsState>((ref) {
  return HeartsController(ref.watch(storageServiceProvider));
});
