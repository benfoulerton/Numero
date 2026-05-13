/// Fill-in-the-blank (Spec §7.2).
///
/// Sentence with one blank shown as a gap, with answer tiles below.
/// Wrapped in a scrollable column so it can never overflow on narrow
/// or short devices — the user can scroll if the answer pool is tall.
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
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Equation area — Wrap so a long sentence flows onto multiple lines
        // without overflowing horizontally.
        Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 6,
          runSpacing: 6,
          children: [
            Text(
              c.beforeBlank,
              style: text.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
            GestureDetector(
              onTap: _filled == null
                  ? null
                  : () => setState(() => _filled = null),
              child: Container(
                constraints: const BoxConstraints(minWidth: 72),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: _filled == null
                      ? colors.surfaceContainerHighest
                      : colors.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                  border: Border(
                    bottom: BorderSide(color: colors.primary, width: 3),
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  _filled ?? '   ',
                  style: text.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: _filled == null
                        ? colors.onSurfaceVariant
                        : colors.onPrimaryContainer,
                  ),
                ),
              ),
            ),
            Text(
              c.afterBlank,
              style: text.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
          ],
        ),
        const SizedBox(height: 20),
        // Option tiles — Expanded + scroll guarantees they're always
        // reachable, even on small screens.
        Expanded(
          child: SingleChildScrollView(
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
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
          ),
        ),
        const SizedBox(height: 12),
        FilledButton(
          onPressed: _filled == null
              ? null
              : () => widget.onAnswer(
                    AnswerResult(
                      correct: _filled == c.correctAnswer,
                      userAnswer: _filled,
                      correctAnswer: c.correctAnswer,
                      explanation: c.explanation,
                    ),
                  ),
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 4),
            child: Text('Check'),
          ),
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
            constraints: const BoxConstraints(minHeight: 56, minWidth: 72),
            padding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 14,
            ),
            alignment: Alignment.center,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 20,
                color: colors.onSurface,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
