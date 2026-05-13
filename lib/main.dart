/// Application entry point.
///
/// Synchronously bootstraps the services that need async init
/// (SharedPreferences, SQLite, local notifications) and then runs the
/// app with their concrete instances injected through Riverpod overrides.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'core/services/database_service.dart';
import 'core/services/notification_service.dart';
import 'core/services/storage_service.dart';
import 'core/theme/theme_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final db = await DatabaseService.open();
  final notif = await NotificationService.create();

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        databaseServiceProvider.overrideWithValue(db),
        notificationServiceProvider.overrideWithValue(notif),
      ],
      child: const NumeroApp(),
    ),
  );
}
