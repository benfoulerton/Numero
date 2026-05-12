/// Reward screen shown at the end of every lesson (Spec §6.4 screen 14).
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/widgets/numero_button.dart';
import '../../../gamification/chests/chest_animation.dart';
import '../../../gamification/chests/chest_provider.dart';
import '../../../gamification/streak/streak_provider.dart';
import '../../../gamification/xp/xp_provider.dart';

class RewardScreen extends ConsumerWidget {
  const RewardScreen({
    super.key,
    required this.perfect,
    required this.onFinish,
  });

  final bool perfect;
  final VoidCallback onFinish;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final xp = ref.watch(xpControllerProvider);
    final streak = ref.watch(streakControllerProvider);
    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final lessons = ref.read(storageServiceProvider).lessonsCompleted;
    final chestDue = ChestProvider.shouldOpenAfter(lessons + 1);

    final earned = AppConstants.xpPerLesson +
        (perfect ? AppConstants.xpPerfectLessonBonus : 0) +
        (!streak.completedToday ? AppConstants.xpStreakBonus : 0);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const Spacer(),
          Text(
            'Lesson complete.',
            style:
                text.displaySmall?.copyWith(fontWeight: FontWeight.w800),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: colors.primaryContainer,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.bolt_rounded,
                    color: colors.onPrimaryContainer, size: 36),
                const SizedBox(width: 12),
                Text(
                  '+$earned XP',
                  style: text.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: colors.onPrimaryContainer,
                  ),
                ),
              ],
            ),
          ),
          if (perfect) ...[
            const SizedBox(height: 12),
            Text('Perfect lesson! +5 bonus XP',
                style: text.bodyMedium
                    ?.copyWith(color: colors.tertiary)),
          ],
          const SizedBox(height: 12),
          Text('${xp.total} XP total · ${streak.count}-day streak 🔥',
              style: text.bodyMedium?.copyWith(
                  color: colors.onSurfaceVariant)),
          if (chestDue) ...[
            const SizedBox(height: 32),
            ChestAnimation(reward: ChestProvider.roll(), size: 180),
          ],
          const Spacer(),
          NumeroButton(
            label: 'Continue',
            icon: Icons.check_rounded,
            onPressed: onFinish,
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
