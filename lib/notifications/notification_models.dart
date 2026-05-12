/// Notification kinds (Spec §13.1).
library;

enum NumeroNotificationKind {
  dailyReminder, // "Your streak is waiting"
  streakAtRisk, // "Don't lose your streak tonight"
  comeback, // "We miss you, come back"
}

class NumeroNotificationContent {
  const NumeroNotificationContent({
    required this.kind,
    required this.title,
    required this.body,
  });

  final NumeroNotificationKind kind;
  final String title;
  final String body;
}
