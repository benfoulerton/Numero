/// Avatar picker (Spec §14.1) — selection from illustrated characters,
/// no camera access required.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/haptic_service.dart';
import '../../../core/services/storage_service.dart';

class AvatarPicker extends ConsumerWidget {
  const AvatarPicker({super.key});

  static const _avatars = <_AvatarOption>[
    _AvatarOption('fox', '🦊'),
    _AvatarOption('bear', '🐻'),
    _AvatarOption('cat', '🐱'),
    _AvatarOption('dog', '🐶'),
    _AvatarOption('owl', '🦉'),
    _AvatarOption('panda', '🐼'),
    _AvatarOption('penguin', '🐧'),
    _AvatarOption('frog', '🐸'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storage = ref.watch(storageServiceProvider);
    final colors = Theme.of(context).colorScheme;
    final selected = storage.avatarId;

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        for (final a in _avatars)
          GestureDetector(
            onTap: () async {
              ref.read(hapticServiceProvider).selection();
              await storage.setAvatarId(a.id);
              // Force rebuild — storage provider isn't reactive on this key.
              (context as Element).markNeedsBuild();
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: selected == a.id
                    ? colors.primary
                    : colors.surfaceContainerHigh,
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected == a.id ? colors.primary : Colors.transparent,
                  width: 3,
                ),
              ),
              alignment: Alignment.center,
              child: Text(a.emoji,
                  style: const TextStyle(fontSize: 28)),
            ),
          ),
      ],
    );
  }
}

class _AvatarOption {
  const _AvatarOption(this.id, this.emoji);
  final String id;
  final String emoji;
}
