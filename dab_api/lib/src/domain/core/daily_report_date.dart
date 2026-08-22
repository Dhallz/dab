/// [ARCH: DOMAIN]
/// ROLE: Org-calendar day key validation for personal daily reports.
/// CONTRACT: Wire dates are `YYYY-MM-DD` (no time, no timezone suffix).
library;

final _dayKeyPattern = RegExp(r'^\d{4}-\d{2}-\d{2}$');

/// Whether [raw] is a valid report date key.
bool isDailyReportDate(String raw) => _dayKeyPattern.hasMatch(raw.trim());

/// Trims [raw] when it is a valid day key; otherwise null.
String? parseDailyReportDate(String? raw) {
  final value = (raw ?? '').trim();
  if (!isDailyReportDate(value)) return null;
  return value;
}
