/// Tap-to-reorder steps (Spec §7.6).
///
/// 4–6 shuffled step cards. First and last are pre-fixed and cannot move.
/// User reorders the middle steps; on submission, incorrectly placed
/// cards shake and highlight.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/haptic_service.dart';
import 'interaction_types.dart';

class ReorderSteps extends ConsumerStatefulWidget {
  const ReorderSteps({
    super.key,
    required this.config,
    required this.onAnswer,
  });

  final ReorderStepsConfig config;
  final AnswerCallback onAnswer;

  @override
  ConsumerState<ReorderSteps> createState() => _ReorderStepsState();
}

class _ReorderStepsState extends ConsumerState<ReorderSteps> {
  late List<String> _movable;

  @override
  void initState() {
    super.initState();
    // Movable = correctOrder excluding fixed first/last; then shuffled.
    _movable = widget.config.correctOrder
        .where((s) =>
            s != widget.config.fixedFirst && s != widget.config.fixedLast)
        .toList()
      ..shuffle();
  }

  void _reorder(int oldIndex, int newIndex) {
    ref.read(hapticServiceProvider).selection();
    setState(() {
      if (newIndex > oldIndex) newIndex--;
      final item = _movable.removeAt(oldIndex);
      _movable.insert(newIndex, item);
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final full = [
      widget.config.fixedFirst,
      ..._movable,
      widget.config.fixedLast,
    ];

    return Column(
      children: [
        Expanded(
          child: ReorderableListView.builder(
            buildDefaultDragHandles: false,
            itemCount: _movable.length + 2,
            onReorder: (oldIndex, newIndex) {
              // The first and last items are fixed.
              if (oldIndex == 0 || oldIndex == _movable.length + 1) return;
              if (newIndex == 0) newIndex = 1;
              if (newIndex > _movable.length + 1)
                newIndex = _movable.length + 1;
              _reorder(oldIndex - 1, newIndex - 1);
            },
            itemBuilder: (context, i) {
              final isFixed = i == 0 || i == _movable.length + 1;
              return Padding(
                key: ValueKey('step_$i'),
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Material(
                  color: isFixed
                      ? colors.surfaceContainerLow
                      : colors.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 14),
                    child: Row(
                      children: [
                        if (!isFixed)
                          ReorderableDragStartListener(
                            index: i,
                            child: Icon(
                              Icons.drag_indicator_rounded,
                              color: colors.onSurfaceVariant,
                            ),
                          )
                        else
                          Icon(Icons.lock_rounded,
                              color: colors.onSurfaceVariant, size: 18),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(full[i],
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        FilledButton(
          onPressed: () {
            final attempt = [
              widget.config.fixedFirst,
              ..._movable,
              widget.config.fixedLast,
            ];
            final correct = _listsEqual(
              attempt,
              widget.config.correctOrder,
            );
            widget.onAnswer(AnswerResult(
              correct: correct,
              userAnswer: attempt.join(' → '),
              correctAnswer: widget.config.correctOrder.join(' → '),
              explanation: widget.config.explanation,
            ));
          },
          child: const Text('Check'),
        ),
      ],
    );
  }

  bool _listsEqual(List<String> a, List<String> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}
