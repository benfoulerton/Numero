/// Tap-to-match (Spec §7.1).
///
/// Two columns of tiles. Pairs from one column match items in the other.
/// Tapping a left tile then its correct right tile creates a pair that
/// snaps away. Max 4 pairs (8 tiles).
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/services/audio_service.dart';
import '../../../core/services/haptic_service.dart';
import '../../../core/widgets/spring_scale.dart';
import 'interaction_types.dart';

class TapToMatch extends ConsumerStatefulWidget {
  const TapToMatch({
    super.key,
    required this.config,
    required this.onAnswer,
  });

  final TapToMatchConfig config;
  final AnswerCallback onAnswer;

  @override
  ConsumerState<TapToMatch> createState() => _TapToMatchState();
}

class _TapToMatchState extends ConsumerState<TapToMatch> {
  late final List<String> _lefts =
      widget.config.pairs.keys.toList();
  late final List<String> _rights =
      (widget.config.pairs.values.toList()..shuffle());

  String? _selectedLeft;
  String? _selectedRight;
  final Set<String> _matchedLefts = {};
  final Set<String> _matchedRights = {};
  String? _wrongLeft;
  String? _wrongRight;
  int _wrongAttempts = 0;

  void _tryMatch() {
    if (_selectedLeft == null || _selectedRight == null) return;
    final expected = widget.config.pairs[_selectedLeft];
    final correct = expected == _selectedRight;

    if (correct) {
      ref.read(hapticServiceProvider).correct();
      ref.read(audioServiceProvider).play(SoundEffect.correct);
      setState(() {
        _matchedLefts.add(_selectedLeft!);
        _matchedRights.add(_selectedRight!);
        _selectedLeft = null;
        _selectedRight = null;
      });

      // Did we just complete all pairs?
      if (_matchedLefts.length == widget.config.pairs.length) {
        widget.onAnswer(AnswerResult(
          correct: _wrongAttempts == 0,
          explanation: widget.config.explanation,
        ));
      }
    } else {
      ref.read(hapticServiceProvider).incorrect();
      ref.read(audioServiceProvider).play(SoundEffect.incorrect);
      final wl = _selectedLeft;
      final wr = _selectedRight;
      setState(() {
        _wrongLeft = wl;
        _wrongRight = wr;
        _wrongAttempts++;
      });
      Future.delayed(const Duration(milliseconds: 380), () {
        if (!mounted) return;
        setState(() {
          _wrongLeft = null;
          _wrongRight = null;
          _selectedLeft = null;
          _selectedRight = null;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: _column(_lefts, isLeft: true)),
        const SizedBox(width: 12),
        Expanded(child: _column(_rights, isLeft: false)),
      ],
    );
  }

  Widget _column(List<String> items, {required bool isLeft}) {
    return Column(
      children: [
        for (final item in items) ...[
          _Tile(
            label: item,
            selected: isLeft
                ? _selectedLeft == item
                : _selectedRight == item,
            matched: isLeft
                ? _matchedLefts.contains(item)
                : _matchedRights.contains(item),
            wrong: isLeft ? _wrongLeft == item : _wrongRight == item,
            onTap: () {
              ref.read(hapticServiceProvider).selection();
              setState(() {
                if (isLeft) {
                  _selectedLeft = item;
                } else {
                  _selectedRight = item;
                }
              });
              _tryMatch();
            },
          ),
          const SizedBox(height: 8),
        ],
      ],
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile({
    required this.label,
    required this.selected,
    required this.matched,
    required this.wrong,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final bool matched;
  final bool wrong;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final Color background;
    final Color foreground;
    if (matched) {
      background = colors.tertiaryContainer;
      foreground = colors.onTertiaryContainer;
    } else if (wrong) {
      background = colors.errorContainer;
      foreground = colors.onErrorContainer;
    } else if (selected) {
      background = colors.primary;
      foreground = colors.onPrimary;
    } else {
      background = colors.surfaceContainerHigh;
      foreground = colors.onSurface;
    }

    return SpringScale(
      pressed: selected || wrong,
      child: AnimatedOpacity(
        opacity: matched ? 0.6 : 1.0,
        duration: const Duration(milliseconds: 220),
        child: Material(
          color: background,
          borderRadius: BorderRadius.circular(AppConstants.radiusM),
          child: InkWell(
            onTap: matched ? null : onTap,
            borderRadius: BorderRadius.circular(AppConstants.radiusM),
            child: Container(
              constraints: const BoxConstraints(
                minHeight: AppConstants.minTapTarget,
              ),
              padding: const EdgeInsets.symmetric(
                  horizontal: 12, vertical: 14),
              alignment: Alignment.center,
              child: Text(
                label,
                style: TextStyle(
                  color: foreground,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
