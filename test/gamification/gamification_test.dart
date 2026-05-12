import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:numero/core/constants/app_constants.dart';
import 'package:numero/core/services/storage_service.dart';
import 'package:numero/core/theme/theme_provider.dart';
import 'package:numero/gamification/hearts/hearts_provider.dart';
import 'package:numero/gamification/streak/streak_provider.dart';
import 'package:numero/gamification/xp/xp_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

ProviderContainer _container(SharedPreferences prefs) {
  return ProviderContainer(overrides: [
    sharedPreferencesProvider.overrideWithValue(prefs),
  ]);
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('XpController', () {
    test('awarding correct increases total and today', () async {
      final prefs = await SharedPreferences.getInstance();
      final c = _container(prefs);
      addTearDown(c.dispose);

      await c.read(xpControllerProvider.notifier).awardCorrect();
      final state = c.read(xpControllerProvider);
      expect(state.total, 1);
      expect(state.today, 1);
    });

    test('lesson base awards 10 XP', () async {
      final prefs = await SharedPreferences.getInstance();
      final c = _container(prefs);
      addTearDown(c.dispose);

      await c.read(xpControllerProvider.notifier).awardLessonBase();
      expect(c.read(xpControllerProvider).total, AppConstants.xpPerLesson);
    });
  });

  group('HeartsController', () {
    test('hearts are disabled for the first 10 lessons', () async {
      final prefs = await SharedPreferences.getInstance();
      final c = _container(prefs);
      addTearDown(c.dispose);

      expect(c.read(heartsControllerProvider).disabled, isTrue);
      final lost = await c.read(heartsControllerProvider.notifier).loseOne();
      expect(lost, isFalse, reason: 'No heart should be lost while disabled');
    });

    test('hearts decrement after 10 lessons', () async {
      SharedPreferences.setMockInitialValues({
        'lessons_completed': 10,
        'hearts': 5,
      });
      final prefs = await SharedPreferences.getInstance();
      final c = _container(prefs);
      addTearDown(c.dispose);

      expect(c.read(heartsControllerProvider).disabled, isFalse);
      final lost = await c.read(heartsControllerProvider.notifier).loseOne();
      expect(lost, isTrue);
      expect(c.read(heartsControllerProvider).count, 4);
    });
  });

  group('StreakController', () {
    test('first lesson today starts a streak of 1', () async {
      final prefs = await SharedPreferences.getInstance();
      final c = _container(prefs);
      addTearDown(c.dispose);

      final firstToday =
          await c.read(streakControllerProvider.notifier).registerLessonCompleted();
      expect(firstToday, isTrue);
      expect(c.read(streakControllerProvider).count, 1);
    });

    test('second lesson same day does not double-count', () async {
      final prefs = await SharedPreferences.getInstance();
      final c = _container(prefs);
      addTearDown(c.dispose);

      await c.read(streakControllerProvider.notifier).registerLessonCompleted();
      final secondToday = await c
          .read(streakControllerProvider.notifier)
          .registerLessonCompleted();
      expect(secondToday, isFalse);
      expect(c.read(streakControllerProvider).count, 1);
    });
  });

  test('StorageService.resetAll clears all keys', () async {
    SharedPreferences.setMockInitialValues({
      'total_xp': 100,
      'streak_count': 7,
      'hearts': 3,
    });
    final prefs = await SharedPreferences.getInstance();
    final s = StorageService(prefs);

    expect(s.totalXp, 100);
    await s.resetAll();
    expect(s.totalXp, 0);
    expect(s.streak, 0);
    expect(s.hearts, AppConstants.maxHearts);
  });
}
