/// Step 1 — Welcome.
///
/// Single hero screen with the Numero logo, a one-line tagline, and a
/// Get Started button. Designed for breathing room — most of the screen
/// is empty space.
library;

import 'package:flutter/material.dart';

import '../../../core/widgets/numero_button.dart';
import '../../../core/widgets/numero_logo.dart';

class StepWelcome extends StatelessWidget {
  const StepWelcome({super.key, required this.onContinue});

  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(28, 32, 28, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Spacer(flex: 3),
          const NumeroLogo(size: 132),
          const SizedBox(height: 32),
          Text(
            'Welcome to Numero',
            textAlign: TextAlign.center,
            style: text.displaySmall?.copyWith(
              fontWeight: FontWeight.w800,
              height: 1.05,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            "Maths that actually clicks.",
            textAlign: TextAlign.center,
            style: text.titleMedium?.copyWith(
              color: colors.onSurfaceVariant,
            ),
          ),
          const Spacer(flex: 4),
          NumeroButton(
            label: 'Get started',
            icon: Icons.arrow_forward_rounded,
            onPressed: onContinue,
          ),
        ],
      ),
    );
  }
}
