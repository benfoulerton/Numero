/// Base container for every interactive diagram.
///
/// Spec §11.1 (Containment rule): every diagram lives inside a fixed-size
/// container with clipBehavior: Clip.hardEdge. No element may overflow under
/// any interaction state. This wrapper enforces both rules.
library;

import 'package:flutter/material.dart';

class DiagramContainer extends StatelessWidget {
  const DiagramContainer({
    super.key,
    required this.child,
    this.backgroundColor,
    this.borderRadius = 16,
  });

  final Widget child;
  final Color? backgroundColor;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return RepaintBoundary(
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: backgroundColor ?? colors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: child,
      ),
    );
  }
}
