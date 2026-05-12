/// A single path node on the home path map (Spec §5.2).
///
/// - completed: filled with primary, crown ring shown.
/// - active: pulses gently (scale 1.0 -> 1.06 -> 1.0).
/// - locked: greyed out, non-interactive.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/accessibility_service.dart';
import '../../../core/services/haptic_service.dart';
import '../models/path_node_data.dart';

class PathNode extends ConsumerStatefulWidget {
  const PathNode({
    super.key,
    required this.data,
    required this.onTap,
    this.size = 76,
  });

  final PathNodeData data;
  final VoidCallback onTap;
  final double size;

  @override
  ConsumerState<PathNode> createState() => _PathNodeState();
}

class _PathNodeState extends ConsumerState<PathNode>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 1400))
        ..repeat(reverse: true);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final reduced =
        ref.read(accessibilityServiceProvider).reducedMotion(context);
    if (reduced && _pulse.isAnimating) {
      _pulse
        ..stop()
        ..value = 0;
    }
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final data = widget.data;
    final isActive = data.status == PathNodeStatus.active;
    final isCompleted = data.status == PathNodeStatus.completed;
    final isLocked = data.status == PathNodeStatus.locked;

    final fill = isLocked
        ? colors.surfaceContainerHigh
        : isCompleted
            ? colors.primary
            : colors.primaryContainer;
    final iconColor = isLocked
        ? colors.onSurfaceVariant
        : isCompleted
            ? colors.onPrimary
            : colors.onPrimaryContainer;

    return Semantics(
      button: !isLocked,
      label: '${data.title}, ${data.status.name}',
      enabled: !isLocked,
      child: AnimatedBuilder(
        animation: _pulse,
        builder: (context, child) {
          final scale = isActive ? 1.0 + 0.06 * _pulse.value : 1.0;
          return Transform.scale(scale: scale, child: child);
        },
        child: GestureDetector(
          onTap: isLocked
              ? null
              : () {
                  ref.read(hapticServiceProvider).selection();
                  widget.onTap();
                },
          behavior: HitTestBehavior.opaque,
          child: SizedBox(
            width: widget.size + 16,
            height: widget.size + 16,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Crown ring (only for completed nodes).
                if (isCompleted) _CrownRing(level: data.crownLevel),
                Container(
                  width: widget.size,
                  height: widget.size,
                  decoration: BoxDecoration(
                    color: fill,
                    shape: BoxShape.circle,
                    boxShadow: isLocked
                        ? null
                        : [
                            BoxShadow(
                              color: fill.withValues(alpha: 0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    isLocked ? Icons.lock_rounded : data.icon,
                    size: 32,
                    color: iconColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CrownRing extends StatelessWidget {
  const _CrownRing({required this.level});
  final int level;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return CustomPaint(
      size: const Size(92, 92),
      painter: _CrownRingPainter(
        level: level,
        color: colors.tertiary,
        background: colors.surfaceContainerHigh,
      ),
    );
  }
}

class _CrownRingPainter extends CustomPainter {
  _CrownRingPainter({
    required this.level,
    required this.color,
    required this.background,
  });

  final int level;
  final Color color;
  final Color background;

  @override
  void paint(Canvas canvas, Size size) {
    final centre = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 2;

    final paintBg = Paint()
      ..color = background
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;
    final paintFg = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    const segments = 5;
    const gap = 0.10; // radians between segments
    final segmentSweep = (2 * 3.14159265 - segments * gap) / segments;

    for (var i = 0; i < segments; i++) {
      final start = -3.14159265 / 2 + i * (segmentSweep + gap);
      final paint = i < level ? paintFg : paintBg;
      canvas.drawArc(
        Rect.fromCircle(center: centre, radius: radius),
        start,
        segmentSweep,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_CrownRingPainter old) =>
      old.level != level || old.color != color;
}
