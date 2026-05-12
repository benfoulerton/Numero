/// Shared data types used by all 11 interaction widgets (Spec §7).
///
/// Each interaction takes a [QuestionConfig] (the question payload) and
/// reports outcomes via an [AnswerCallback].
library;

/// The result of submitting an answer.
class AnswerResult {
  const AnswerResult({
    required this.correct,
    this.userAnswer,
    this.correctAnswer,
    this.explanation,
  });

  final bool correct;
  final String? userAnswer;
  final String? correctAnswer;
  final String? explanation;
}

/// Signature for an interaction to notify its host of an answer.
typedef AnswerCallback = void Function(AnswerResult result);

/// Configuration for a tap-to-match question (Spec §7.1).
class TapToMatchConfig {
  const TapToMatchConfig({
    required this.pairs,
    this.explanation = '',
  });

  /// Map of left-tile label -> right-tile label that pairs with it.
  /// Max 4 pairs (8 tiles) per question.
  final Map<String, String> pairs;
  final String explanation;
}

/// Configuration for a fill-in-the-blank (Spec §7.2).
class FillBlankConfig {
  const FillBlankConfig({
    required this.beforeBlank,
    required this.afterBlank,
    required this.correctAnswer,
    required this.options,
    this.explanation = '',
  });

  final String beforeBlank;
  final String afterBlank;
  final String correctAnswer;
  final List<String> options;
  final String explanation;
}

/// Configuration for "tap the correct graph" (Spec §7.3).
class TapCorrectGraphConfig {
  const TapCorrectGraphConfig({
    required this.prompt,
    required this.correctIndex,
    required this.thumbnailPainters,
    this.explanation = '',
  });

  final String prompt;
  final int correctIndex;
  final List<dynamic> thumbnailPainters; // CustomPainter, kept dynamic for stub
  final String explanation;
}

/// Configuration for an MCQ (Spec §7.7).
class McqConfig {
  const McqConfig({
    required this.prompt,
    required this.options,
    required this.correctIndex,
    this.explanation = '',
  });

  final String prompt;
  final List<String> options;
  final int correctIndex;
  final String explanation;
}

/// Configuration for build-an-expression (Spec §7.5).
class BuildExpressionConfig {
  const BuildExpressionConfig({
    required this.target,
    required this.tiles,
    this.explanation = '',
  });

  /// The correct expression as a list of tile labels in correct order.
  final List<String> target;
  /// All available tiles (randomised by the widget).
  final List<String> tiles;
  final String explanation;
}

/// Configuration for reorder-steps (Spec §7.6).
class ReorderStepsConfig {
  const ReorderStepsConfig({
    required this.correctOrder,
    required this.fixedFirst,
    required this.fixedLast,
    this.explanation = '',
  });

  final List<String> correctOrder;
  final String fixedFirst;
  final String fixedLast;
  final String explanation;
}

/// Configuration for numeric free-response (Spec §7.8).
class NumericResponseConfig {
  const NumericResponseConfig({
    required this.prompt,
    required this.correctValue,
    this.tolerance = 0.001,
    this.explanation = '',
  });

  final String prompt;
  final double correctValue;
  final double tolerance;
  final String explanation;
}

/// Configuration for slider-explore (Spec §7.4).
class SliderExploreConfig {
  const SliderExploreConfig({
    required this.prompt,
    this.target,
    this.tolerance = 0.05,
    this.min = 0.0,
    this.max = 1.0,
    this.explanation = '',
  });

  final String prompt;
  /// If null, the screen is exploratory only (no scoring) — used for
  /// micro-screen 2 (Spec §6.4).
  final double? target;
  final double tolerance;
  final double min;
  final double max;
  final String explanation;
}

/// Configuration for drag-the-point (Spec §7.9).
class DragPointConfig {
  const DragPointConfig({
    required this.prompt,
    required this.targetX,
    required this.targetY,
    this.tolerance = 0.08,
    this.explanation = '',
  });

  final String prompt;
  /// Normalised coordinates inside the canvas.
  final double targetX;
  final double targetY;
  final double tolerance;
  final String explanation;
}

/// Configuration for annotation-tap (Spec §7.10).
class AnnotationTapConfig {
  const AnnotationTapConfig({
    required this.prompt,
    required this.regions,
    required this.correctRegionId,
    this.explanation = '',
  });

  final String prompt;
  /// Each region: an id, label, and its rect (in normalised coords).
  final List<AnnotationRegion> regions;
  final String correctRegionId;
  final String explanation;
}

class AnnotationRegion {
  const AnnotationRegion({
    required this.id,
    required this.label,
    required this.rect,
  });
  final String id;
  final String label;
  // (left, top, right, bottom) in normalised coords.
  final List<double> rect;
}

/// Configuration for worked-example reveal (Spec §7.11).
class WorkedExampleConfig {
  const WorkedExampleConfig({
    required this.steps,
  });

  /// Each step is (title, body, optional explanation).
  final List<WorkedStep> steps;
}

class WorkedStep {
  const WorkedStep({
    required this.title,
    required this.body,
    this.why,
  });
  final String title;
  final String body;
  final String? why;
}
