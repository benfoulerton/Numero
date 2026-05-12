/// Schedules user-facing notifications based on streak/storage state.
///
/// Spec §13: at most 1 notification per day for users <16. All
/// notifications opt-in.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/services/notification_service.dart';
import '../core/services/storage_service.dart';
import '../core/services/storage_service_aliases.dart';
import '../gamification/streak/streak_provider.dart';

class NotificationScheduler {
  NotificationScheduler({
    required this.service,
    required this.storage,
  });

  final NotificationService service;
  final StorageService storage;

  Future<void> sync(StreakState streak) async {
    final reminderHour = storage.reminderHour;
    final reminderMinute = storage.reminderMinute;
    final name = storage.displayName ?? 'there';

    // Daily reminder.
    if (storage.notificationDaily) {
      await service.scheduleDailyReminder(
        userName: name,
        hour: reminderHour,
        minute: reminderMinute,
      );
    } else {
      await service.cancelDaily();
    }

    // Streak-at-risk.
    if (storage.notificationStreakAtRisk &&
        streak.count > 0 &&
        !streak.completedToday) {
      await service.scheduleStreakAtRisk(
        userName: name,
        currentStreak: streak.count,
      );
    } else {
      await service.cancelStreakRisk();
    }
  }
}

final notificationSchedulerProvider =
    Provider<NotificationScheduler>((ref) {
  return NotificationScheduler(
    service: ref.watch(notificationServiceProvider),
    storage: ref.watch(storageServiceProvider),
  );
});
