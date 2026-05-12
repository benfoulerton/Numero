/// CustomPainter that draws the winding trail between path nodes
/// (Spec §5.2). Two control points per segment create the curve.
library;

import 'package:flutter/material.dart';

class PathTrailPainter extends CustomPainter {
  PathTrailPainter({
    required this.nodeCenters,
    required this.color,
    required this.completedThroughIndex,
  });

  /// Centres of each node, in painter-local coordinates.
  final List<Offset> nodeCenters;
  final Color color;
  final int completedThroughIndex;

  @override
  void paint(Canvas canvas, Size size) {
    if (nodeCenters.length < 2) return;

    final completedPaint = Paint()
      ..color = color
      ..strokeWidth = 8
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final futurePaint = Paint()
      ..color = color.withValues(alpha: 0.20)
      ..strokeWidth = 8
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    for (var i = 0; i < nodeCenters.length - 1; i++) {
      final p1 = nodeCenters[i];
      final p2 = nodeCenters[i + 1];

      final controlOffsetX = (i.isEven ? 36 : -36);
      final c1 = Offset(p1.dx + controlOffsetX, p1.dy + (p2.dy - p1.dy) / 3);
      final c2 = Offset(p2.dx - controlOffsetX, p2.dy - (p2.dy - p1.dy) / 3);

      final path = Path()
        ..moveTo(p1.dx, p1.dy)
        ..cubicTo(c1.dx, c1.dy, c2.dx, c2.dy, p2.dx, p2.dy);

      final paint =
          i < completedThroughIndex ? completedPaint : futurePaint;
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(PathTrailPainter old) =>
      old.nodeCenters != nodeCenters ||
      old.color != color ||
      old.completedThroughIndex != completedThroughIndex;
}
