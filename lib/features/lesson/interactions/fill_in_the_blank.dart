/// Fill-in-the-blank (Spec §7.2).
///
/// Sentence with one blank shown as a gap. Below: a row of answer tiles.
/// Tapping a tile fills the blank; tapping the blank again clears it.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/haptic_service.dart';
import 'interaction_types.dart';

class FillInTheBlank extends ConsumerStatefulWidget {
  const FillInTheBlank({
    super.key,
    required this.config,
    required this.onAnswer,
  });

  final FillBlankConfig config;
  final AnswerCallback onAnswer;

  @override
  ConsumerState<FillInTheBlank> createState() => _FillInTheBlankState();
}

class _FillInTheBlankState extends ConsumerState<FillInTheBlank> {
  String? _filled;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final c = widget.config;

    return Column(
      children: [
        Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 6,
          children: [
            Text(c.beforeBlank,
                style: text.headlineSmall
                    ?.copyWith(fontWeight: FontWeight.w700)),
            GestureDetector(
              onTap: _filled == null
                  ? null
                  : () => setState(() => _filled = null),
              child: Container(
                constraints: const BoxConstraints(minWidth: 72),
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: _filled == null
                      ? colors.surfaceContainerHighest
                      : colors.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                  border: Border(
                    bottom: BorderSide(
                      color: colors.primary,
                      width: 3,
                    ),
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  _filled ?? '   ',
                  style: text.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: _filled == null
                          ? colors.onSurfaceVariant
                          : colors.onPrimaryContainer),
                ),
              ),
            ),
            Text(c.afterBlank,
                style: text.headlineSmall
                    ?.copyWith(fontWeight: FontWeight.w700)),
          ],
        ),
        const Spacer(),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          alignment: WrapAlignment.center,
          children: [
            for (final option in c.options)
              _OptionTile(
                label: option,
                used: _filled == option,
                onTap: _filled == option
                    ? null
                    : () {
                        ref.read(hapticServiceProvider).selection();
                        setState(() => _filled = option);
                      },
              ),
          ],
        ),
        const SizedBox(height: 12),
        FilledButton(
          onPressed: _filled == null
              ? null
              : () {
                  final correct = _filled == c.correctAnswer;
                  widget.onAnswer(AnswerResult(
                    correct: correct,
                    userAnswer: _filled,
                    correctAnswer: c.correctAnswer,
                    explanation: c.explanation,
                  ));
                },
          child: const Text('Check'),
        ),
      ],
    );
  }
}

class _OptionTile extends StatelessWidget {
  const _OptionTile({
    required this.label,
    required this.used,
    required this.onTap,
  });

  final String label;
  final bool used;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return AnimatedOpacity(
      opacity: used ? 0.25 : 1.0,
      duration: const Duration(milliseconds: 180),
      child: Material(
        color: colors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            constraints: const BoxConstraints(minHeight: 48, minWidth: 64),
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            alignment: Alignment.center,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 18,
                color: colors.onSurface,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
