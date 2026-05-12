/// Models for the 14 micro-screen templates (Spec §6.4).
///
/// Each lesson is a list of [MicroScreenSpec]. The lesson host renders the
/// matching template widget. Real curriculum will fill these structures —
/// the shell ships with a placeholder demo lesson only.
library;

import 'interactions/interaction_types.dart';

enum MicroScreenKind {
  visualHook, // 1
  observation, // 2
  workedExample, // 3
  recognitionCheck, // 4
  completion, // 5
  conceptImage, // 6
  sliderIntuition, // 7
  buildExpression, // 8
  reorderSteps, // 9
  estimation, // 10
  mcq, // 11
  freeResponse, // 12
  summary, // 13
  reward, // 14
}

/// Spec rule (§6.4): Screens 1–3 must never contain mathematical notation.
extension MicroScreenKindMeta on MicroScreenKind {
  bool get prohibitsNotation =>
      this == MicroScreenKind.visualHook ||
      this == MicroScreenKind.observation ||
      this == MicroScreenKind.workedExample;
}

/// Polymorphic micro-screen spec. The [config] is one of the
/// interaction-config types — chosen per [kind].
class MicroScreenSpec {
  const MicroScreenSpec({
    required this.id,
    required this.kind,
    required this.prompt,
    this.config,
    this.summaryText,
    this.lessonTitle,
  });

  final String id;
  final MicroScreenKind kind;
  final String prompt;
  /// One of the *Config types in interaction_types.dart, or null for
  /// kinds (e.g. visualHook, summary, reward) that don't need scoring.
  final Object? config;
  final String? summaryText;
  final String? lessonTitle;
}
