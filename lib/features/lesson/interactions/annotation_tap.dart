/// Annotation tap (Spec §7.10).
///
/// A diagram with multiple labelled regions. The user taps the region
/// matching the prompt. Tap targets ≥ 48dp.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/haptic_service.dart';
import 'interaction_types.dart';

class AnnotationTap extends ConsumerStatefulWidget {
  const AnnotationTap({
    super.key,
    required this.config,
    required this.onAnswer,
  });

  final AnnotationTapConfig config;
  final AnswerCallback onAnswer;

  @override
  ConsumerState<AnnotationTap> createState() => _AnnotationTapState();
}

class _AnnotationTapState extends ConsumerState<AnnotationTap> {
  String? _selected;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return LayoutBuilder(builder: (context, constraints) {
      final w = constraints.maxWidth;
      final h = constraints.maxHeight - 60;
      return Column(
        children: [
          Container(
            width: w,
            height: h,
            decoration: BoxDecoration(
              color: colors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Stack(
              children: [
                for (final r in widget.config.regions)
                  Positioned(
                    left: r.rect[0] * w,
                    top: r.rect[1] * h,
                    width: (r.rect[2] - r.rect[0]) * w,
                    height: (r.rect[3] - r.rect[1]) * h,
                    child: GestureDetector(
                      onTap: () {
                        ref.read(hapticServiceProvider).selection();
                        setState(() => _selected = r.id);
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        decoration: BoxDecoration(
                          color: _selected == r.id
                              ? colors.primary.withValues(alpha: 0.3)
                              : colors.primaryContainer
                                  .withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _selected == r.id
                                ? colors.primary
                                : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          r.label,
                          style: const TextStyle(
                              fontWeight: FontWeight.w700),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: _selected == null
                ? null
                : () {
                    final correct =
                        _selected == widget.config.correctRegionId;
                    widget.onAnswer(AnswerResult(
                      correct: correct,
                      explanation: widget.config.explanation,
                    ));
                  },
            child: const Text('Check'),
          ),
        ],
      );
    });
  }
}
