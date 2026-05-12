/// Achievements grid (Spec §14.1). Locked achievements show greyed out
/// with a '?' icon.
library;

import 'package:flutter/material.dart';

class AchievementsGrid extends StatelessWidget {
  const AchievementsGrid({super.key});

  static const _placeholders = <_Achievement>[
    _Achievement('First steps', 'Complete your first lesson', false),
    _Achievement('On fire', 'Reach a 3-day streak', false),
    _Achievement('Marathon', 'Reach a 30-day streak', false),
    _Achievement('Perfectionist', 'Get a perfect lesson', false),
    _Achievement('Explorer', 'Try every interaction', false),
    _Achievement('Night owl', 'Practice after 10pm', false),
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.95,
      ),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _placeholders.length,
      itemBuilder: (context, i) => _AchievementTile(item: _placeholders[i]),
    );
  }
}

class _Achievement {
  const _Achievement(this.name, this.description, this.unlocked);
  final String name;
  final String description;
  final bool unlocked;
}

class _AchievementTile extends StatelessWidget {
  const _AchievementTile({required this.item});
  final _Achievement item;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final unlocked = item.unlocked;

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: unlocked
                  ? colors.tertiaryContainer
                  : colors.surfaceContainerHighest,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Icon(
              unlocked
                  ? Icons.emoji_events_rounded
                  : Icons.question_mark_rounded,
              color: unlocked
                  ? colors.onTertiaryContainer
                  : colors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            unlocked ? item.name : '???',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color:
                  unlocked ? colors.onSurface : colors.onSurfaceVariant,
              fontSize: 12,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
