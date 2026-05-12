/// Renders one micro-screen by dispatching to the appropriate interaction
/// widget based on [MicroScreenSpec.kind].
library;

import 'package:flutter/material.dart';

import '../interactions/annotation_tap.dart';
import '../interactions/build_expression.dart';
import '../interactions/drag_the_point.dart';
import '../interactions/fill_in_the_blank.dart';
import '../interactions/interaction_types.dart';
import '../interactions/multiple_choice.dart';
import '../interactions/numeric_free_response.dart';
import '../interactions/reorder_steps.dart';
import '../interactions/slider_explore.dart';
import '../interactions/tap_correct_graph.dart';
import '../interactions/tap_to_match.dart';
import '../interactions/worked_example_reveal.dart';
import '../micro_screen_spec.dart';
import '../widgets/micro_screen_scaffold.dart';
import 'summary_screen.dart';
import 'visual_hook_screen.dart';

class MicroScreenRenderer extends StatelessWidget {
  const MicroScreenRenderer({
    super.key,
    required this.spec,
    required this.onAnswer,
    required this.onContinueNoScoring,
  });

  final MicroScreenSpec spec;
  final AnswerCallback onAnswer;
  /// For non-scoring screens (visual hook, summary), advance without a
  /// feedback panel.
  final VoidCallback onContinueNoScoring;

  @override
  Widget build(BuildContext context) {
    final prompt = Text(
      spec.prompt,
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.titleMedium,
    );

    // Non-scoring screens are full-screen with their own scaffold.
    if (spec.kind == MicroScreenKind.visualHook) {
      return VisualHookScreen(
        prompt: spec.prompt,
        onContinue: onContinueNoScoring,
      );
    }
    if (spec.kind == MicroScreenKind.summary) {
      return SummaryScreen(
        text: spec.summaryText ?? spec.prompt,
        onContinue: onContinueNoScoring,
      );
    }

    Widget visualFor() {
      // Visual zone differs by kind; in the shell we use a generic
      // placeholder shape. Real lessons will inject diagrams here.
      return _PlaceholderVisual(spec: spec);
    }

    Widget answerFor() {
      switch (spec.kind) {
        case MicroScreenKind.observation:
          return SliderExplore(
            config: spec.config as SliderExploreConfig,
            onAnswer: onAnswer,
          );
        case MicroScreenKind.workedExample:
          return WorkedExampleReveal(
            config: spec.config as WorkedExampleConfig,
            onAnswer: onAnswer,
          );
        case MicroScreenKind.recognitionCheck:
          return TapToMatch(
            config: spec.config as TapToMatchConfig,
            onAnswer: onAnswer,
          );
        case MicroScreenKind.completion:
          return FillInTheBlank(
            config: spec.config as FillBlankConfig,
            onAnswer: onAnswer,
          );
        case MicroScreenKind.conceptImage:
          final c = spec.config as TapCorrectGraphConfig;
          // Provide simple placeholder builders for the 4 thumbnails.
          return TapCorrectGraph(
            config: c,
            onAnswer: onAnswer,
            thumbnailBuilders: List.generate(
              4,
              (i) => (context) => _GraphPlaceholder(index: i),
            ),
          );
        case MicroScreenKind.sliderIntuition:
          return SliderExplore(
            config: spec.config as SliderExploreConfig,
            onAnswer: onAnswer,
          );
        case MicroScreenKind.buildExpression:
          return BuildExpression(
            config: spec.config as BuildExpressionConfig,
            onAnswer: onAnswer,
          );
        case MicroScreenKind.reorderSteps:
          return ReorderSteps(
            config: spec.config as ReorderStepsConfig,
            onAnswer: onAnswer,
          );
        case MicroScreenKind.estimation:
          return SliderExplore(
            config: spec.config as SliderExploreConfig,
            onAnswer: onAnswer,
          );
        case MicroScreenKind.mcq:
          return MultipleChoice(
            config: spec.config as McqConfig,
            onAnswer: onAnswer,
          );
        case MicroScreenKind.freeResponse:
          return NumericFreeResponse(
            config: spec.config as NumericResponseConfig,
            onAnswer: onAnswer,
          );
        case MicroScreenKind.visualHook:
        case MicroScreenKind.summary:
        case MicroScreenKind.reward:
          return const SizedBox.shrink();
      }
    }

    return MicroScreenScaffold(
      visual: visualFor(),
      prompt: prompt,
      answer: answerFor(),
    );
  }
}

class _PlaceholderVisual extends StatelessWidget {
  const _PlaceholderVisual({required this.spec});
  final MicroScreenSpec spec;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: colors.primaryContainer,
        borderRadius: BorderRadius.circular(24),
      ),
      padding: const EdgeInsets.all(24),
      width: double.infinity,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.bubble_chart_rounded,
              size: 56, color: colors.onPrimaryContainer),
          const SizedBox(height: 12),
          Text(
            'Diagram placeholder',
            style: Theme.of(context)
                .textTheme
                .labelLarge
                ?.copyWith(color: colors.onPrimaryContainer),
          ),
          const SizedBox(height: 4),
          Text(
            spec.kind.name,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: colors.onPrimaryContainer.withValues(alpha: 0.7)),
          ),
        ],
      ),
    );
  }
}

class _GraphPlaceholder extends StatelessWidget {
  const _GraphPlaceholder({required this.index});
  final int index;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return CustomPaint(
      painter: _ToyGraphPainter(index: index, color: colors.primary),
    );
  }
}

class _ToyGraphPainter extends CustomPainter {
  _ToyGraphPainter({required this.index, required this.color});
  final int index;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;
    final path = Path()..moveTo(0, size.height * 0.8);
    for (var x = 0; x <= size.width.toInt(); x += 4) {
      final t = x / size.width;
      double y;
      switch (index) {
        case 0:
          y = size.height * (0.8 - t * 0.6);
        case 1:
          y = size.height * (0.5 + 0.4 * (t - 0.5) * (t - 0.5));
        case 2:
          y = size.height * (0.5 - 0.4 * (t - 0.5));
        default:
          y = size.height * (0.2 + 0.6 * t * t);
      }
      path.lineTo(x.toDouble(), y);
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_ToyGraphPainter old) =>
      old.index != index || old.color != color;
}
