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

/// Formats a picker [calendarDay] as `YYYY-MM-DD` in org timezone semantics.
String orgCalendarDayString(String orgTimezoneId, DateTime calendarDay) {
  final month = calendarDay.month.toString().padLeft(2, '0');
  final day = calendarDay.day.toString().padLeft(2, '0');
  return '${calendarDay.year}-$month-$day';
}

/// `YYYY-MM-DD` for an instant interpreted in the org timezone.
String orgDayKeyFromUtc(String orgTimezoneId, DateTime utcInstant) {
  final local = orgLocalFromUtc(orgTimezoneId, utcInstant);
  final month = local.month.toString().padLeft(2, '0');
  final day = local.day.toString().padLeft(2, '0');
  return '${local.year}-$month-$day';
}

/// [utcInstant] converted to the organization IANA timezone.
DateTime orgLocalFromUtc(String orgTimezoneId, DateTime utcInstant) {
  final loc = _location(orgTimezoneId);
  return tz.TZDateTime.from(utcInstant.toUtc(), loc);
}

/// Whether [utcInstant] falls on the org-calendar day of [pickerDay].
bool isInstantInOrgCalendarDay(
  String orgTimezoneId,
  DateTime utcInstant,
  DateTime pickerDay,
) {
  final key = orgDayKeyFromUtc(orgTimezoneId, utcInstant);
  return key == orgCalendarDayString(orgTimezoneId, pickerDay);
}

/// Whether [utcInstant] is within [[startDay], [endDay]] org calendar days.
bool isInstantInOrgDateWindow(
  String orgTimezoneId,
  DateTime utcInstant,
  DateTime startDay,
  DateTime endDay,
) {
  final key = orgDayKeyFromUtc(orgTimezoneId, utcInstant);
  final startKey = orgCalendarDayString(orgTimezoneId, startDay);
  final endKey = orgCalendarDayString(orgTimezoneId, endDay);
  return key.compareTo(startKey) >= 0 && key.compareTo(endKey) <= 0;
}

/// Epoch ms at org-calendar midnight for [dayKey] (`YYYY-MM-DD`).
int orgDayEpochMsFromDayKey(String orgTimezoneId, String dayKey) {
  final parts = dayKey.split('-');
  if (parts.length != 3) return 0;
  final year = int.tryParse(parts[0]);
  final month = int.tryParse(parts[1]);
  final day = int.tryParse(parts[2]);
  if (year == null || month == null || day == null) return 0;
  final loc = _location(orgTimezoneId);
  final start = tz.TZDateTime(loc, year, month, day);
  return start.toUtc().millisecondsSinceEpoch;
}

/// Instant for a wall clock on an org-calendar day, as UTC.
///
/// [offsetDays] is applied in the organization timezone before [hour]/[minute]
/// so DST transitions do not skip or double the cutoff day.
DateTime orgLocalWallTimeUtc({
  required String orgTimezoneId,
  required int year,
  required int month,
  required int day,
  int offsetDays = 0,
  int hour = 0,
  int minute = 0,
}) {
  final loc = _location(orgTimezoneId);
  final start = tz.TZDateTime(loc, year, month, day);
  final shifted = start.add(Duration(days: offsetDays));
  return tz.TZDateTime(
    loc,
    shifted.year,
    shifted.month,
    shifted.day,
    hour,
    minute,
  ).toUtc();
}

/// Inclusive org-calendar [startDay] through [endDay] as UTC epoch bounds.
({int startEpochMs, int endEpochMsExclusive}) orgDateWindowEpochMs(
  String orgTimezoneId,
  DateTime startDay,
  DateTime endDay,
) {
  final loc = _location(orgTimezoneId);
  final start = tz.TZDateTime(loc, startDay.year, startDay.month, startDay.day);
  final end = tz.TZDateTime(
    loc,
    endDay.year,
    endDay.month,
    endDay.day,
  ).add(const Duration(days: 1));
  return (
    startEpochMs: start.toUtc().millisecondsSinceEpoch,
    endEpochMsExclusive: end.toUtc().millisecondsSinceEpoch,
  );
}
