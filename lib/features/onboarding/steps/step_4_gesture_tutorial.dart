/// Step 4 — Gesture tutorial (Spec §4.2 step 4).
///
/// 3 trivial interactions teach the gesture vocabulary:
///   1. Tap the star.
///   2. Slider drag.
///   3. Drag-to-match pair.
/// Each rewards with a chime and tick. On completion: confetti and exit.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/animation_constants.dart';
import '../../../core/services/audio_service.dart';
import '../../../core/services/haptic_service.dart';
import '../../../core/widgets/confetti_burst.dart';
import '../../../core/widgets/numero_button.dart';

class StepGestureTutorial extends ConsumerStatefulWidget {
  const StepGestureTutorial({super.key, required this.onFinished});

  final Future<void> Function() onFinished;

  @override
  ConsumerState<StepGestureTutorial> createState() =>
      _StepGestureTutorialState();
}

class _StepGestureTutorialState extends ConsumerState<StepGestureTutorial> {
  int _exercise = 0; // 0 tap, 1 slider, 2 match, 3 done
  int _confettiFire = 0;
  double _sliderValue = 0.1;
  String? _selectedLeft;
  String? _selectedRight;
  final _pairs = const {'1': 'one', '2': 'two', '3': 'three'};

  void _complete() {
    ref.read(hapticServiceProvider).correct();
    ref.read(audioServiceProvider).play(SoundEffect.correct);
    setState(() {
      _exercise++;
      if (_exercise == 3) _confettiFire++;
    });
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;

    final body = AnimatedSwitcher(
      duration: AnimationConstants.medium,
      child: Container(
        key: ValueKey(_exercise),
        alignment: Alignment.center,
        child: switch (_exercise) {
          0 => _TapExercise(onTap: _complete),
          1 => _SliderExercise(
              value: _sliderValue,
              onChanged: (v) {
                setState(() => _sliderValue = v);
                if (v > 0.85) _complete();
              },
            ),
          2 => _MatchExercise(
              pairs: _pairs,
              selectedLeft: _selectedLeft,
              selectedRight: _selectedRight,
              onLeftSelected: (s) => setState(() => _selectedLeft = s),
              onRightSelected: (s) {
                setState(() => _selectedRight = s);
                if (_selectedLeft != null &&
                    _pairs[_selectedLeft!] == s) {
                  _complete();
                }
              },
            ),
          _ => _Done(),
        },
      ),
    );

    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_titleFor(_exercise),
                style: text.displaySmall
                    ?.copyWith(fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            Text(_subtitleFor(_exercise),
                style: text.bodyLarge
                    ?.copyWith(color: colors.onSurfaceVariant)),
            const SizedBox(height: 12),
            Expanded(child: body),
            if (_exercise >= 3)
              NumeroButton(
                label: "Let's go!",
                icon: Icons.rocket_launch_rounded,
                onPressed: () => widget.onFinished(),
              ),
          ],
        ),
        IgnorePointer(child: ConfettiBurst(fire: _confettiFire)),
      ],
    );
  }

  String _titleFor(int i) => switch (i) {
        0 => 'Tap the star.',
        1 => 'Drag the slider.',
        2 => 'Match the pair.',
        _ => "You're ready.",
      };

  String _subtitleFor(int i) => switch (i) {
        0 => 'A gentle tap is all it takes.',
        1 => 'Slide it all the way to the right.',
        2 => 'Pick a number, then its word.',
        _ => 'Time to learn some maths.',
      };
}

class _TapExercise extends StatelessWidget {
  const _TapExercise({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 140,
          height: 140,
          decoration: BoxDecoration(
            color: colors.primaryContainer,
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.star_rounded,
              size: 80, color: colors.onPrimaryContainer),
        ),
      ),
    );
  }
}

class _SliderExercise extends StatelessWidget {
  const _SliderExercise({required this.value, required this.onChanged});
  final double value;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.swipe_right_alt_rounded,
              size: 80,
              color: Theme.of(context).colorScheme.primary),
          const SizedBox(height: 32),
          Slider(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}

class _MatchExercise extends StatelessWidget {
  const _MatchExercise({
    required this.pairs,
    required this.selectedLeft,
    required this.selectedRight,
    required this.onLeftSelected,
    required this.onRightSelected,
  });

  final Map<String, String> pairs;
  final String? selectedLeft;
  final String? selectedRight;
  final ValueChanged<String> onLeftSelected;
  final ValueChanged<String> onRightSelected;

  @override
  Widget build(BuildContext context) {
    final lefts = pairs.keys.toList();
    final rights = pairs.values.toList()..shuffle();
    return Row(
      children: [
        Expanded(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (final l in lefts)
                    _Tile(
                      label: l,
                      selected: selectedLeft == l,
                      onTap: () => onLeftSelected(l),
                    ),
                ])),
        const SizedBox(width: 16),
        Expanded(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (final r in rights)
                    _Tile(
                      label: r,
                      selected: selectedRight == r,
                      onTap: () => onRightSelected(r),
                    ),
                ])),
      ],
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile(
      {required this.label, required this.selected, required this.onTap});
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Material(
        color: selected ? colors.primary : colors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            height: 56,
            alignment: Alignment.center,
            child: Text(
              label,
              style: TextStyle(
                color: selected ? colors.onPrimary : colors.onSurface,
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Done extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.celebration_rounded,
            size: 96, color: Theme.of(context).colorScheme.primary),
        const SizedBox(height: 24),
        Text(
          'Nice gestures.',
          style: Theme.of(context)
              .textTheme
              .headlineMedium
              ?.copyWith(fontWeight: FontWeight.w800),
        ),
      ],
    );
  }
}
