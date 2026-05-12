/// Profile screen (Spec §14.1).
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/routes.dart';
import '../../core/services/storage_service.dart';
import '../../core/theme/theme_presets.dart';
import '../../core/theme/theme_provider.dart';
import '../../data/models/daily_goal.dart';
import 'widgets/achievements_grid.dart';
import 'widgets/avatar_picker.dart';
import 'widgets/stats_grid.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storage = ref.watch(storageServiceProvider);
    final theme = ref.watch(themeControllerProvider);
    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final goal = DailyGoal.fromMinutes(storage.dailyGoalMinutes);

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('Profile',
                    style: text.displaySmall
                        ?.copyWith(fontWeight: FontWeight.w800)),
                const Spacer(),
                IconButton.filledTonal(
                  onPressed: () => context.push(Routes.settings),
                  icon: const Icon(Icons.settings_rounded),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Text(
                  storage.displayName ?? 'Learner',
                  style: text.headlineMedium
                      ?.copyWith(fontWeight: FontWeight.w800),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const StatsGrid(),
            const SizedBox(height: 24),
            Text('Pick an avatar',
                style: text.titleMedium
                    ?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            const AvatarPicker(),
            const SizedBox(height: 24),
            Text('Daily goal',
                style: text.titleMedium
                    ?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final g in DailyGoal.values)
                  ChoiceChip(
                    label: Text('${g.label} (${g.minutes} min)'),
                    selected: goal == g,
                    onSelected: (_) async {
                      await storage.setDailyGoalMinutes(g.minutes);
                      (context as Element).markNeedsBuild();
                    },
                  ),
              ],
            ),
            const SizedBox(height: 24),
            Text('Theme',
                style: text.titleMedium
                    ?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final p in ThemePreset.values)
                  ChoiceChip(
                    avatar: CircleAvatar(backgroundColor: p.seed, radius: 8),
                    label: Text(p.label),
                    selected: theme.preset == p,
                    onSelected: (_) {
                      ref
                          .read(themeControllerProvider.notifier)
                          .setPreset(p);
                    },
                  ),
              ],
            ),
            const SizedBox(height: 24),
            Text('Achievements',
                style: text.titleMedium
                    ?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            const AchievementsGrid(),
            const SizedBox(height: 32),
            Center(
              child: Text(
                'Numero · keep going',
                style: text.labelSmall
                    ?.copyWith(color: colors.onSurfaceVariant),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
