/// Haptic feedback (Spec §8: light impact on correct, soft double-tap
/// on incorrect). Respects the Settings haptics toggle.
library;

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'storage_service.dart';

class HapticService {
  HapticService(this._storage);

  final StorageService _storage;

  Future<void> selection() async {
    if (!_storage.hapticsEnabled) return;
    await HapticFeedback.selectionClick();
  }

  Future<void> correct() async {
    if (!_storage.hapticsEnabled) return;
    await HapticFeedback.lightImpact();
  }

  Future<void> incorrect() async {
    if (!_storage.hapticsEnabled) return;
    // Soft double-tap.
    await HapticFeedback.mediumImpact();
    await Future.delayed(const Duration(milliseconds: 80));
    await HapticFeedback.mediumImpact();
  }

  Future<void> celebrate() async {
    if (!_storage.hapticsEnabled) return;
    await HapticFeedback.heavyImpact();
  }
}

final hapticServiceProvider = Provider<HapticService>((ref) {
  final storage = ref.watch(storageServiceProvider);
  return HapticService(storage);
});
