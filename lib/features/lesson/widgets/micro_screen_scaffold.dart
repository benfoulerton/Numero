/// Scaffold for a single micro-screen (Spec §6.3).
///
/// Three vertical zones at the 40/30/30 ratios from the spec. The answer
/// zone receives an interaction widget; on submit, the feedback panel
/// slides up to occupy the lower ~35%.
library;

import 'package:flutter/material.dart';

import '../../../core/constants/layout_constants.dart';

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
    final size = MediaQuery.sizeOf(context);
    return Column(
      children: [
        SizedBox(
          height: size.height * 0.40,
          width: double.infinity,
          // Container for diagrams — spec §11.1: clipBehavior hardEdge.
          child: ClipRect(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Center(child: visual),
            ),
          ),
        ),
        Container(
          height: size.height * 0.16, // half of the 30% prompt zone
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          alignment: Alignment.center,
          child: prompt,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: answer,
          ),
        ),
      ],
    );
  }

  // Exposed for tests and design tooling.
  static double visualZoneHeight(BuildContext context) =>
      LayoutConstants.visualZoneHeight(context);
}
