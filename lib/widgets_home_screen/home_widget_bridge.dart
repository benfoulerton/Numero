/// Pushes data to the Android home-screen widget (Spec §13.3).
///
/// Uses `home_widget` to write three keys (streak, xpToday, nextLessonTitle)
/// and then requests an update on both widget variants. Called when a
/// lesson finishes and on app foreground.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_widget/home_widget.dart';

import '../core/services/storage_service.dart';
import '../gamification/streak/streak_provider.dart';
import '../gamification/xp/xp_provider.dart';

class HomeWidgetBridge {
  HomeWidgetBridge({required this.ref});
  final Ref ref;

  Future<void> push({String? nextLessonTitle}) async {
    final streak = ref.read(streakControllerProvider).count;
    final xp = ref.read(xpControllerProvider).today;
    final name = ref.read(storageServiceProvider).displayName ?? '';

    try {
      await HomeWidget.saveWidgetData<int>('streak', streak);
      await HomeWidget.saveWidgetData<int>('xpToday', xp);
      await HomeWidget.saveWidgetData<String>('userName', name);
      await HomeWidget.saveWidgetData<String>(
        'nextLessonTitle',
        nextLessonTitle ?? 'Next lesson',
      );
      await HomeWidget.updateWidget(
        androidName: 'NumeroWidgetSmall',
        qualifiedAndroidName: 'com.numero.app.widget.NumeroWidgetSmall',
      );
      await HomeWidget.updateWidget(
        androidName: 'NumeroWidgetMedium',
        qualifiedAndroidName: 'com.numero.app.widget.NumeroWidgetMedium',
      );
    } catch (_) {
      // The widget may not be installed; safe to swallow.
    }
  }
}

final homeWidgetBridgeProvider = Provider<HomeWidgetBridge>((ref) {
  return HomeWidgetBridge(ref: ref);
});
