import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

/// [ARCH: DOMAIN]
/// ROLE: Organization calendar-day boundaries in a configured IANA timezone.
/// CONTRACT: All instants are stored/transmitted as UTC; calendar days are
/// interpreted in [orgTimezoneId] (default `UTC`).
/// CONSTRAINTS: Call [initializeOrgCalendar] once at process boot before use.
const String kDefaultOrgTimezoneId = 'UTC';
const String kSystemTimezoneSettingKey = 'system_timezone';

bool _orgCalendarInitialized = false;

/// Loads the IANA timezone database. Idempotent.
void initializeOrgCalendar() {
  if (_orgCalendarInitialized) return;
  tz_data.initializeTimeZones();
  _orgCalendarInitialized = true;
}

/// Normalizes a stored timezone id; falls back to [kDefaultOrgTimezoneId].
String resolveOrgTimezoneId(String? raw) {
  final trimmed = raw?.trim();
  if (trimmed == null || trimmed.isEmpty) {
    return kDefaultOrgTimezoneId;
  }
  try {
    tz.getLocation(trimmed);
    return trimmed;
  } catch (_) {
    return kDefaultOrgTimezoneId;
  }
}

tz.Location _location(String orgTimezoneId) {
  initializeOrgCalendar();
  return tz.getLocation(resolveOrgTimezoneId(orgTimezoneId));
}

/// Inclusive calendar-day start and exclusive next-day start, both UTC.
({DateTime startUtc, DateTime endUtc}) orgDayRangeUtc(
  String orgTimezoneId,
  int year,
  int month,
  int day,
) {
  final loc = _location(orgTimezoneId);
  final start = tz.TZDateTime(loc, year, month, day);
  final end = start.add(const Duration(days: 1));
  return (startUtc: start.toUtc(), endUtc: end.toUtc());
}

/// Parses `YYYY-MM-DD` (optional `T…` suffix ignored) as org calendar days.
({DateTime startUtc, DateTime endUtc}) parseOrgDateQueryRange({
  required String orgTimezoneId,
  required String startDate,
  required String endDate,
}) {
  final startParts = _parseCalendarDate(startDate);
  final endParts = _parseCalendarDate(endDate);
  final rangeStart = orgDayRangeUtc(
    orgTimezoneId,
    startParts.$1,
    startParts.$2,
    startParts.$3,
  );
  final rangeEnd = orgDayRangeUtc(
    orgTimezoneId,
    endParts.$1,
    endParts.$2,
    endParts.$3,
  );
  return (startUtc: rangeStart.startUtc, endUtc: rangeEnd.endUtc);
}

(int year, int month, int day) _parseCalendarDate(String raw) {
  final dateOnly = raw.contains('T') ? raw.split('T').first : raw.trim();
  final match = RegExp(r'^(\d{4})-(\d{2})-(\d{2})$').firstMatch(dateOnly);
  if (match == null) {
    throw FormatException('Invalid calendar date: $raw');
  }
  return (
    int.parse(match.group(1)!),
    int.parse(match.group(2)!),
    int.parse(match.group(3)!),
  );
}

/// `YYYY-MM-DD` for an instant interpreted in the org timezone.
String orgDayKeyFromUtc(String orgTimezoneId, DateTime utcInstant) {
  final loc = _location(orgTimezoneId);
  final local = tz.TZDateTime.from(utcInstant.toUtc(), loc);
  final month = local.month.toString().padLeft(2, '0');
  final day = local.day.toString().padLeft(2, '0');
  return '${local.year}-$month-$day';
}

/// Whether [utcInstant] falls on the org-calendar day of [pickerDay].
bool isInstantInOrgCalendarDay(
  String orgTimezoneId,
  DateTime utcInstant,
  DateTime pickerDay,
) {
  final key = orgDayKeyFromUtc(orgTimezoneId, utcInstant);
  final month = pickerDay.month.toString().padLeft(2, '0');
  final day = pickerDay.day.toString().padLeft(2, '0');
  final pickerKey = '${pickerDay.year}-$month-$day';
  return key == pickerKey;
}

/// Whether [utcInstant] is within [[startDay], [endDay]] org calendar days.
bool isInstantInOrgDateWindow(
  String orgTimezoneId,
  DateTime utcInstant,
  DateTime startDay,
  DateTime endDay,
) {
  final key = orgDayKeyFromUtc(orgTimezoneId, utcInstant);
  final startKey = orgDayKeyFromUtc(
    orgTimezoneId,
    orgDayRangeUtc(orgTimezoneId, startDay.year, startDay.month, startDay.day)
        .startUtc,
  );
  final endKey = orgDayKeyFromUtc(
    orgTimezoneId,
    orgDayRangeUtc(orgTimezoneId, endDay.year, endDay.month, endDay.day)
        .startUtc,
  );
  return key.compareTo(startKey) >= 0 && key.compareTo(endKey) <= 0;
}

/// Start of the current org calendar day as a UTC instant.
DateTime liveFeedStartOfTodayUtc(
  String orgTimezoneId, [
  DateTime? now,
]) {
  final clock = (now ?? DateTime.now()).toUtc();
  final loc = _location(orgTimezoneId);
  final localNow = tz.TZDateTime.from(clock, loc);
  final start = tz.TZDateTime(loc, localNow.year, localNow.month, localNow.day);
  return start.toUtc();
}

/// Next org-timezone midnight after [now], as UTC.
DateTime nextOrgMidnightUtc(
  String orgTimezoneId, [
  DateTime? now,
]) {
  final start = liveFeedStartOfTodayUtc(orgTimezoneId, now);
  final loc = _location(orgTimezoneId);
  final localStart = tz.TZDateTime.from(start, loc);
  final next = localStart.add(const Duration(days: 1));
  return next.toUtc();
}
