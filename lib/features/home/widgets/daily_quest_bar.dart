/// Daily quest bar pinned below the home header (Spec §5.4).
///
/// Collapsed: 3 progress pips. Expanded: full quest descriptions + progress.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/services/haptic_service.dart';
import '../../../gamification/quests/quest_models.dart';
import '../../../gamification/quests/quest_provider.dart';

class DailyQuestBar extends ConsumerStatefulWidget {
  const DailyQuestBar({super.key});

  @override
  ConsumerState<DailyQuestBar> createState() => _DailyQuestBarState();
}

class _DailyQuestBarState extends ConsumerState<DailyQuestBar> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final quests = ref.watch(questControllerProvider);
    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Material(
        color: colors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppConstants.radiusM),
        child: InkWell(
          onTap: () {
            ref.read(hapticServiceProvider).selection();
            setState(() => _expanded = !_expanded);
          },
          borderRadius: BorderRadius.circular(AppConstants.radiusM),
          child: AnimatedSize(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOutCubic,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text('Daily quests',
                          style: text.titleSmall
                              ?.copyWith(fontWeight: FontWeight.w700)),
                      const Spacer(),
                      ..._buildPips(context, quests),
                      const SizedBox(width: 8),
                      Icon(
                        _expanded
                            ? Icons.keyboard_arrow_up_rounded
                            : Icons.keyboard_arrow_down_rounded,
                        color: colors.onSurfaceVariant,
                      ),
                    ],
                  ),
                  if (_expanded) ...[
                    const SizedBox(height: 12),
                    for (final q in quests) _QuestRow(quest: q),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildPips(BuildContext context, List<DailyQuest> quests) {
    final colors = Theme.of(context).colorScheme;
    return [
      for (final q in quests)
        Padding(
          padding: const EdgeInsets.only(left: 4),
          child: Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              color: q.completed
                  ? colors.primary
                  : colors.surfaceContainerHighest,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: q.completed
                ? Icon(Icons.check_rounded,
                    size: 12, color: colors.onPrimary)
                : null,
          ),
        ),
    ];
  }
}

class _QuestRow extends StatelessWidget {
  const _QuestRow({required this.quest});
  final DailyQuest quest;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  quest.label,
                  style: text.bodyMedium?.copyWith(
                    color: quest.completed
                        ? colors.onSurfaceVariant
                        : colors.onSurface,
                    decoration: quest.completed
                        ? TextDecoration.lineThrough
                        : null,
                  ),
                ),
              ),
              Text('💎 ${quest.gemReward}',
                  style: text.labelMedium),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: quest.fraction,
              minHeight: 8,
              backgroundColor: colors.surfaceContainerHighest,
              valueColor: AlwaysStoppedAnimation(colors.primary),
            ),
          ),
        ],
      ),
    );
  }
}
