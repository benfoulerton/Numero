/// App router configuration (go_router).
///
/// Flow:
///   /splash  -> /onboarding (first launch only) or /home
///   /home, /practice, /profile  -> shell with bottom nav
///   /lesson/:id  -> full-screen, bottom nav hidden (Spec §3.2)
///   /settings    -> pushed on top
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/home/home_screen.dart';
import '../../features/lesson/lesson_screen.dart';
import '../../features/onboarding/onboarding_flow.dart';
import '../../features/practice/practice_screen.dart';
import '../../features/profile/profile_screen.dart';
import '../../features/settings/settings_screen.dart';
import '../../features/shell/app_shell.dart';
import '../../features/splash/splash_screen.dart';
import 'routes.dart';

final _rootNavKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final _shellNavKey = GlobalKey<NavigatorState>(debugLabel: 'shell');

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootNavKey,
    initialLocation: Routes.splash,
    debugLogDiagnostics: false,
    routes: [
      GoRoute(
        path: Routes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: Routes.onboarding,
        builder: (context, state) => const OnboardingFlow(),
      ),

      // Lesson — full-screen, no bottom nav.
      GoRoute(
        path: '${Routes.lessonRoot}/:id',
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? 'placeholder';
          return LessonScreen(lessonId: id);
        },
      ),

      // Settings — pushed above everything else.
      GoRoute(
        path: Routes.settings,
        builder: (context, state) => const SettingsScreen(),
      ),

      // Shell with bottom nav for Home / Practice / Profile.
      ShellRoute(
        navigatorKey: _shellNavKey,
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          GoRoute(
            path: Routes.home,
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: HomeScreen()),
          ),
          GoRoute(
            path: Routes.practice,
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: PracticeScreen()),
          ),
          GoRoute(
            path: Routes.profile,
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: ProfileScreen()),
          ),
        ],
      ),
    ],
  );
});
