/// Placeholder path content for the home screen.
///
/// Spec rule: no real curriculum content in Part One. These nodes use
/// generic labels and icons so the shell can be navigated end-to-end without
/// exposing any lesson material.
library;

import 'package:flutter/material.dart';

import '../features/home/models/path_node_data.dart';

class PlaceholderPath {
  const PlaceholderPath._();

  static const entries = <PathEntry>[
    BannerEntry(WorldBannerData(
      id: 'world_demo_a',
      title: 'Demo World A',
      subtitle: 'Try the shell here',
    )),
    NodeEntry(PathNodeData(
      id: 'node_1',
      title: 'Demo lesson 1',
      icon: Icons.spa_rounded,
      status: PathNodeStatus.completed,
      crownLevel: 3,
    )),
    NodeEntry(PathNodeData(
      id: 'node_2',
      title: 'Demo lesson 2',
      icon: Icons.eco_rounded,
      status: PathNodeStatus.completed,
      crownLevel: 2,
    )),
    NodeEntry(PathNodeData(
      id: 'node_3',
      title: 'Demo lesson 3',
      icon: Icons.bolt_rounded,
      status: PathNodeStatus.active,
      crownLevel: 0,
    )),
    NodeEntry(PathNodeData(
      id: 'node_4',
      title: 'Demo lesson 4',
      icon: Icons.water_drop_rounded,
      status: PathNodeStatus.locked,
      crownLevel: 0,
    )),
    BannerEntry(WorldBannerData(
      id: 'world_demo_b',
      title: 'Demo World B',
      subtitle: 'Locked',
    )),
    NodeEntry(PathNodeData(
      id: 'node_5',
      title: 'Demo lesson 5',
      icon: Icons.cloud_rounded,
      status: PathNodeStatus.locked,
      crownLevel: 0,
    )),
    NodeEntry(PathNodeData(
      id: 'node_6',
      title: 'Demo lesson 6',
      icon: Icons.diamond_rounded,
      status: PathNodeStatus.locked,
      crownLevel: 0,
    )),
  ];
}
