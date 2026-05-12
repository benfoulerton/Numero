/// Thin wrapper around storage for settings keys. Useful for tests that
/// want to mock settings without mocking SharedPreferences directly.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/services/storage_service.dart';
import '../../core/services/storage_service_aliases.dart';

class SettingsRepository {
  SettingsRepository(this._storage);
  final StorageService _storage;

  bool get soundEnabled => _storage.soundEnabled;
  bool get hapticEnabled => _storage.hapticEnabled;
  bool get reducedMotion => _storage.reducedMotion;

  Future<void> setSoundEnabled(bool v) => _storage.setSoundEnabled(v);
  Future<void> setHapticEnabled(bool v) => _storage.setHapticEnabled(v);
  Future<void> setReducedMotion(bool v) => _storage.setReducedMotion(v);
}

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return SettingsRepository(ref.watch(storageServiceProvider));
});
