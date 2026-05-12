/// Home screen (Spec §5).
///
/// Layout: header (streak/XP/hearts) on top, daily quest bar pinned below,
/// path map scrollable beneath.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/services/storage_service.dart';
import '../../data/placeholder/placeholder_path.dart';
import 'widgets/daily_quest_bar.dart';
import 'widgets/home_header_bar.dart';
import 'widgets/path_map.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final name = ref.watch(storageServiceProvider).displayName ?? '';
    final text = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;

    return SafeArea(
      child: Column(
        children: [
          const HomeHeaderBar(),
          const DailyQuestBar(),
          if (name.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Hi, $name 👋',
                  style: text.titleMedium?.copyWith(
                      color: colors.onSurfaceVariant,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
          const Expanded(
            child: PathMap(entries: PlaceholderPath.entries),
          ),
        ],
      ),
    );
  }
}
