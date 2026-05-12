/// Lesson summary screen (Spec §6.4 screen 13).
///
/// One sentence recap with a small visual reminder. Tap continue → reward.
library;

import 'package:flutter/material.dart';

import '../../../core/widgets/numero_button.dart';

class SummaryScreen extends StatelessWidget {
  const SummaryScreen({
    super.key,
    required this.text,
    required this.onContinue,
  });

  final String text;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final theme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const Spacer(),
          Icon(Icons.task_alt_rounded,
              size: 96, color: colors.tertiary),
          const SizedBox(height: 24),
          Text(
            text,
            textAlign: TextAlign.center,
            style: theme.headlineSmall
                ?.copyWith(fontWeight: FontWeight.w700),
          ),
          const Spacer(),
          NumeroButton(
            label: 'Continue',
            icon: Icons.arrow_forward_rounded,
            onPressed: onContinue,
          ),
        ],
      ),
    );
  }
}
