/// Compact user profile model (Spec §14.1).
library;

class UserProfile {
  const UserProfile({
    required this.displayName,
    required this.avatarId,
    required this.dailyGoalMinutes,
    required this.totalXp,
    required this.streak,
    required this.longestStreak,
    required this.lessonsCompleted,
    required this.hearts,
    required this.gems,
  });

  final String displayName;
  final String avatarId;
  final int dailyGoalMinutes;
  final int totalXp;
  final int streak;
  final int longestStreak;
  final int lessonsCompleted;
  final int hearts;
  final int gems;
}
