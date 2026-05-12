/// Models capturing the outcome of a single micro-screen interaction and
/// the overall result of a lesson.
library;

class MicroScreenResult {
  const MicroScreenResult({
    required this.microScreenId,
    required this.correct,
    required this.attempts,
  });

  final String microScreenId;
  final bool correct;
  final int attempts;
}

class LessonProgress {
  const LessonProgress({
    required this.lessonId,
    required this.completedAt,
    required this.crownLevel,
    required this.perfect,
  });

  final String lessonId;
  final DateTime completedAt;
  final int crownLevel;
  final bool perfect;
}
