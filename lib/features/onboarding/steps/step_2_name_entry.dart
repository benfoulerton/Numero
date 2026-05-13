/// Step 2 — Name entry.
///
/// Single text field, friendly headline, one CTA. The Confirm button is
/// disabled until at least one character is entered.
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/numero_button.dart';
import '../onboarding_controller.dart';

class StepNameEntry extends ConsumerStatefulWidget {
  const StepNameEntry({super.key, required this.onContinue});

  /// `null` disables the Confirm button.
  final VoidCallback? onContinue;

  @override
  ConsumerState<StepNameEntry> createState() => _StepNameEntryState();
}

class _StepNameEntryState extends ConsumerState<StepNameEntry> {
  late final TextEditingController _ctl;
  late final FocusNode _focus;

  @override
  void initState() {
    super.initState();
    final initial = ref.read(onboardingControllerProvider).name;
    _ctl = TextEditingController(text: initial);
    _focus = FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focus.requestFocus();
    });
  }

  @override
  void dispose() {
    _ctl.dispose();
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final controller = ref.read(onboardingControllerProvider.notifier);

    return Padding(
      padding: const EdgeInsets.fromLTRB(28, 24, 28, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Spacer(flex: 2),
          Text(
            "What's your name?",
            textAlign: TextAlign.center,
            style: text.displaySmall?.copyWith(
              fontWeight: FontWeight.w800,
              height: 1.05,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "Just a first name is fine.",
            textAlign: TextAlign.center,
            style: text.bodyLarge?.copyWith(color: colors.onSurfaceVariant),
          ),
          const SizedBox(height: 36),
          TextField(
            controller: _ctl,
            focusNode: _focus,
            autocorrect: false,
            enableSuggestions: false,
            textAlign: TextAlign.center,
            textCapitalization: TextCapitalization.words,
            inputFormatters: [LengthLimitingTextInputFormatter(24)],
            style: text.headlineMedium?.copyWith(fontWeight: FontWeight.w700),
            decoration: InputDecoration(
              filled: true,
              fillColor: colors.surfaceContainerHigh,
              hintText: 'Your name',
              hintStyle: text.headlineMedium?.copyWith(
                color: colors.onSurfaceVariant.withValues(alpha: 0.55),
                fontWeight: FontWeight.w400,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(22),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 22,
              ),
            ),
            onChanged: controller.setName,
            onSubmitted: (_) {
              if (widget.onContinue != null) widget.onContinue!();
            },
          ),
          const Spacer(flex: 3),
          NumeroButton(
            label: 'Confirm',
            icon: Icons.arrow_forward_rounded,
            onPressed: widget.onContinue,
          ),
        ],
      ),
    );
  }
}
