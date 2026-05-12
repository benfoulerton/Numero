/// Visual hook screen — Spec §6.4 screen 1 ("Watch what happens").
///
/// Animation only, no question, no notation. Auto-advances after a short
/// dwell or on tap. Target time 8–12 s.
library;

import 'package:flutter/material.dart';

import '../../../core/widgets/numero_button.dart';

class VisualHookScreen extends StatelessWidget {
  const VisualHookScreen({
    super.key,
    required this.prompt,
    required this.onContinue,
  });

  final String prompt;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: colors.primaryContainer,
                borderRadius: BorderRadius.circular(28),
              ),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.auto_awesome,
                      size: 80, color: colors.onPrimaryContainer),
                  const SizedBox(height: 16),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      prompt,
                      textAlign: TextAlign.center,
                      style: text.titleLarge?.copyWith(
                        color: colors.onPrimaryContainer,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
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
