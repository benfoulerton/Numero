/// The explanation text shown inside the feedback panel after every answer
/// (Spec §8.1).
///
/// The text must be friendly and at the reading level of the youngest user
/// of the lesson. Never uses "Simply", "Obviously", "Just", or "Clearly"
/// (Spec Implementation Notes).
library;

import 'package:flutter/material.dart';

class ExplanationCard extends StatelessWidget {
  const ExplanationCard({
    super.key,
    required this.correct,
    required this.correctAnswer,
    required this.explanation,
  });

  final bool correct;
  final String? correctAnswer;
  final String? explanation;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          correct ? 'Nice.' : 'Not quite.',
          style: text.titleLarge?.copyWith(
            fontWeight: FontWeight.w800,
            color: correct ? colors.tertiary : colors.error,
          ),
        ),
        if (!correct && correctAnswer != null) ...[
          const SizedBox(height: 6),
          Text('Correct answer:',
              style: text.labelSmall
                  ?.copyWith(color: colors.onSurfaceVariant)),
          Text(correctAnswer!,
              style: text.titleMedium
                  ?.copyWith(fontWeight: FontWeight.w700)),
        ],
        if (explanation != null && explanation!.isNotEmpty) ...[
          const SizedBox(height: 10),
          Text(explanation!, style: text.bodyLarge),
        ],
      ],
    );
  }
}
