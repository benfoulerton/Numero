/// Destructive reset confirmation (Spec §14.2).
///
/// Two-step confirmation: a warning dialog, then an "are you really sure"
/// alert. Then wipes all SharedPreferences and SQLite tables.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/routes.dart';
import '../../../core/services/database_service.dart';
import '../../../core/services/storage_service.dart';

class ResetProgressDialog {
  const ResetProgressDialog._();

  static Future<void> show(BuildContext context, WidgetRef ref) async {
    final firstOk = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Reset all progress?'),
        content: const Text(
          "This clears your XP, streak, hearts, settings, and every lesson "
          "result. Nothing can be recovered after this.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton.tonal(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Continue'),
          ),
        ],
      ),
    );
    if (firstOk != true || !context.mounted) return;

    final secondOk = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Really reset?'),
        content: const Text("Last chance — this can't be undone."),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Reset everything'),
          ),
        ],
      ),
    );
    if (secondOk != true || !context.mounted) return;

    await ref.read(storageServiceProvider).resetAll();
    try {
      await ref.read(databaseServiceProvider).clearAll();
    } catch (_) {
      // DB may not exist in tests.
    }

    if (context.mounted) {
      // Send back through the splash so onboarding can run again.
      context.go(Routes.splash);
    }
  }
}
