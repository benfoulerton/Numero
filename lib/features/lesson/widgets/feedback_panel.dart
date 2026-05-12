/// Slide-up feedback panel (Spec §8.1).
///
/// Occupies the lower ~35% of the screen. Green on correct, amber on
/// incorrect. Always includes a Continue button.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/animation_constants.dart';
import '../../../core/services/accessibility_service.dart';
import '../../../core/widgets/numero_button.dart';
import '../interactions/interaction_types.dart';
import 'explanation_card.dart';

class FeedbackPanel extends ConsumerWidget {
  const FeedbackPanel({
    super.key,
    required this.result,
    required this.onContinue,
  });

  final AnswerResult result;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final correct = result.correct;
    final background =
        correct ? colors.tertiaryContainer : colors.errorContainer;

    final reduced =
        ref.read(accessibilityServiceProvider).reducedMotion(context);
    final duration = reduced
        ? const Duration(milliseconds: 150)
        : AnimationConstants.medium;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: duration,
      curve: Curves.easeOutCubic,
      builder: (context, t, child) {
        return Transform.translate(
          offset: Offset(0, (1 - t) * 80),
          child: Opacity(opacity: t, child: child),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: background,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 16,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Icon(
                    correct
                        ? Icons.check_circle_rounded
                        : Icons.cancel_rounded,
                    size: 32,
                    color: correct ? colors.tertiary : colors.error,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ExplanationCard(
                      correct: correct,
                      correctAnswer: result.correctAnswer,
                      explanation: result.explanation,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              NumeroButton(
                label: 'Continue',
                icon: Icons.arrow_forward_rounded,
                onPressed: onContinue,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
