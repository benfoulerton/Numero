/// Step 2 — Name entry (Spec §4.2 step 2).
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../onboarding_controller.dart';

class StepNameEntry extends ConsumerStatefulWidget {
  const StepNameEntry({super.key});

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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('What should we call you?',
            style: text.displaySmall?.copyWith(fontWeight: FontWeight.w800)),
        const SizedBox(height: 8),
        Text("Just a first name is fine.",
            style: text.bodyLarge?.copyWith(color: colors.onSurfaceVariant)),
        const SizedBox(height: 32),
        TextField(
          controller: _ctl,
          focusNode: _focus,
          autocorrect: false,
          enableSuggestions: false,
          textCapitalization: TextCapitalization.words,
          inputFormatters: [LengthLimitingTextInputFormatter(24)],
          style: text.headlineSmall,
          decoration: InputDecoration(
            filled: true,
            fillColor: colors.surfaceContainerHigh,
            hintText: 'Your name',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
                horizontal: 20, vertical: 18),
          ),
          onChanged: controller.setName,
        ),
      ],
    );
  }
}
