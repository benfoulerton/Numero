/// Place-value blocks diagram — ones, tens, hundreds.
///
/// Priority-1 diagram (Spec §11.3). Used from early arithmetic.
library;

import 'package:flutter/material.dart';

import '../diagram_container.dart';

class PlaceValueBlocks extends StatelessWidget {
  const PlaceValueBlocks({
    super.key,
    required this.hundreds,
    required this.tens,
    required this.ones,
  });

  final int hundreds;
  final int tens;
  final int ones;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return DiagramContainer(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: LayoutBuilder(builder: (context, c) {
          final unit = (c.maxWidth / 12).clamp(8.0, 18.0);
          return Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (hundreds > 0) ...[
                _Stack(
                  count: hundreds,
                  builder: (_) => _Square(
                      size: unit * 10, color: colors.tertiaryContainer),
                ),
                const SizedBox(width: 16),
              ],
              if (tens > 0) ...[
                _Stack(
                  count: tens,
                  builder: (_) => Container(
                    width: unit,
                    height: unit * 10,
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    decoration: BoxDecoration(
                      color: colors.secondaryContainer,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  axis: Axis.horizontal,
                ),
                const SizedBox(width: 16),
              ],
              if (ones > 0)
                _Stack(
                  count: ones,
                  builder: (_) => Container(
                    width: unit,
                    height: unit,
                    margin: const EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      color: colors.primaryContainer,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  axis: Axis.horizontal,
                  wrap: true,
                ),
            ],
          );
        }),
      ),
    );
  }
}

class _Square extends StatelessWidget {
  const _Square({required this.size, required this.color});
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

class _Stack extends StatelessWidget {
  const _Stack({
    required this.count,
    required this.builder,
    this.axis = Axis.horizontal,
    this.wrap = false,
  });

  final int count;
  final WidgetBuilder builder;
  final Axis axis;
  final bool wrap;

  @override
  Widget build(BuildContext context) {
    final children = List.generate(count, builder);
    if (wrap) {
      return Wrap(direction: axis, children: children);
    }
    return axis == Axis.horizontal
        ? Row(mainAxisSize: MainAxisSize.min, children: children)
        : Column(mainAxisSize: MainAxisSize.min, children: children);
  }
}
