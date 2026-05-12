/// Tap the correct graph (Spec §7.3).
///
/// 4 graph thumbnails in a 2×2 grid. The user taps the one that matches
/// the prompt. Distractors must represent plausible misconceptions, not
/// random shapes — but that's a content concern. This widget only handles
/// presentation and selection.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/haptic_service.dart';
import 'interaction_types.dart';

class TapCorrectGraph extends ConsumerStatefulWidget {
  const TapCorrectGraph({
    super.key,
    required this.config,
    required this.onAnswer,
    required this.thumbnailBuilders,
  });

  final TapCorrectGraphConfig config;
  final AnswerCallback onAnswer;
  /// 4 builders, one per thumbnail. Each returns a widget (typically a
  /// CustomPaint of the relevant graph) that fits its tile.
  final List<WidgetBuilder> thumbnailBuilders;

  @override
  ConsumerState<TapCorrectGraph> createState() => _TapCorrectGraphState();
}

class _TapCorrectGraphState extends ConsumerState<TapCorrectGraph> {
  int? _selected;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Column(
      children: [
        Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
            ),
            itemCount: widget.thumbnailBuilders.length,
            itemBuilder: (context, i) {
              final selected = _selected == i;
              return GestureDetector(
                onTap: () {
                  ref.read(hapticServiceProvider).selection();
                  setState(() => _selected = i);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    color: colors.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: selected ? colors.primary : Colors.transparent,
                      width: 3,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: widget.thumbnailBuilders[i](context),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        FilledButton(
          onPressed: _selected == null
              ? null
              : () {
                  final correct = _selected == widget.config.correctIndex;
                  widget.onAnswer(AnswerResult(
                    correct: correct,
                    explanation: widget.config.explanation,
                  ));
                },
          child: const Text('Check'),
        ),
      ],
    );
  }
}
