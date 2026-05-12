/// A primary action button styled per Material 3 Expressive, with built-in
/// haptic + tap-sound side effects.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/app_constants.dart';
import '../services/audio_service.dart';
import '../services/haptic_service.dart';

class NumeroButton extends ConsumerWidget {
  const NumeroButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.variant = NumeroButtonVariant.filled,
    this.fullWidth = true,
    this.danger = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final NumeroButtonVariant variant;
  final bool fullWidth;
  final bool danger;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final disabled = onPressed == null;

    void handle() {
      ref.read(hapticServiceProvider).selection();
      onPressed?.call();
    }

    final child = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 20),
          const SizedBox(width: 10),
        ],
        Flexible(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );

    final minSize = Size.fromHeight(AppConstants.minTapTarget + 8);

    switch (variant) {
      case NumeroButtonVariant.filled:
        return FilledButton(
          onPressed: disabled ? null : handle,
          style: FilledButton.styleFrom(
            backgroundColor: danger ? colors.errorContainer : colors.primary,
            foregroundColor: danger ? colors.onErrorContainer : colors.onPrimary,
            minimumSize: minSize,
          ),
          child: child,
        );
      case NumeroButtonVariant.tonal:
        return FilledButton.tonal(
          onPressed: disabled ? null : handle,
          style: FilledButton.styleFrom(minimumSize: minSize),
          child: child,
        );
      case NumeroButtonVariant.outlined:
        return OutlinedButton(
          onPressed: disabled ? null : handle,
          style: OutlinedButton.styleFrom(minimumSize: minSize),
          child: child,
        );
      case NumeroButtonVariant.text:
        return TextButton(
          onPressed: disabled ? null : handle,
          style: TextButton.styleFrom(minimumSize: minSize),
          child: child,
        );
    }
  }
}

enum NumeroButtonVariant { filled, tonal, outlined, text }
