/// Slider / drag-to-explore (Spec §7.4).
///
/// Mode A — exploratory (config.target == null): no scoring, used for
/// observation screens (Spec §6.4 screen 2).
/// Mode B — target with tolerance: the user must drag to within tolerance
/// of the target value.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'interaction_types.dart';

class SliderExplore extends ConsumerStatefulWidget {
  const SliderExplore({
    super.key,
    required this.config,
    required this.onAnswer,
    this.onValueChanged,
  });

  final SliderExploreConfig config;
  final AnswerCallback onAnswer;

  /// Called continuously as the slider moves — lets the visual zone
  /// (a diagram) react in real time.
  final ValueChanged<double>? onValueChanged;

  @override
  ConsumerState<SliderExplore> createState() => _SliderExploreState();
}

class _SliderExploreState extends ConsumerState<SliderExplore> {
  late double _value =
      (widget.config.min + widget.config.max) / 2;

  @override
  Widget build(BuildContext context) {
    final c = widget.config;
    final isExploratory = c.target == null;
    return Column(
      children: [
        const Spacer(),
        Slider(
          value: _value,
          min: c.min,
          max: c.max,
          onChanged: (v) {
            setState(() => _value = v);
            widget.onValueChanged?.call(v);
          },
        ),
        const SizedBox(height: 8),
        Text(_value.toStringAsFixed(2),
            style: Theme.of(context).textTheme.titleMedium),
        const Spacer(),
        FilledButton(
          onPressed: () {
            if (isExploratory) {
              widget.onAnswer(AnswerResult(
                correct: true,
                explanation: c.explanation,
              ));
            } else {
              final correct = (_value - c.target!).abs() <= c.tolerance;
              widget.onAnswer(AnswerResult(
                correct: correct,
                userAnswer: _value.toStringAsFixed(3),
                correctAnswer: c.target!.toStringAsFixed(3),
                explanation: c.explanation,
              ));
            }
          },
          child: Text(isExploratory ? 'Continue' : 'Check'),
        ),
      ],
    );
  }
}
