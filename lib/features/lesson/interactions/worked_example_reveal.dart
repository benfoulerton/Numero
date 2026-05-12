/// Worked example reveal (Spec §7.11).
///
/// Multi-step solution shown one step at a time. Each step slides in from
/// the right. A 'Why this step?' button expands a brief explanation.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/animation_constants.dart';
import '../../../core/services/haptic_service.dart';
import 'interaction_types.dart';

class WorkedExampleReveal extends ConsumerStatefulWidget {
  const WorkedExampleReveal({
    super.key,
    required this.config,
    required this.onAnswer,
  });

  final WorkedExampleConfig config;
  final AnswerCallback onAnswer;

  @override
  ConsumerState<WorkedExampleReveal> createState() =>
      _WorkedExampleRevealState();
}

class _WorkedExampleRevealState extends ConsumerState<WorkedExampleReveal> {
  int _revealed = 1;
  final Set<int> _whyExpanded = {};

  bool get _allDone => _revealed >= widget.config.steps.length;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final visibleSteps =
        widget.config.steps.take(_revealed).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: ListView(
            children: [
              for (var i = 0; i < visibleSteps.length; i++)
                AnimatedSlide(
                  duration: AnimationConstants.medium,
                  curve: Curves.easeOutCubic,
                  offset: Offset.zero,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: colors.surfaceContainerHigh,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                color: colors.primary,
                                shape: BoxShape.circle,
                              ),
                              alignment: Alignment.center,
                              child: Text('${i + 1}',
                                  style: TextStyle(
                                      color: colors.onPrimary,
                                      fontWeight: FontWeight.w800)),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                visibleSteps[i].title,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(visibleSteps[i].body),
                        if (visibleSteps[i].why != null) ...[
                          const SizedBox(height: 8),
                          TextButton(
                            onPressed: () {
                              ref.read(hapticServiceProvider).selection();
                              setState(() {
                                if (_whyExpanded.contains(i)) {
                                  _whyExpanded.remove(i);
                                } else {
                                  _whyExpanded.add(i);
                                }
                              });
                            },
                            child: Text(
                              _whyExpanded.contains(i)
                                  ? 'Hide why'
                                  : 'Why this step?',
                            ),
                          ),
                          if (_whyExpanded.contains(i))
                            Container(
                              margin: const EdgeInsets.only(top: 6),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: colors.primaryContainer,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(visibleSteps[i].why!,
                                  style: TextStyle(
                                      color: colors.onPrimaryContainer)),
                            ),
                        ],
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
        FilledButton(
          onPressed: () {
            if (_allDone) {
              widget.onAnswer(const AnswerResult(correct: true));
            } else {
              ref.read(hapticServiceProvider).selection();
              setState(() => _revealed++);
            }
          },
          child: Text(_allDone ? 'Continue' : 'Next step'),
        ),
      ],
    );
  }
}
