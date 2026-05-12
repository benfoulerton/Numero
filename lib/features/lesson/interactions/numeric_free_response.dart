/// Numeric free-response with a custom keypad (Spec §7.8).
///
/// Used only for screen 12 final compute. Tolerance ±0.001 for decimals.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/haptic_service.dart';
import 'interaction_types.dart';

class NumericFreeResponse extends ConsumerStatefulWidget {
  const NumericFreeResponse({
    super.key,
    required this.config,
    required this.onAnswer,
  });

  final NumericResponseConfig config;
  final AnswerCallback onAnswer;

  @override
  ConsumerState<NumericFreeResponse> createState() =>
      _NumericFreeResponseState();
}

class _NumericFreeResponseState extends ConsumerState<NumericFreeResponse> {
  String _entry = '';

  void _press(String char) {
    ref.read(hapticServiceProvider).selection();
    setState(() {
      if (char == '⌫') {
        if (_entry.isNotEmpty) {
          _entry = _entry.substring(0, _entry.length - 1);
        }
      } else if (char == '−') {
        if (_entry.startsWith('-')) {
          _entry = _entry.substring(1);
        } else {
          _entry = '-' + _entry;
        }
      } else if (char == '.') {
        if (!_entry.contains('.')) _entry += '.';
      } else {
        _entry += char;
      }
    });
  }

  void _submit() {
    final parsed = double.tryParse(_entry);
    if (parsed == null) {
      widget.onAnswer(AnswerResult(
        correct: false,
        userAnswer: _entry,
        correctAnswer: widget.config.correctValue.toString(),
        explanation: widget.config.explanation,
      ));
      return;
    }
    final correct =
        (parsed - widget.config.correctValue).abs() <= widget.config.tolerance;
    widget.onAnswer(AnswerResult(
      correct: correct,
      userAnswer: _entry,
      correctAnswer: widget.config.correctValue.toString(),
      explanation: widget.config.explanation,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    const labels = <String>[
      '1', '2', '3',
      '4', '5', '6',
      '7', '8', '9',
      '−', '0', '.',
      '⌫',
    ];

    return Column(
      children: [
        Container(
          height: 64,
          decoration: BoxDecoration(
            color: colors.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(16),
          ),
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            _entry.isEmpty ? '0' : _entry,
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.w800,
                color: _entry.isEmpty
                    ? colors.onSurfaceVariant
                    : colors.onSurface),
          ),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: GridView.count(
            crossAxisCount: 3,
            mainAxisSpacing: 6,
            crossAxisSpacing: 6,
            childAspectRatio: 1.6,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              for (final l in labels) _Key(label: l, onTap: () => _press(l)),
            ],
          ),
        ),
        const SizedBox(height: 8),
        FilledButton(
          onPressed: _entry.isEmpty ? null : _submit,
          child: const Text('Check'),
        ),
      ],
    );
  }
}

class _Key extends StatelessWidget {
  const _Key({required this.label, required this.onTap});
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
        child: Center(
          child: Text(label,
              style: const TextStyle(
                  fontSize: 22, fontWeight: FontWeight.w800)),
        ),
      ),
    );
  }
}
