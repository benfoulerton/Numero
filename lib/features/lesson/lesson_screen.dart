/// Lesson screen — the top-level lesson host (Spec §6).
///
/// Renders the top bar (X + progress + hearts), the current micro-screen,
/// and slides up the feedback panel after each answer. Hides the bottom
/// nav by virtue of being a top-level (non-shell) route.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/animation_constants.dart';
import '../../core/router/routes.dart';
import '../../core/services/audio_service.dart';
import '../../core/services/haptic_service.dart';
import '../../data/placeholder/placeholder_lesson.dart';
import 'interactions/interaction_types.dart';
import 'lesson_controller.dart';
import 'micro_screen_spec.dart';
import 'micro_screens/micro_screen_renderer.dart';
import 'widgets/feedback_panel.dart';
import 'widgets/lesson_top_bar.dart';
import 'widgets/reward_screen.dart';

class LessonScreen extends ConsumerStatefulWidget {
  const LessonScreen({super.key, required this.lessonId});

  final String lessonId;

  @override
  ConsumerState<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends ConsumerState<LessonScreen> {
  late final List<MicroScreenSpec> _screens;
  late final ({StateNotifierProvider<LessonController, LessonState> provider})
      _lessonRef;

  @override
  void initState() {
    super.initState();
    _screens = PlaceholderLesson.build();
    _lessonRef = lessonProviderFor(
      lessonId: widget.lessonId,
      totalScreens: _screens.length,
    );
  }

  Future<bool> _onWillPop() async {
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(_lessonRef.provider);
    final ctl = ref.read(_lessonRef.provider.notifier);
    final spec = _screens[state.currentIndex];
    final isReward = spec.kind == MicroScreenKind.reward;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        // Custom back handling — show the exit confirmation by tapping X.
      },
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  if (!isReward)
                    LessonTopBar(
                      totalSegments: _screens.length,
                      completedSegments: state.currentIndex,
                    ),
                  Expanded(
                    child: AnimatedSwitcher(
                      duration: AnimationConstants.medium,
                      switchInCurve: Curves.easeOutCubic,
                      transitionBuilder: (child, animation) {
                        return FadeTransition(
                          opacity: animation,
                          child: SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(0.05, 0),
                              end: Offset.zero,
                            ).animate(animation),
                            child: child,
                          ),
                        );
                      },
                      child: KeyedSubtree(
                        key: ValueKey(state.currentIndex),
                        child: isReward
                            ? RewardScreen(
                                perfect: state.isPerfect,
                                onFinish: () async {
                                  await ctl.completeLesson();
                                  if (context.mounted) context.go(Routes.home);
                                },
                              )
                            : MicroScreenRenderer(
                                spec: spec,
                                onAnswer: (r) async {
                                  // Play feedback within the 150ms budget.
                                  if (r.correct) {
                                    ref
                                        .read(hapticServiceProvider)
                                        .correct();
                                    ref
                                        .read(audioServiceProvider)
                                        .play(SoundEffect.correct);
                                  } else {
                                    ref
                                        .read(hapticServiceProvider)
                                        .incorrect();
                                    ref
                                        .read(audioServiceProvider)
                                        .play(SoundEffect.incorrect);
                                  }
                                  await ctl.submitAnswer(
                                    r,
                                    microScreenId: spec.id,
                                  );
                                },
                                onContinueNoScoring: () {
                                  ctl.next();
                                },
                              ),
                      ),
                    ),
                  ),
                ],
              ),
              if (state.feedbackVisible && state.lastResult != null)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: FeedbackPanel(
                    result: state.lastResult!,
                    onContinue: ctl.next,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
