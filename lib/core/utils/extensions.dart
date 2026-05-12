/// Misc top-level extensions used across the app.
library;

extension DateOnly on DateTime {
  /// Returns an ISO date string of the form `YYYY-MM-DD` (no time component).
  String toDateString() {
    final y = year.toString().padLeft(4, '0');
    final m = month.toString().padLeft(2, '0');
    final d = day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  /// Truncates this DateTime to midnight local.
  DateTime get dateOnly => DateTime(year, month, day);
}
