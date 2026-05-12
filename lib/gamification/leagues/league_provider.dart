/// Leagues (Spec §9.8). Off by default for users under 16. Opt-in only.
/// v1 ships the scaffolding — the actual weekly leaderboard is a backend
/// feature deferred to a later release.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/services/storage_service.dart';

class LeaguesController extends StateNotifier<bool> {
  LeaguesController(this._storage) : super(_storage.leaguesEnabled);

  final StorageService _storage;

  Future<void> setEnabled(bool enabled) async {
    state = enabled;
    await _storage.setLeaguesEnabled(enabled);
  }
}

final leaguesControllerProvider =
    StateNotifierProvider<LeaguesController, bool>((ref) {
  return LeaguesController(ref.watch(storageServiceProvider));
});
