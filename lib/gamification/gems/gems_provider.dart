/// Gems provider (Spec §9.4).
///
/// Soft currency. Earned through daily quests, streak milestones, and chests.
/// Spent on heart refills (350 gems) and streak-freeze purchases.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/services/storage_service.dart';

class GemsController extends StateNotifier<int> {
  GemsController(this._storage) : super(_storage.gems);

  final StorageService _storage;

  Future<void> add(int amount) async {
    final next = state + amount;
    state = next;
    await _storage.setGems(next);
  }

  /// Returns true if the spend succeeded (sufficient gems).
  Future<bool> spend(int amount) async {
    if (state < amount) return false;
    final next = state - amount;
    state = next;
    await _storage.setGems(next);
    return true;
  }
}

final gemsControllerProvider = StateNotifierProvider<GemsController, int>((ref) {
  return GemsController(ref.watch(storageServiceProvider));
});
