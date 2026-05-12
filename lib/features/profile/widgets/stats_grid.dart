/// Profile stats grid — total XP, lessons completed, days learned,
/// current streak, longest streak (Spec §14.1).
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/storage_service.dart';
import '../../../gamification/streak/streak_provider.dart';
import '../../../gamification/xp/xp_provider.dart';

class StatsGrid extends ConsumerWidget {
  const StatsGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final xp = ref.watch(xpControllerProvider);
    final streak = ref.watch(streakControllerProvider);
    final storage = ref.watch(storageServiceProvider);

    final tiles = [
      _StatTile(label: 'Total XP', value: '${xp.total}', icon: '⚡'),
      _StatTile(
          label: 'Lessons completed',
          value: '${storage.lessonsCompleted}',
          icon: '📘'),
      _StatTile(
          label: 'Current streak', value: '${streak.count}', icon: '🔥'),
      _StatTile(
          label: 'Longest streak', value: '${streak.longest}', icon: '🏆'),
    ];

    return GridView.count(
      crossAxisCount: 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.4,
      children: tiles,
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final String icon;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(icon, style: const TextStyle(fontSize: 24)),
          const Spacer(),
          Text(value,
              style: text.headlineSmall
                  ?.copyWith(fontWeight: FontWeight.w800)),
          Text(label,
              style: text.bodySmall
                  ?.copyWith(color: colors.onSurfaceVariant)),
        ],
      ),
    );
  }
}
