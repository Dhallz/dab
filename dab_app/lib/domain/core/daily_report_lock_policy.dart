import 'org_calendar.dart';

/// [ARCH: DOMAIN]
/// ROLE: Global daily-report edit cutoff from Admin system settings.
/// CONTRACT: A report for org-calendar date D locks at (D + [offsetDays])
/// at [time] (`HH:mm`) in the organization timezone. `now >= lock` is locked.

/// System setting key: days after the report date when the cutoff applies.
const kDailyReportLockOffsetDaysKey = 'daily_report_lock_offset_days';

/// System setting key: wall-clock time (`HH:mm`) of the cutoff.
const kDailyReportLockTimeKey = 'daily_report_lock_time';

/// Default: lock at 00:00 the day after the report date (same-day editing).
const kDefaultDailyReportLockOffsetDays = 1;

/// Default cutoff time.
const kDefaultDailyReportLockTime = '00:00';

/// Inclusive maximum offset admins may store.
const kMaxDailyReportLockOffsetDays = 7;

final _dayKeyPattern = RegExp(r'^\d{4}-\d{2}-\d{2}$');

/// [ARCH: DOMAIN]
/// ROLE: Parsed Admin deadline for daily-report edits.
class DailyReportLockPolicy {
  final int offsetDays;
  final String time;

  const DailyReportLockPolicy({
    this.offsetDays = kDefaultDailyReportLockOffsetDays,
    this.time = kDefaultDailyReportLockTime,
  });

  factory DailyReportLockPolicy.fromSettings({
    String? offsetDays,
    String? time,
  }) {
    final clock = parseDailyReportLockTime(time);
    return DailyReportLockPolicy(
      offsetDays: parseDailyReportLockOffsetDays(offsetDays),
      time: formatDailyReportLockTime(clock),
    );
  }
}

/// Parses a stored offset; invalid values become the default.
int parseDailyReportLockOffsetDays(String? raw) {
  final n = int.tryParse((raw ?? '').trim());
  if (n == null) return kDefaultDailyReportLockOffsetDays;
  if (n < 0) return 0;
  if (n > kMaxDailyReportLockOffsetDays) return kMaxDailyReportLockOffsetDays;
  return n;
}

/// Parses `HH:mm` (optional seconds). Invalid values become 00:00.
({int hour, int minute}) parseDailyReportLockTime(String? raw) {
  final match = RegExp(
    r'^(\d{1,2}):(\d{2})(?::\d{2})?$',
  ).firstMatch((raw ?? '').trim());
  if (match == null) {
    return (hour: 0, minute: 0);
  }
  final hour = int.parse(match.group(1)!);
  final minute = int.parse(match.group(2)!);
  if (hour > 23 || minute > 59) {
    return (hour: 0, minute: 0);
  }
  return (hour: hour, minute: minute);
}

/// Canonical `HH:mm` for storage and bootstrap payloads.
String formatDailyReportLockTime(({int hour, int minute}) clock) {
  final hh = clock.hour.toString().padLeft(2, '0');
  final mm = clock.minute.toString().padLeft(2, '0');
  return '$hh:$mm';
}

/// UTC instant when the report for [reportDate] becomes read-only.
DateTime? dailyReportLockUtc({
  required String reportDate,
  required String orgTimezoneId,
  required DailyReportLockPolicy policy,
}) {
  final day = reportDate.trim();
  if (!_dayKeyPattern.hasMatch(day)) return null;
  final parts = day.split('-');
  final clock = parseDailyReportLockTime(policy.time);
  return orgLocalWallTimeUtc(
    orgTimezoneId: orgTimezoneId,
    year: int.parse(parts[0]),
    month: int.parse(parts[1]),
    day: int.parse(parts[2]),
    offsetDays: policy.offsetDays,
    hour: clock.hour,
    minute: clock.minute,
  );
}

/// True when [now] is at or after the lock instant for [reportDate].
bool isDailyReportLocked({
  required String reportDate,
  required String orgTimezoneId,
  required DailyReportLockPolicy policy,
  DateTime? now,
}) {
  final lock = dailyReportLockUtc(
    reportDate: reportDate,
    orgTimezoneId: orgTimezoneId,
    policy: policy,
  );
  if (lock == null) return false;
  return !(now ?? DateTime.now()).toUtc().isBefore(lock);
}

/// Compact remaining time until lock (`2d 3h`, `3h 12m`, `12m 04s`, `4s`).
String formatDailyReportLockCountdown(Duration remaining) {
  final safe = remaining.isNegative ? Duration.zero : remaining;
  final days = safe.inDays;
  final hours = safe.inHours.remainder(24);
  final minutes = safe.inMinutes.remainder(60);
  final seconds = safe.inSeconds.remainder(60);
  if (days > 0) {
    return '${days}d ${hours}h';
  }
  if (safe.inHours > 0) {
    return '${safe.inHours}h ${minutes.toString().padLeft(2, '0')}m';
  }
  if (minutes > 0) {
    return '${minutes}m ${seconds.toString().padLeft(2, '0')}s';
  }
  return '${seconds}s';
}
