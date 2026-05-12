/// Lesson top bar (Spec §6.1): X button (left), progress bar (centre),
/// heart counter (right).
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/routes.dart';
import '../../../gamification/hearts/hearts_provider.dart';
import 'exit_confirmation_dialog.dart';
import 'segmented_progress_bar.dart';

class LessonTopBar extends ConsumerWidget {
  const LessonTopBar({
    super.key,
    required this.totalSegments,
    required this.completedSegments,
  });

  final int totalSegments;
  final int completedSegments;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hearts = ref.watch(heartsControllerProvider);
    final colors = Theme.of(context).colorScheme;

    Future<void> handleExit() async {
      final leave = await ExitConfirmationDialog.show(context);
      if (leave && context.mounted) {
        context.go(Routes.home);
      }
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 16, 8),
      child: Row(
        children: [
          IconButton(
            onPressed: handleExit,
            icon: const Icon(Icons.close_rounded, size: 28),
            tooltip: 'Exit lesson',
          ),
          const SizedBox(width: 4),
          Expanded(
            child: SegmentedProgressBar(
              totalSegments: totalSegments,
              completedSegments: completedSegments,
            ),
          ),
          const SizedBox(width: 12),
          Row(
            children: [
              Icon(
                Icons.favorite_rounded,
                color: hearts.disabled
                    ? colors.onSurfaceVariant
                    : colors.error,
                size: 20,
              ),
              const SizedBox(width: 4),
              Text(
                hearts.disabled ? '∞' : '${hearts.count}',
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
