/// Crown levels per unit (Spec §9.6).
///
/// 5 levels. Crown 1 on first lesson completion. Higher crowns unlock harder
/// question types on the same topic.
library;

class CrownLevel {
  const CrownLevel._();
  static const int max = 5;
}
