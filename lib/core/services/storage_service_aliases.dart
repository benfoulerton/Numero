/// Friendlier aliases on [StorageService] used by Settings and the
/// notification scheduler. The base service uses short, key-like names;
/// this extension provides natural, spec-matching ones.
library;

import 'storage_service.dart';

extension StorageServiceAliases on StorageService {
  // Haptics.
  bool get hapticEnabled => hapticsEnabled;
  Future<void> setHapticEnabled(bool v) => setHapticsEnabled(v);

  // Notification toggles.
  bool get notificationDaily => notifDaily;
  Future<void> setNotificationDaily(bool v) => setNotifDaily(v);

  bool get notificationStreakAtRisk => notifStreakRisk;
  Future<void> setNotificationStreakAtRisk(bool v) => setNotifStreakRisk(v);

  bool get notificationComeback => notifComeback;
  Future<void> setNotificationComeback(bool v) => setNotifComeback(v);

  // Reminder time — minute lives in a dedicated key alongside the hour.
  static const _kReminderMinute = 'notif_reminder_minute';

  int get reminderHour => notifReminderHour;
  int get reminderMinute => prefs.getInt(_kReminderMinute) ?? 0;

  Future<void> setReminderTime(int hour, int minute) async {
    await setNotifReminderHour(hour);
    await prefs.setInt(_kReminderMinute, minute);
  }
}
