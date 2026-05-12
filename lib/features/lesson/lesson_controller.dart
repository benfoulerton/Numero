/// Lesson controller (Spec §6).
///
/// Tracks current micro-screen index, the per-lesson result history, and
/// drives the XP/hearts/streak side-effects on completion.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/services/storage_service.dart';
import '../../gamification/hearts/hearts_provider.dart';
import '../../gamification/quests/quest_models.dart';
import '../../gamification/quests/quest_provider.dart';
import '../../gamification/streak/streak_provider.dart';
import '../../gamification/xp/xp_provider.dart';
import '../../spaced_repetition/leitner/leitner_scheduler.dart';
import 'interactions/interaction_types.dart';

class LessonState {
  const LessonState({
    required this.currentIndex,
    required this.totalScreens,
    required this.results,
    required this.lastResult,
    required this.feedbackVisible,
    required this.consecutiveCorrect,
  });

  final int currentIndex;
  final int totalScreens;
  final List<AnswerResult> results;
  final AnswerResult? lastResult;
  final bool feedbackVisible;
  final int consecutiveCorrect;

  bool get isPerfect =>
      results.isNotEmpty && results.every((r) => r.correct);
  bool get isLast => currentIndex >= totalScreens - 1;
  double get progress =>
      totalScreens == 0 ? 0 : (currentIndex + 1) / totalScreens;

  LessonState copyWith({
    int? currentIndex,
    int? totalScreens,
    List<AnswerResult>? results,
    AnswerResult? lastResult,
    bool? feedbackVisible,
    int? consecutiveCorrect,
    bool clearLastResult = false,
  }) =>
      LessonState(
        currentIndex: currentIndex ?? this.currentIndex,
        totalScreens: totalScreens ?? this.totalScreens,
        results: results ?? this.results,
        lastResult: clearLastResult ? null : (lastResult ?? this.lastResult),
        feedbackVisible: feedbackVisible ?? this.feedbackVisible,
        consecutiveCorrect: consecutiveCorrect ?? this.consecutiveCorrect,
      );
}

class LessonController extends StateNotifier<LessonState> {
  LessonController({
    required this.lessonId,
    required this.totalScreens,
    required Ref ref,
  })  : _ref = ref,
        super(LessonState(
          currentIndex: 0,
          totalScreens: totalScreens,
          results: const [],
          lastResult: null,
          feedbackVisible: false,
          consecutiveCorrect: 0,
        ));

  final String lessonId;
  final int totalScreens;
  final Ref _ref;

  /// Called by an interaction widget when the user submits an answer.
  Future<void> submitAnswer(AnswerResult result, {String? microScreenId}) async {
    // Record outcome in spaced repetition (placeholder ids are fine in v1).
    try {
      final scheduler = _ref.read(leitnerSchedulerProvider);
      await scheduler.recordOutcome(
        lessonId: lessonId,
        microScreenId: microScreenId ?? 'ms_${state.currentIndex}',
        correct: result.correct,
      );
    } catch (_) {
      // DB may not be available in tests — never block gameplay on this.
    }

    // XP for correct answers.
    if (result.correct) {
      await _ref.read(xpControllerProvider.notifier).awardCorrect();
      _ref.read(questControllerProvider.notifier).recordProgress(
            QuestKind.correctStreak,
          );
    } else {
      // Hearts loss — disabled during the first 10 lessons.
      await _ref.read(heartsControllerProvider.notifier).loseOne();
      // Reset the correct-streak quest.
      // (Quest provider only counts up; resets occur naturally at midnight.)
    }

    final consecutive =
        result.correct ? state.consecutiveCorrect + 1 : 0;

    state = state.copyWith(
      results: [...state.results, result],
      lastResult: result,
      feedbackVisible: true,
      consecutiveCorrect: consecutive,
    );
  }

  /// Advance past the current feedback panel to the next micro-screen.
  void next() {
    if (state.currentIndex >= state.totalScreens - 1) return;
    state = state.copyWith(
      currentIndex: state.currentIndex + 1,
      feedbackVisible: false,
      clearLastResult: true,
    );
  }

  /// Called when the reward screen "finish" CTA is tapped.
  Future<void> completeLesson() async {
    final storage = _ref.read(storageServiceProvider);
    final completed = storage.lessonsCompleted + 1;
    await storage.setLessonsCompleted(completed);

    await _ref.read(xpControllerProvider.notifier).awardLessonBase();
    if (state.isPerfect) {
      await _ref.read(xpControllerProvider.notifier).awardPerfectBonus();
    }

    final wasFirstToday = await _ref
        .read(streakControllerProvider.notifier)
        .registerLessonCompleted();
    if (wasFirstToday) {
      await _ref.read(xpControllerProvider.notifier).awardStreakBonus();
    }

    _ref.read(questControllerProvider.notifier).recordProgress(
          QuestKind.completeLessons,
        );

    await _ref.read(heartsControllerProvider.notifier).onLessonCompleted();
  }
}

final lessonControllerProvider = StateNotifierProvider.family<LessonController,
    LessonState, _LessonControllerArgs>((ref, args) {
  return LessonController(
    lessonId: args.lessonId,
    totalScreens: args.totalScreens,
    ref: ref,
  );
});

class _LessonControllerArgs {
  const _LessonControllerArgs(this.lessonId, this.totalScreens);
  final String lessonId;
  final int totalScreens;

  @override
  bool operator ==(Object other) =>
      other is _LessonControllerArgs &&
      other.lessonId == lessonId &&
      other.totalScreens == totalScreens;

  @override
  int get hashCode => Object.hash(lessonId, totalScreens);
}

/// Convenience constructor — keeps callers free of the private args class.
({StateNotifierProvider<LessonController, LessonState> provider})
    lessonProviderFor({required String lessonId, required int totalScreens}) {
  return (
    provider: lessonControllerProvider(
      _LessonControllerArgs(lessonId, totalScreens),
    )
  );
}
