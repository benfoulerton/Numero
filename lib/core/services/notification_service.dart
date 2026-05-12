/// Local push notifications (Spec §13).
///
/// All notifications are off by default — they require explicit opt-in from
/// Settings. Maximum 1 notification per day for users aged under 16 (handled
/// by the scheduler, not enforced here).
library;

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  NotificationService(this._plugin);

  final FlutterLocalNotificationsPlugin _plugin;

  bool _initialized = false;

  static Future<NotificationService> create() async {
    final plugin = FlutterLocalNotificationsPlugin();
    final service = NotificationService(plugin);
    await service._init();
    return service;
  }

  Future<void> _init() async {
    if (_initialized) return;
    tz_data.initializeTimeZones();

    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: androidInit);

    await _plugin.initialize(settings);
    _initialized = true;
  }

  /// Requests permission (Android 13+). Safe to call even if permission was
  /// previously granted or denied — the system handles it.
  Future<bool> requestPermission() async {
    final android =
        _plugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    final granted = await android?.requestNotificationsPermission();
    return granted ?? false;
  }

  /// Spec §13.1: Daily reminder.
  Future<void> scheduleDailyReminder({
    required String userName,
    required int hour,
    int minute = 0,
  }) async {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(
        tz.local, now.year, now.month, now.day, hour, minute);
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }

    await _plugin.zonedSchedule(
      _idDaily,
      'Numero',
      'Your streak is waiting, $userName! Tap to keep it going.',
      scheduled,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'numero_daily',
          'Daily reminder',
          channelDescription: "Friendly nudge to keep your learning streak.",
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  /// Spec §13.1: Streak-at-risk reminder, fires at 8 pm local time.
  Future<void> scheduleStreakAtRisk({
    required String userName,
    required int currentStreak,
  }) async {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(tz.local, now.year, now.month, now.day, 20);
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }

    await _plugin.zonedSchedule(
      _idStreakRisk,
      'Numero',
      "$userName, don't lose your $currentStreak-day streak tonight!",
      scheduled,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'numero_streak_risk',
          'Streak at risk',
          channelDescription:
              "Reminder if you haven't completed a lesson by evening.",
          importance: Importance.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  Future<void> cancelDaily() async => _plugin.cancel(_idDaily);
  Future<void> cancelStreakRisk() async => _plugin.cancel(_idStreakRisk);
  Future<void> cancelAll() async => _plugin.cancelAll();

  static const int _idDaily = 1001;
  static const int _idStreakRisk = 1002;
}

final notificationServiceProvider = Provider<NotificationService>((ref) {
  throw UnimplementedError('Override at startup with .create()');
});
