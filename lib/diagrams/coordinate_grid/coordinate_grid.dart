/// Coordinate grid diagram — 2D grid with optional draggable points.
///
/// Priority-1 diagram (Spec §11.3). Used from algebra onward.
library;

import 'package:flutter/material.dart';

import '../diagram_container.dart';

class CoordinateGrid extends StatelessWidget {
  const CoordinateGrid({
    super.key,
    this.xRange = const (-5, 5),
    this.yRange = const (-5, 5),
    this.points = const [],
  });

  final (int, int) xRange;
  final (int, int) yRange;
  final List<Offset> points;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return DiagramContainer(
      child: CustomPaint(
        size: Size.infinite,
        painter: _GridPainter(
          xMin: xRange.$1.toDouble(),
          xMax: xRange.$2.toDouble(),
          yMin: yRange.$1.toDouble(),
          yMax: yRange.$2.toDouble(),
          points: points,
          gridColor: colors.outlineVariant,
          axisColor: colors.outline,
          pointColor: colors.primary,
          labelColor: colors.onSurfaceVariant,
        ),
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  _GridPainter({
    required this.xMin,
    required this.xMax,
    required this.yMin,
    required this.yMax,
    required this.points,
    required this.gridColor,
    required this.axisColor,
    required this.pointColor,
    required this.labelColor,
  });

  final double xMin, xMax, yMin, yMax;
  final List<Offset> points;
  final Color gridColor;
  final Color axisColor;
  final Color pointColor;
  final Color labelColor;

  @override
  void paint(Canvas canvas, Size size) {
    final padding = 16.0;
    final w = size.width - 2 * padding;
    final h = size.height - 2 * padding;
    double mapX(double x) => padding + w * (x - xMin) / (xMax - xMin);
    double mapY(double y) => padding + h * (1 - (y - yMin) / (yMax - yMin));

    final grid = Paint()
      ..color = gridColor
      ..strokeWidth = 1;
    for (var x = xMin.toInt(); x <= xMax.toInt(); x++) {
      final px = mapX(x.toDouble());
      canvas.drawLine(
          Offset(px, padding), Offset(px, padding + h), grid);
    }
    for (var y = yMin.toInt(); y <= yMax.toInt(); y++) {
      final py = mapY(y.toDouble());
      canvas.drawLine(
          Offset(padding, py), Offset(padding + w, py), grid);
    }

    final axis = Paint()
      ..color = axisColor
      ..strokeWidth = 2;
    if (xMin <= 0 && xMax >= 0) {
      final xz = mapX(0);
      canvas.drawLine(Offset(xz, padding), Offset(xz, padding + h), axis);
    }
    if (yMin <= 0 && yMax >= 0) {
      final yz = mapY(0);
      canvas.drawLine(Offset(padding, yz), Offset(padding + w, yz), axis);
    }

    final pPaint = Paint()..color = pointColor;
    for (final p in points) {
      canvas.drawCircle(Offset(mapX(p.dx), mapY(p.dy)), 6, pPaint);
    }
  }

  @override
  bool shouldRepaint(_GridPainter old) =>
      old.points != points ||
      old.xMin != xMin ||
      old.xMax != xMax ||
      old.yMin != yMin ||
      old.yMax != yMax;
}
