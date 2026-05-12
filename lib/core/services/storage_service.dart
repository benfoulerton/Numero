/// Lightweight wrapper around [SharedPreferences] for app-level keys
/// (settings, streak, profile name, etc.). User progress and FSRS data
/// live in SQLite — see [DatabaseService].
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../theme/theme_provider.dart' show sharedPreferencesProvider;

class StorageService {
  StorageService(this._prefs);

  final SharedPreferences _prefs;

  /// Exposed for [StorageServiceAliases] in a sibling file. Treat as
  /// package-private; do not use directly outside the services layer.
  SharedPreferences get prefs => _prefs;

  // ── Onboarding ─────────────────────────────────────────
  static const _kOnboardingComplete = 'onboarding_complete';
  bool get onboardingComplete => _prefs.getBool(_kOnboardingComplete) ?? false;
  Future<void> setOnboardingComplete(bool value) =>
      _prefs.setBool(_kOnboardingComplete, value);

  // ── Profile ────────────────────────────────────────────
  static const _kDisplayName = 'display_name';
  String? get displayName => _prefs.getString(_kDisplayName);
  Future<void> setDisplayName(String name) =>
      _prefs.setString(_kDisplayName, name);

  static const _kAvatarId = 'avatar_id';
  String get avatarId => _prefs.getString(_kAvatarId) ?? 'fox';
  Future<void> setAvatarId(String id) => _prefs.setString(_kAvatarId, id);

  // ── Daily goal ─────────────────────────────────────────
  static const _kDailyGoal = 'daily_goal_minutes';
  int get dailyGoalMinutes => _prefs.getInt(_kDailyGoal) ?? 10;
  Future<void> setDailyGoalMinutes(int minutes) =>
      _prefs.setInt(_kDailyGoal, minutes);

  // ── Feedback toggles ───────────────────────────────────
  static const _kSoundEnabled = 'sound_enabled';
  bool get soundEnabled => _prefs.getBool(_kSoundEnabled) ?? true;
  Future<void> setSoundEnabled(bool value) =>
      _prefs.setBool(_kSoundEnabled, value);

  static const _kHapticsEnabled = 'haptics_enabled';
  bool get hapticsEnabled => _prefs.getBool(_kHapticsEnabled) ?? true;
  Future<void> setHapticsEnabled(bool value) =>
      _prefs.setBool(_kHapticsEnabled, value);

  static const _kReducedMotion = 'reduced_motion';
  bool get reducedMotion => _prefs.getBool(_kReducedMotion) ?? false;
  Future<void> setReducedMotion(bool value) =>
      _prefs.setBool(_kReducedMotion, value);

  static const _kHighContrast = 'high_contrast';
  bool get highContrast => _prefs.getBool(_kHighContrast) ?? false;
  Future<void> setHighContrast(bool value) =>
      _prefs.setBool(_kHighContrast, value);

  // ── Notification toggles ───────────────────────────────
  static const _kNotifDaily = 'notif_daily';
  bool get notifDaily => _prefs.getBool(_kNotifDaily) ?? false;
  Future<void> setNotifDaily(bool value) => _prefs.setBool(_kNotifDaily, value);

  static const _kNotifStreakRisk = 'notif_streak_risk';
  bool get notifStreakRisk => _prefs.getBool(_kNotifStreakRisk) ?? false;
  Future<void> setNotifStreakRisk(bool value) =>
      _prefs.setBool(_kNotifStreakRisk, value);

  static const _kNotifComeback = 'notif_comeback';
  bool get notifComeback => _prefs.getBool(_kNotifComeback) ?? false;
  Future<void> setNotifComeback(bool value) =>
      _prefs.setBool(_kNotifComeback, value);

  static const _kNotifReminderHour = 'notif_reminder_hour';
  int get notifReminderHour => _prefs.getInt(_kNotifReminderHour) ?? 19;
  Future<void> setNotifReminderHour(int hour) =>
      _prefs.setInt(_kNotifReminderHour, hour);

  // ── Leagues opt-in ─────────────────────────────────────
  static const _kLeaguesEnabled = 'leagues_enabled';
  bool get leaguesEnabled => _prefs.getBool(_kLeaguesEnabled) ?? false;
  Future<void> setLeaguesEnabled(bool value) =>
      _prefs.setBool(_kLeaguesEnabled, value);

  // ── Gamification state (XP / streak / hearts / gems) ───
  static const _kTotalXp = 'total_xp';
  int get totalXp => _prefs.getInt(_kTotalXp) ?? 0;
  Future<void> setTotalXp(int value) => _prefs.setInt(_kTotalXp, value);

  static const _kXpToday = 'xp_today';
  int get xpToday => _prefs.getInt(_kXpToday) ?? 0;
  Future<void> setXpToday(int value) => _prefs.setInt(_kXpToday, value);

  static const _kXpTodayDate = 'xp_today_date';
  String? get xpTodayDate => _prefs.getString(_kXpTodayDate);
  Future<void> setXpTodayDate(String iso) =>
      _prefs.setString(_kXpTodayDate, iso);

  static const _kStreak = 'streak_count';
  int get streak => _prefs.getInt(_kStreak) ?? 0;
  Future<void> setStreak(int value) => _prefs.setInt(_kStreak, value);

  static const _kLongestStreak = 'longest_streak';
  int get longestStreak => _prefs.getInt(_kLongestStreak) ?? 0;
  Future<void> setLongestStreak(int value) =>
      _prefs.setInt(_kLongestStreak, value);

  static const _kStreakLastDay = 'streak_last_day';
  String? get streakLastDay => _prefs.getString(_kStreakLastDay);
  Future<void> setStreakLastDay(String iso) =>
      _prefs.setString(_kStreakLastDay, iso);

  static const _kStreakFreezes = 'streak_freezes';
  int get streakFreezes => _prefs.getInt(_kStreakFreezes) ?? 2;
  Future<void> setStreakFreezes(int value) =>
      _prefs.setInt(_kStreakFreezes, value);

  static const _kHearts = 'hearts';
  int get hearts => _prefs.getInt(_kHearts) ?? 5;
  Future<void> setHearts(int value) => _prefs.setInt(_kHearts, value);

  static const _kGems = 'gems';
  int get gems => _prefs.getInt(_kGems) ?? 0;
  Future<void> setGems(int value) => _prefs.setInt(_kGems, value);

  static const _kLessonsCompleted = 'lessons_completed';
  int get lessonsCompleted => _prefs.getInt(_kLessonsCompleted) ?? 0;
  Future<void> setLessonsCompleted(int value) =>
      _prefs.setInt(_kLessonsCompleted, value);

  /// Wipes every key — used by the Settings 'Reset progress' destructive action.
  Future<void> resetAll() async {
    await _prefs.clear();
  }
}

final storageServiceProvider = Provider<StorageService>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return StorageService(prefs);
});
