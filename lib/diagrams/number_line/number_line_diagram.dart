/// Number line diagram — a draggable point along a horizontal line.
///
/// Priority-1 diagram (Spec §11.3). Supports zooming and pan via pinch in
/// future work; v1 ships with a fixed range and a draggable point clamped
/// to the bounds.
library;

import 'package:flutter/material.dart';

import '../diagram_container.dart';

class NumberLineDiagram extends StatefulWidget {
  const NumberLineDiagram({
    super.key,
    this.min = 0,
    this.max = 10,
    this.initialValue = 5,
    this.onChanged,
  });

  final double min;
  final double max;
  final double initialValue;
  final ValueChanged<double>? onChanged;

  @override
  State<NumberLineDiagram> createState() => _NumberLineDiagramState();
}

class _NumberLineDiagramState extends State<NumberLineDiagram> {
  late double _value = widget.initialValue;

  void _update(double normalised) {
    final clamped = normalised.clamp(0.0, 1.0);
    final v = widget.min + clamped * (widget.max - widget.min);
    setState(() => _value = v);
    widget.onChanged?.call(v);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return DiagramContainer(
      child: LayoutBuilder(builder: (context, c) {
        final norm =
            (_value - widget.min) / (widget.max - widget.min);
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onPanUpdate: (d) => _update(
            ((norm * c.maxWidth) + d.delta.dx).clamp(0.0, c.maxWidth) /
                c.maxWidth,
          ),
          onTapDown: (d) => _update(d.localPosition.dx / c.maxWidth),
          child: CustomPaint(
            painter: _NumberLinePainter(
              min: widget.min,
              max: widget.max,
              value: _value,
              line: colors.outline,
              tick: colors.outlineVariant,
              point: colors.primary,
              label: colors.onSurface,
            ),
            size: Size.infinite,
          ),
        );
      }),
    );
  }
}

class _NumberLinePainter extends CustomPainter {
  _NumberLinePainter({
    required this.min,
    required this.max,
    required this.value,
    required this.line,
    required this.tick,
    required this.point,
    required this.label,
  });

  final double min;
  final double max;
  final double value;
  final Color line;
  final Color tick;
  final Color point;
  final Color label;

  @override
  void paint(Canvas canvas, Size size) {
    final y = size.height / 2;
    final paintLine = Paint()
      ..color = line
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(12, y), Offset(size.width - 12, y), paintLine);

    final paintTick = Paint()
      ..color = tick
      ..strokeWidth = 2;
    final steps = (max - min).toInt().clamp(1, 20);
    for (var i = 0; i <= steps; i++) {
      final x = 12 + (size.width - 24) * (i / steps);
      canvas.drawLine(Offset(x, y - 6), Offset(x, y + 6), paintTick);

      final tp = TextPainter(
        text: TextSpan(
            text: (min + i).toInt().toString(),
            style: TextStyle(color: label, fontSize: 11)),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(x - tp.width / 2, y + 10));
    }

    final norm = (value - min) / (max - min);
    final px = 12 + (size.width - 24) * norm.clamp(0.0, 1.0);
    canvas.drawCircle(Offset(px, y), 12, Paint()..color = point);
  }

  @override
  bool shouldRepaint(_NumberLinePainter old) =>
      old.value != value || old.min != min || old.max != max;
}
