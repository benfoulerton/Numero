/// Base CustomPainter for diagrams. Subclasses paint into a guaranteed
/// clipped, repaint-bounded canvas of known size.
library;

import 'package:flutter/material.dart';

import 'diagram_container.dart';

class DiagramBase extends StatelessWidget {
  const DiagramBase({
    super.key,
    required this.painter,
    this.aspectRatio,
  });

  final CustomPainter painter;
  final double? aspectRatio;

  @override
  Widget build(BuildContext context) {
    final canvas = CustomPaint(painter: painter, size: Size.infinite);
    return DiagramContainer(
      child: aspectRatio == null
          ? canvas
          : AspectRatio(aspectRatio: aspectRatio!, child: canvas),
    );
  }
}
