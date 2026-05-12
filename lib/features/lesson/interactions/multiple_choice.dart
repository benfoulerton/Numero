/// Multiple-choice question (Spec §7.7).
///
/// Four large vertically-stacked option cards. Used at most once or twice
/// per lesson — never on screen 2 (exploration) or screen 13 (summary).
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/services/haptic_service.dart';
import '../../../core/widgets/spring_scale.dart';
import 'interaction_types.dart';

class MultipleChoice extends ConsumerStatefulWidget {
  const MultipleChoice({
    super.key,
    required this.config,
    required this.onAnswer,
  });

  final McqConfig config;
  final AnswerCallback onAnswer;

  @override
  ConsumerState<MultipleChoice> createState() => _MultipleChoiceState();
}

class _MultipleChoiceState extends ConsumerState<MultipleChoice> {
  int? _selected;

  @override
  Widget build(BuildContext context) {
    final c = widget.config;
    return Column(
      children: [
        for (var i = 0; i < c.options.length; i++)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: _Option(
              label: c.options[i],
              index: i,
              selected: _selected == i,
              onTap: () {
                ref.read(hapticServiceProvider).selection();
                setState(() => _selected = i);
              },
            ),
          ),
        const Spacer(),
        FilledButton(
          onPressed: _selected == null
              ? null
              : () => widget.onAnswer(AnswerResult(
                    correct: _selected == c.correctIndex,
                    userAnswer: c.options[_selected!],
                    correctAnswer: c.options[c.correctIndex],
                    explanation: c.explanation,
                  )),
          child: const Text('Check'),
        ),
      ],
    );
  }
}

class _Option extends StatelessWidget {
  const _Option({
    required this.label,
    required this.index,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final int index;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return SpringScale(
      pressed: selected,
      child: Material(
        color:
            selected ? colors.primaryContainer : colors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(AppConstants.radiusM),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppConstants.radiusM),
          child: Container(
            constraints: const BoxConstraints(minHeight: 56),
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: selected
                        ? colors.primary
                        : colors.surfaceContainerHighest,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    String.fromCharCode(65 + index),
                    style: TextStyle(
                      color:
                          selected ? colors.onPrimary : colors.onSurfaceVariant,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      color: selected
                          ? colors.onPrimaryContainer
                          : colors.onSurface,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
