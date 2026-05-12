/// Build-an-expression (Spec §7.5).
///
/// Tiles at the bottom; a "shelf" of slots at the top. Tap a tile to add
/// it to the next empty slot. Tap a placed tile to remove it. Max 8 tiles.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/haptic_service.dart';
import 'interaction_types.dart';

class BuildExpression extends ConsumerStatefulWidget {
  const BuildExpression({
    super.key,
    required this.config,
    required this.onAnswer,
  });

  final BuildExpressionConfig config;
  final AnswerCallback onAnswer;

  @override
  ConsumerState<BuildExpression> createState() => _BuildExpressionState();
}

class _BuildExpressionState extends ConsumerState<BuildExpression> {
  late final List<String> _pool;
  final List<String> _placed = [];

  @override
  void initState() {
    super.initState();
    _pool = [...widget.config.tiles]..shuffle();
  }

  void _place(String tile) {
    if (_placed.length >= widget.config.target.length) return;
    ref.read(hapticServiceProvider).selection();
    setState(() {
      _placed.add(tile);
      _pool.remove(tile);
    });
  }

  void _remove(int index) {
    ref.read(hapticServiceProvider).selection();
    setState(() {
      _pool.add(_placed.removeAt(index));
    });
  }

  bool get _ready => _placed.length == widget.config.target.length;

  bool _isCorrect() {
    if (_placed.length != widget.config.target.length) return false;
    for (var i = 0; i < _placed.length; i++) {
      if (_placed[i] != widget.config.target[i]) return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Column(
      children: [
        // Shelf
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: colors.surfaceContainerLow,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Wrap(
            alignment: WrapAlignment.center,
            spacing: 6,
            runSpacing: 6,
            children: [
              for (var i = 0; i < widget.config.target.length; i++)
                _Slot(
                  filled: i < _placed.length,
                  label: i < _placed.length ? _placed[i] : '_',
                  onTap: i < _placed.length ? () => _remove(i) : null,
                ),
            ],
          ),
        ),
        const Spacer(),
        // Pool
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final tile in _pool)
              _Tile(label: tile, onTap: () => _place(tile)),
          ],
        ),
        const Spacer(),
        FilledButton(
          onPressed: _ready
              ? () => widget.onAnswer(AnswerResult(
                    correct: _isCorrect(),
                    userAnswer: _placed.join(' '),
                    correctAnswer: widget.config.target.join(' '),
                    explanation: widget.config.explanation,
                  ))
              : null,
          child: const Text('Check'),
        ),
      ],
    );
  }
}

class _Slot extends StatelessWidget {
  const _Slot({
    required this.filled,
    required this.label,
    required this.onTap,
  });

  final bool filled;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        constraints: const BoxConstraints(minWidth: 44, minHeight: 48),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: filled
              ? colors.primaryContainer
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: filled
              ? null
              : Border.all(color: colors.outlineVariant, width: 2),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: filled
                ? colors.onPrimaryContainer
                : colors.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Material(
      color: colors.surfaceContainerHigh,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          constraints: const BoxConstraints(minHeight: 48, minWidth: 56),
          padding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Text(
            label,
            style: const TextStyle(
                fontSize: 20, fontWeight: FontWeight.w800),
          ),
        ),
      ),
    );
  }
}
