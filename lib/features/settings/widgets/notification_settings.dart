/// Notification toggles + reminder time picker (Spec §13.2).
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/storage_service.dart';
import '../../../core/services/storage_service_aliases.dart';

class NotificationSettings extends ConsumerWidget {
  const NotificationSettings({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storage = ref.watch(storageServiceProvider);

    return Column(
      children: [
        SwitchListTile(
          secondary: const Icon(Icons.alarm_rounded),
          title: const Text('Daily reminder'),
          subtitle: const Text('Get a gentle nudge each day'),
          value: storage.notificationDaily,
          onChanged: (v) async {
            await storage.setNotificationDaily(v);
            (context as Element).markNeedsBuild();
          },
        ),
        SwitchListTile(
          secondary: const Icon(Icons.warning_amber_rounded),
          title: const Text('Streak at risk'),
          subtitle: const Text("Nudge if you haven't practiced by evening"),
          value: storage.notificationStreakAtRisk,
          onChanged: (v) async {
            await storage.setNotificationStreakAtRisk(v);
            (context as Element).markNeedsBuild();
          },
        ),
        SwitchListTile(
          secondary: const Icon(Icons.replay_rounded),
          title: const Text('Comeback reminders'),
          subtitle: const Text("After a few days away"),
          value: storage.notificationComeback,
          onChanged: (v) async {
            await storage.setNotificationComeback(v);
            (context as Element).markNeedsBuild();
          },
        ),
        ListTile(
          leading: const Icon(Icons.schedule_rounded),
          title: const Text('Reminder time'),
          subtitle:
              Text(_formatTime(storage.reminderHour, storage.reminderMinute)),
          onTap: () async {
            final initial = TimeOfDay(
              hour: storage.reminderHour,
              minute: storage.reminderMinute,
            );
            final picked = await showTimePicker(
              context: context,
              initialTime: initial,
            );
            if (picked != null) {
              await storage.setReminderTime(picked.hour, picked.minute);
              if (context.mounted) {
                (context as Element).markNeedsBuild();
              }
            }
          },
        ),
      ],
    );
  }

  String _formatTime(int hour, int minute) {
    final h = hour.toString().padLeft(2, '0');
    final m = minute.toString().padLeft(2, '0');
    return '$h:$m';
  }
}
