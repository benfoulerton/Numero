/// Daily goal options offered during onboarding (Spec §4.2 step 3).
library;

enum DailyGoal {
  casual(minutes: 5, label: 'Casual', description: 'Light and easy'),
  regular(minutes: 10, label: 'Regular', description: 'A solid pace'),
  serious(minutes: 15, label: 'Serious', description: 'Real progress'),
  intense(minutes: 20, label: 'Intense', description: 'Full commitment');

  const DailyGoal({
    required this.minutes,
    required this.label,
    required this.description,
  });

  final int minutes;
  final String label;
  final String description;

  static DailyGoal fromMinutes(int minutes) {
    for (final g in values) {
      if (g.minutes == minutes) return g;
    }
    return DailyGoal.regular;
  }
}
