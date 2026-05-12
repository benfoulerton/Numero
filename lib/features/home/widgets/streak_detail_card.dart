/// Streak detail card (Spec §5.3): weekly calendar grid + freeze count.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../gamification/streak/streak_provider.dart';

class StreakDetailCard extends ConsumerWidget {
  const StreakDetailCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final streak = ref.watch(streakControllerProvider);
    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final today = DateTime.now();
    final weekDays = List.generate(7, (i) {
      // i=0 oldest in the past week, i=6 today.
      return today.subtract(Duration(days: 6 - i));
    });

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('🔥', style: TextStyle(fontSize: 28)),
              const SizedBox(width: 12),
              Text(
                '${streak.count}-day streak',
                style: text.headlineSmall
                    ?.copyWith(fontWeight: FontWeight.w800),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Longest: ${streak.longest} days',
            style: text.bodyMedium
                ?.copyWith(color: colors.onSurfaceVariant),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (final day in weekDays)
                _DayCell(
                  day: day,
                  // Approximation in placeholder mode: assume completed if
                  // the streak count >= days from `today`.
                  completed:
                      today.difference(day).inDays < streak.count,
                  isToday: day.day == today.day &&
                      day.month == today.month &&
                      day.year == today.year,
                ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Icon(Icons.ac_unit_rounded,
                  color: colors.primary, size: 20),
              const SizedBox(width: 8),
              Text('${streak.freezes} streak freezes available',
                  style: text.bodyMedium),
            ],
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ),
        ],
      ),
    );
  }
}

class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.day,
    required this.completed,
    required this.isToday,
  });

  final DateTime day;
  final bool completed;
  final bool isToday;

  static const _labels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Column(
      children: [
        Text(
          _labels[day.weekday - 1],
          style: TextStyle(
            fontSize: 10,
            color: colors.onSurfaceVariant,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: completed
                ? colors.primaryContainer
                : colors.surfaceContainerHighest,
            shape: BoxShape.circle,
            border: isToday
                ? Border.all(color: colors.primary, width: 2)
                : null,
          ),
          alignment: Alignment.center,
          child: completed
              ? Icon(Icons.check_rounded,
                  size: 18, color: colors.onPrimaryContainer)
              : null,
        ),
      ],
    );
  }
}
