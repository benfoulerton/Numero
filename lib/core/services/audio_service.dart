/// Audio feedback (Spec §8: short ascending two-tone for correct,
/// softer lower tone for incorrect).
///
/// Sound files are placeholders in [assets/sounds/]; if a sound is missing
/// the service fails silently so a missing asset never blocks gameplay.
library;

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'storage_service.dart';

enum SoundEffect {
  correct('correct.mp3'),
  incorrect('incorrect.mp3'),
  tap('tap.mp3'),
  streakIncrement('streak_increment.mp3'),
  chestOpen('chest_open.mp3');

  const SoundEffect(this.asset);
  final String asset;
}

class AudioService {
  AudioService(this._storage) {
    _player.setReleaseMode(ReleaseMode.stop);
  }

  final StorageService _storage;
  final AudioPlayer _player = AudioPlayer();

  Future<void> play(SoundEffect effect) async {
    if (!_storage.soundEnabled) return;
    try {
      await _player.stop();
      await _player.play(AssetSource('sounds/${effect.asset}'));
    } catch (_) {
      // Asset may not yet be in place; never throw from feedback path.
    }
  }

  Future<void> dispose() => _player.dispose();
}

final audioServiceProvider = Provider<AudioService>((ref) {
  final storage = ref.watch(storageServiceProvider);
  final service = AudioService(storage);
  ref.onDispose(service.dispose);
  return service;
});
