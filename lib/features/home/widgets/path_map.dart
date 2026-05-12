/// Vertically scrollable path map (Spec §5.2).
///
/// Nodes alternate left/right of centre to give the winding "trail"
/// feel; banners span the full width.
library;

import 'package:flutter/material.dart';

import '../models/path_node_data.dart';
import 'node_popover.dart';
import 'path_node.dart';
import 'path_trail_painter.dart';
import 'world_banner.dart';

class PathMap extends StatelessWidget {
  const PathMap({super.key, required this.entries});

  final List<PathEntry> entries;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      // Compute node positions for the trail painter and for placement.
      final centres = <Offset>[];
      final items = <_PositionedEntry>[];

      const verticalGap = 24.0;
      const nodeArea = 92.0; // height reserved per node including padding
      const bannerHeight = 112.0; // approximate

      double y = 0;
      var nodeIndex = 0;

      for (final entry in entries) {
        if (entry is BannerEntry) {
          items.add(_PositionedEntry(
            top: y,
            child: WorldBanner(banner: entry.banner),
            isBanner: true,
          ));
          y += bannerHeight + verticalGap;
          continue;
        }
        if (entry is NodeEntry) {
          // Alternate horizontal offset for the winding effect.
          final offset = _xOffsetFor(nodeIndex, constraints.maxWidth);
          final centreX = constraints.maxWidth / 2 + offset;
          final centreY = y + nodeArea / 2;
          centres.add(Offset(centreX, centreY));

          items.add(_PositionedEntry(
            top: y,
            child: Center(
              child: Transform.translate(
                offset: Offset(offset, 0),
                child: PathNode(
                  data: entry.node,
                  onTap: () => _openNode(context, entry.node),
                ),
              ),
            ),
          ));
          y += nodeArea + verticalGap;
          nodeIndex++;
        }
      }

      final totalHeight = y + 80;
      // Determine how many of the inter-node segments are "completed".
      final completedThroughIndex = _completedSegmentCount(entries);

      return SingleChildScrollView(
        padding: EdgeInsets.zero,
        child: SizedBox(
          height: totalHeight,
          width: constraints.maxWidth,
          child: Stack(
            children: [
              // The trail painter behind everything.
              Positioned.fill(
                child: RepaintBoundary(
                  child: CustomPaint(
                    painter: PathTrailPainter(
                      nodeCenters: centres,
                      color: Theme.of(context).colorScheme.primary,
                      completedThroughIndex: completedThroughIndex,
                    ),
                  ),
                ),
              ),
              for (final item in items)
                Positioned(
                  top: item.top,
                  left: 0,
                  right: 0,
                  child: item.child,
                ),
            ],
          ),
        ),
      );
    });
  }

  double _xOffsetFor(int index, double width) {
    final amplitude = (width * 0.18).clamp(40.0, 80.0);
    return switch (index % 4) {
      0 => 0,
      1 => amplitude,
      2 => 0,
      _ => -amplitude,
    };
  }

  int _completedSegmentCount(List<PathEntry> entries) {
    final nodes = <PathNodeData>[];
    for (final e in entries) {
      if (e is NodeEntry) nodes.add(e.node);
    }
    var count = 0;
    for (var i = 0; i < nodes.length - 1; i++) {
      if (nodes[i].status == PathNodeStatus.completed) count++;
    }
    return count;
  }

  void _openNode(BuildContext context, PathNodeData node) {
    showModalBottomSheet(
      context: context,
      showDragHandle: false,
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHigh,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) => NodePopover(data: node),
    );
  }
}

class _PositionedEntry {
  const _PositionedEntry({
    required this.top,
    required this.child,
    this.isBanner = false,
  });

  final double top;
  final Widget child;
  final bool isBanner;
}
