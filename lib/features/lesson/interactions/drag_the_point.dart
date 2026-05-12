/// Drag-the-point (Spec §7.9).
///
/// A draggable point on a canvas. The user moves it to a target position.
/// Hit targets must be at least 48dp in radius — enforced visually by the
/// target circle size.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/haptic_service.dart';
import 'interaction_types.dart';

class DragThePoint extends ConsumerStatefulWidget {
  const DragThePoint({
    super.key,
    required this.config,
    required this.onAnswer,
  });

  final DragPointConfig config;
  final AnswerCallback onAnswer;

  @override
  ConsumerState<DragThePoint> createState() => _DragThePointState();
}

class _DragThePointState extends ConsumerState<DragThePoint> {
  /// Normalised (0-1) coordinates of the user's point inside the canvas.
  double _x = 0.5;
  double _y = 0.5;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return LayoutBuilder(builder: (context, constraints) {
      final w = constraints.maxWidth;
      final h = constraints.maxHeight - 60; // leave space for the button

      return Column(
        children: [
          SizedBox(
            width: w,
            height: h,
            child: Stack(
              children: [
                // Background.
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: colors.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
                // Target reticle.
                Positioned(
                  left: widget.config.targetX * w - 24,
                  top: widget.config.targetY * h - 24,
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: colors.tertiary.withValues(alpha: 0.4),
                        width: 2,
                      ),
                    ),
                  ),
                ),
                // Draggable point.
                Positioned(
                  left: _x * w - 22,
                  top: _y * h - 22,
                  child: GestureDetector(
                    onPanUpdate: (d) {
                      ref.read(hapticServiceProvider).selection();
                      setState(() {
                        _x = ((_x * w) + d.delta.dx).clamp(0.0, w) / w;
                        _y = ((_y * h) + d.delta.dy).clamp(0.0, h) / h;
                      });
                    },
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: colors.primary,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: colors.primary.withValues(alpha: 0.4),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: () {
              final dx = _x - widget.config.targetX;
              final dy = _y - widget.config.targetY;
              final dist = (dx * dx + dy * dy);
              final correct = dist <=
                  widget.config.tolerance * widget.config.tolerance;
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
