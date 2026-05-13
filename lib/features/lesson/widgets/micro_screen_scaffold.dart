/// Scaffold for a single micro-screen (Spec §6.3).
///
/// Three vertical zones at the 40/16/44 ratios of the *available* space
/// (not screen height). Using LayoutBuilder rather than MediaQuery means
/// the scaffold respects whatever space the parent gives it — so the
/// answer zone never gets squeezed off-screen by the lesson top bar.
library;

import 'package:flutter/material.dart';

class MicroScreenScaffold extends StatelessWidget {
  const MicroScreenScaffold({
    super.key,
    required this.visual,
    required this.prompt,
    required this.answer,
  });

  final Widget visual;
  final Widget prompt;
  final Widget answer;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final h = constraints.maxHeight;
        final visualHeight = h * 0.40;
        final promptHeight = h * 0.16;
        // The answer zone takes whatever is left, but with a sensible
        // minimum so very-short host containers don't crush it.
        return Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(
              height: visualHeight,
              width: double.infinity,
              // Spec §11.1: clipBehavior hardEdge on diagram containers.
              child: ClipRect(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Center(child: visual),
                ),
              ),
            ),
            SizedBox(
              height: promptHeight,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Center(child: prompt),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: answer,
              ),
            ),
          ],
        );
      },
    );
  }
}
