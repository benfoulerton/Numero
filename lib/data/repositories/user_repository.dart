/// Thin wrapper around storage for user profile fields.
///
/// Most callers can read storage directly; this exists so that future
/// migration to a server-backed user record is a single-file change.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/services/storage_service.dart';
import '../models/user_profile.dart';

class UserRepository {
  UserRepository(this._storage);
  final StorageService _storage;

  UserProfile load() => UserProfile(
        displayName: _storage.displayName ?? '',
        avatarId: _storage.avatarId,
        dailyGoalMinutes: _storage.dailyGoalMinutes,
        totalXp: _storage.totalXp,
        streak: _storage.streak,
        longestStreak: _storage.longestStreak,
        lessonsCompleted: _storage.lessonsCompleted,
        hearts: _storage.hearts,
        gems: _storage.gems,
      );

  Future<void> setName(String name) => _storage.setDisplayName(name);
  Future<void> setAvatar(String avatarId) =>
      _storage.setAvatarId(avatarId);
}

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository(ref.watch(storageServiceProvider));
});
