/// Data describing a single skill node on the home path map.
library;

import 'package:flutter/material.dart';

enum PathNodeStatus { completed, active, locked }

class PathNodeData {
  const PathNodeData({
    required this.id,
    required this.title,
    required this.icon,
    required this.status,
    required this.crownLevel,
  });

  final String id;
  final String title;
  final IconData icon;
  final PathNodeStatus status;
  final int crownLevel; // 0-5
}

class WorldBannerData {
  const WorldBannerData({
    required this.id,
    required this.title,
    required this.subtitle,
  });

  final String id;
  final String title;
  final String subtitle;
}

/// An entry on the path: either a [PathNodeData] or a [WorldBannerData].
sealed class PathEntry {
  const PathEntry();
}

class NodeEntry extends PathEntry {
  const NodeEntry(this.node);
  final PathNodeData node;
}

class BannerEntry extends PathEntry {
  const BannerEntry(this.banner);
  final WorldBannerData banner;
}
