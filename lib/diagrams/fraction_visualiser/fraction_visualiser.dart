/// Fraction visualiser — pie or bar diagram for fractions.
///
/// Priority-1 diagram (Spec §11.3).
library;

import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../diagram_container.dart';

enum FractionStyle { pie, bar }

class FractionVisualiser extends StatelessWidget {
  const FractionVisualiser({
    super.key,
    required this.numerator,
    required this.denominator,
    this.style = FractionStyle.pie,
  });

  final int numerator;
  final int denominator;
  final FractionStyle style;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return DiagramContainer(
      child: CustomPaint(
        size: Size.infinite,
        painter: style == FractionStyle.pie
            ? _PiePainter(
                numerator: numerator,
                denominator: denominator,
                fill: colors.primary,
                background: colors.surfaceContainerHighest,
                stroke: colors.outline,
              )
            : _BarPainter(
                numerator: numerator,
                denominator: denominator,
                fill: colors.primary,
                background: colors.surfaceContainerHighest,
                stroke: colors.outline,
              ),
      ),
    );
  }
}

class _PiePainter extends CustomPainter {
  _PiePainter({
    required this.numerator,
    required this.denominator,
    required this.fill,
    required this.background,
    required this.stroke,
  });

  final int numerator;
  final int denominator;
  final Color fill;
  final Color background;
  final Color stroke;

  @override
  void paint(Canvas canvas, Size size) {
    final centre = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - 16;
    final rect = Rect.fromCircle(center: centre, radius: radius);

    // Background.
    canvas.drawCircle(centre, radius, Paint()..color = background);

    // Filled slices.
    final sweepPer = 2 * math.pi / denominator;
    for (var i = 0; i < numerator.clamp(0, denominator); i++) {
      final start = -math.pi / 2 + i * sweepPer;
      canvas.drawArc(rect, start, sweepPer, true, Paint()..color = fill);
    }

    // Divider lines.
    final divider = Paint()
      ..color = stroke
      ..strokeWidth = 2;
    for (var i = 0; i < denominator; i++) {
      final angle = -math.pi / 2 + i * sweepPer;
      canvas.drawLine(
        centre,
        Offset(centre.dx + radius * math.cos(angle),
            centre.dy + radius * math.sin(angle)),
        divider,
      );
    }

    canvas.drawCircle(
      centre,
      radius,
      Paint()
        ..color = stroke
        ..strokeWidth = 3
        ..style = PaintingStyle.stroke,
    );
  }

  @override
  bool shouldRepaint(_PiePainter old) =>
      old.numerator != numerator || old.denominator != denominator;
}

class _BarPainter extends CustomPainter {
  _BarPainter({
    required this.numerator,
    required this.denominator,
    required this.fill,
    required this.background,
    required this.stroke,
  });

  final int numerator;
  final int denominator;
  final Color fill;
  final Color background;
  final Color stroke;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(
      16,
      size.height / 2 - 28,
      size.width - 32,
      56,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(12)),
      Paint()..color = background,
    );
    final segWidth = rect.width / denominator;
    for (var i = 0; i < numerator.clamp(0, denominator); i++) {
      canvas.drawRect(
        Rect.fromLTWH(rect.left + i * segWidth, rect.top, segWidth, rect.height),
        Paint()..color = fill,
      );
    }
    for (var i = 1; i < denominator; i++) {
      final x = rect.left + i * segWidth;
      canvas.drawLine(
        Offset(x, rect.top),
        Offset(x, rect.bottom),
        Paint()
          ..color = stroke
          ..strokeWidth = 2,
      );
    }
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(12)),
      Paint()
        ..color = stroke
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
  }

  @override
  bool shouldRepaint(_BarPainter old) =>
      old.numerator != numerator || old.denominator != denominator;
}
