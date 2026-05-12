/// Daily quest models (Spec §9.7).
library;

enum QuestKind {
  completeLessons,
  correctStreak,
  practiceForgotten,
}

class DailyQuest {
  const DailyQuest({
    required this.id,
    required this.kind,
    required this.label,
    required this.target,
    required this.progress,
    required this.gemReward,
  });

  final String id;
  final QuestKind kind;
  final String label;
  final int target;
  final int progress;
  final int gemReward;

  bool get completed => progress >= target;
  double get fraction => target == 0 ? 0 : (progress / target).clamp(0, 1);

  DailyQuest copyWith({int? progress}) => DailyQuest(
        id: id,
        kind: kind,
        label: label,
        target: target,
        progress: progress ?? this.progress,
        gemReward: gemReward,
      );
}
