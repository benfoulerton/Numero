/// Practice tab (Spec §10.2). Shows the current review queue.
///
/// In v1 with no real curriculum, the queue is typically empty. The empty
/// state is friendly and encouraging.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/routes.dart';
import '../../core/widgets/numero_button.dart';
import '../../spaced_repetition/review_queue.dart';

class PracticeScreen extends ConsumerWidget {
  const PracticeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final queue = ref.watch(reviewQueueProvider);
    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Practice',
                style: text.displaySmall
                    ?.copyWith(fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            Text('Review what you’ve learned.',
                style: text.bodyLarge
                    ?.copyWith(color: colors.onSurfaceVariant)),
            const SizedBox(height: 24),
            Expanded(
              child: queue.when(
                data: (items) => items.isEmpty
                    ? _EmptyState()
                    : ListView.separated(
                        itemCount: items.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: 12),
                        itemBuilder: (context, i) {
                          final r = items[i];
                          return Material(
                            color: colors.surfaceContainerHigh,
                            borderRadius: BorderRadius.circular(16),
                            child: InkWell(
                              onTap: () =>
                                  context.push(Routes.lesson(r.lessonId)),
                              borderRadius: BorderRadius.circular(16),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 44,
                                      height: 44,
                                      decoration: BoxDecoration(
                                        color: colors.primaryContainer,
                                        borderRadius:
                                            BorderRadius.circular(14),
                                      ),
                                      alignment: Alignment.center,
                                      child: Icon(Icons.refresh_rounded,
                                          color:
                                              colors.onPrimaryContainer),
                                    ),
                                    const SizedBox(width: 14),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(r.lessonId,
                                              style: text.titleMedium),
                                          const SizedBox(height: 2),
                                          Text(
                                            'Box ${r.box} · due ${r.nextReviewAt.toLocal()}',
                                            style: text.bodySmall?.copyWith(
                                                color: colors
                                                    .onSurfaceVariant),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Icon(Icons.chevron_right_rounded),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                loading: () => const Center(
                    child: CircularProgressIndicator.adaptive()),
                error: (e, _) => Center(child: Text('Could not load: $e')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.coffee_rounded, size: 72, color: colors.primary),
          const SizedBox(height: 16),
          Text('Nothing to review yet.',
              style: text.titleLarge
                  ?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Text(
            "Finish a lesson and you'll see review items here.",
            textAlign: TextAlign.center,
            style: text.bodyMedium
                ?.copyWith(color: colors.onSurfaceVariant),
          ),
          const SizedBox(height: 24),
          NumeroButton(
            label: 'Go to lessons',
            icon: Icons.home_rounded,
            variant: NumeroButtonVariant.tonal,
            fullWidth: false,
            onPressed: () =>
                context.go('/home'),
          ),
        ],
      ),
    );
  }
}
