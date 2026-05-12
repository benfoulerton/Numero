/// Home screen header bar (Spec §5.3).
///
/// Streak (flame + count), total XP (bolt + count), Hearts (heart + count).
/// Each is tappable and shows a popover with details.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/services/haptic_service.dart';
import '../../../core/widgets/animated_counter.dart';
import '../../../gamification/hearts/hearts_provider.dart';
import '../../../gamification/streak/streak_provider.dart';
import '../../../gamification/xp/xp_provider.dart';
import 'streak_detail_card.dart';

class HomeHeaderBar extends ConsumerWidget {
  const HomeHeaderBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final streak = ref.watch(streakControllerProvider);
    final xp = ref.watch(xpControllerProvider);
    final hearts = ref.watch(heartsControllerProvider);
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Row(
        children: [
          _HeaderChip(
            icon: '🔥',
            value: streak.count,
            label: 'streak',
            color: colors.tertiaryContainer,
            onColor: colors.onTertiaryContainer,
            onTap: () => _showStreakDetail(context, ref),
          ),
          const SizedBox(width: 8),
          _HeaderChip(
            icon: '⚡',
            value: xp.total,
            label: 'XP',
            color: colors.primaryContainer,
            onColor: colors.onPrimaryContainer,
            onTap: () => _showXpDetail(context, ref),
          ),
          const Spacer(),
          _HeartsChip(
            current: hearts.count,
            disabled: hearts.disabled,
            onTap: () => _showHeartsInfo(context, ref),
          ),
        ],
      ),
    );
  }

  void _showStreakDetail(BuildContext context, WidgetRef ref) {
    ref.read(hapticServiceProvider).selection();
    showDialog(
      context: context,
      builder: (_) => const Dialog(
        insetPadding: EdgeInsets.all(24),
        child: StreakDetailCard(),
      ),
    );
  }

  void _showXpDetail(BuildContext context, WidgetRef ref) {
    ref.read(hapticServiceProvider).selection();
    final xp = ref.read(xpControllerProvider);
    showModalBottomSheet(
      context: context,
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Your XP',
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(fontWeight: FontWeight.w800)),
            const SizedBox(height: 16),
            Text('Total: ${xp.total} XP'),
            const SizedBox(height: 4),
            Text('Today: ${xp.today} XP'),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  void _showHeartsInfo(BuildContext context, WidgetRef ref) {
    ref.read(hapticServiceProvider).selection();
    final hearts = ref.read(heartsControllerProvider);
    final disabled = hearts.disabled;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Hearts'),
        content: Text(
          disabled
              ? "You can't lose hearts yet — they're disabled for your first 10 lessons."
              : "You have ${hearts.count} of ${AppConstants.maxHearts} hearts. "
                  "You lose one for each wrong answer. They refill with a Practice "
                  "session, in 30 minutes, or for ${AppConstants.heartRefillGemCost} gems.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }
}

class _HeaderChip extends StatelessWidget {
  const _HeaderChip({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
    required this.onColor,
    required this.onTap,
  });

  final String icon;
  final int value;
  final String label;
  final Color color;
  final Color onColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(AppConstants.radiusPill),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConstants.radiusPill),
        child: Semantics(
          label: '$value $label',
          button: true,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(icon, style: const TextStyle(fontSize: 16)),
                const SizedBox(width: 6),
                AnimatedCounter(
                  value: value,
                  style: TextStyle(
                    color: onColor,
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
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

class _HeartsChip extends StatelessWidget {
  const _HeartsChip({
    required this.current,
    required this.disabled,
    required this.onTap,
  });

  final int current;
  final bool disabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Material(
      color: disabled
          ? colors.surfaceContainerHigh
          : colors.errorContainer,
      borderRadius: BorderRadius.circular(AppConstants.radiusPill),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConstants.radiusPill),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.favorite_rounded,
                size: 16,
                color: disabled ? colors.onSurfaceVariant : colors.error,
              ),
              const SizedBox(width: 6),
              Text(
                disabled ? '∞' : '$current',
                style: TextStyle(
                  color: disabled
                      ? colors.onSurfaceVariant
                      : colors.onErrorContainer,
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
