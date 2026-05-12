/// Popover shown when a completed node is tapped (Spec §5.2):
/// unit name, crown level, and Practice / Continue buttons.
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/routes.dart';
import '../../../core/widgets/numero_button.dart';
import '../models/path_node_data.dart';

class NodePopover extends StatelessWidget {
  const NodePopover({super.key, required this.data});

  final PathNodeData data;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final isActive = data.status == PathNodeStatus.active;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Drag handle.
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: colors.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: colors.primaryContainer,
                  borderRadius: BorderRadius.circular(18),
                ),
                alignment: Alignment.center,
                child: Icon(data.icon,
                    color: colors.onPrimaryContainer, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(data.title,
                        style: text.titleLarge
                            ?.copyWith(fontWeight: FontWeight.w800)),
                    const SizedBox(height: 4),
                    Text('Crown level ${data.crownLevel} of 5',
                        style: text.bodyMedium?.copyWith(
                            color: colors.onSurfaceVariant)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          if (data.status != PathNodeStatus.locked) ...[
            NumeroButton(
              label: isActive ? 'Start lesson' : 'Continue',
              icon: Icons.play_arrow_rounded,
              onPressed: () {
                Navigator.of(context).pop();
                context.push(Routes.lesson(data.id));
              },
            ),
            const SizedBox(height: 12),
            if (data.status == PathNodeStatus.completed)
              NumeroButton(
                label: 'Practice',
                icon: Icons.refresh_rounded,
                variant: NumeroButtonVariant.tonal,
                onPressed: () {
                  Navigator.of(context).pop();
                  context.push(Routes.lesson(data.id));
                },
              ),
          ] else
            NumeroButton(
              label: 'Locked',
              variant: NumeroButtonVariant.outlined,
              onPressed: null,
            ),
        ],
      ),
    );
  }
}
