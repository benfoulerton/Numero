/// Named route paths. Keep all routes here to avoid string drift.
library;

class Routes {
  const Routes._();

  static const splash = '/splash';
  static const onboarding = '/onboarding';

  // Shell + tabs.
  static const home = '/home';
  static const practice = '/practice';
  static const profile = '/profile';

  // Settings (pushed on top of profile).
  static const settings = '/settings';

  // Lesson — placeholder lesson id used in v1.
  static const lessonRoot = '/lesson';
  static String lesson(String lessonId) => '$lessonRoot/$lessonId';

  // Deep link from the Android home widget — "next lesson".
  static const lessonNext = '/lesson/next';
}
