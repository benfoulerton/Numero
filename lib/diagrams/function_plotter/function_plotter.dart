/// Function plotter — plots y = f(x) by sampling.
///
/// Priority-1 diagram (Spec §11.3). v1 ships a static plotter; pan/zoom can
/// be added later by adjusting the [xMin]/[xMax] state via gesture handlers.
library;

import 'package:flutter/material.dart';

import '../diagram_container.dart';

class FunctionPlotter extends StatelessWidget {
  const FunctionPlotter({
    super.key,
    required this.f,
    this.xMin = -10,
    this.xMax = 10,
    this.yMin,
    this.yMax,
    this.samples = 200,
  });

  final double Function(double x) f;
  final double xMin;
  final double xMax;
  final double? yMin;
  final double? yMax;
  final int samples;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return DiagramContainer(
      child: CustomPaint(
        painter: _FunctionPainter(
          f: f,
          xMin: xMin,
          xMax: xMax,
          yMin: yMin,
          yMax: yMax,
          samples: samples,
          axisColor: colors.outlineVariant,
          lineColor: colors.primary,
        ),
        size: Size.infinite,
      ),
    );
  }
}

class _FunctionPainter extends CustomPainter {
  _FunctionPainter({
    required this.f,
    required this.xMin,
    required this.xMax,
    required this.yMin,
    required this.yMax,
    required this.samples,
    required this.axisColor,
    required this.lineColor,
  });

  final double Function(double) f;
  final double xMin, xMax;
  final double? yMin, yMax;
  final int samples;
  final Color axisColor;
  final Color lineColor;

  @override
  void paint(Canvas canvas, Size size) {
    // Determine y range.
    final ys = <double>[];
    for (var i = 0; i <= samples; i++) {
      final x = xMin + (xMax - xMin) * (i / samples);
      final y = f(x);
      if (y.isFinite) ys.add(y);
    }
    final yLo = yMin ??
        (ys.isEmpty ? -1 : ys.reduce((a, b) => a < b ? a : b));
    final yHi = yMax ??
        (ys.isEmpty ? 1 : ys.reduce((a, b) => a > b ? a : b));
    final yRange = (yHi - yLo) == 0 ? 1.0 : (yHi - yLo);

    double mapX(double x) =>
        12 + (size.width - 24) * (x - xMin) / (xMax - xMin);
    double mapY(double y) =>
        size.height - 12 - (size.height - 24) * (y - yLo) / yRange;

    // Axes (only if 0 is within range).
    final axisPaint = Paint()
      ..color = axisColor
      ..strokeWidth = 1;
    if (xMin <= 0 && xMax >= 0) {
      final xz = mapX(0);
      canvas.drawLine(
          Offset(xz, 12), Offset(xz, size.height - 12), axisPaint);
    }
    if (yLo <= 0 && yHi >= 0) {
      final yz = mapY(0);
      canvas.drawLine(
          Offset(12, yz), Offset(size.width - 12, yz), axisPaint);
    }

    // Plot.
    final paint = Paint()
      ..color = lineColor
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final path = Path();
    var moved = false;
    for (var i = 0; i <= samples; i++) {
      final x = xMin + (xMax - xMin) * (i / samples);
      final y = f(x);
      if (!y.isFinite) {
        moved = false;
        continue;
      }
      final px = mapX(x);
      final py = mapY(y.clamp(yLo, yHi));
      if (!moved) {
        path.moveTo(px, py);
        moved = true;
      } else {
        path.lineTo(px, py);
      }
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_FunctionPainter old) =>
      old.xMin != xMin ||
      old.xMax != xMax ||
      old.yMin != yMin ||
      old.yMax != yMax;
}
