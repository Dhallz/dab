import 'package:dab_app/domain/core/org_calendar.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUpAll(initializeOrgCalendar);

  test('orgDayKeyFromUtc uses org timezone for coverage keys', () {
    final instant = DateTime.utc(2026, 7, 3, 0, 42);
    expect(orgDayKeyFromUtc('America/New_York', instant), '2026-07-02');
  });

  test('orgCalendarDayKeysInclusive walks civil dates not 24h durations', () {
    final keys = orgCalendarDayKeysInclusive(
      'UTC',
      DateTime(2026, 8, 20, 23, 59, 59, 999),
      DateTime(2026, 8, 26, 23, 59, 59, 999),
    );
    expect(keys, [
      '2026-08-20',
      '2026-08-21',
      '2026-08-22',
      '2026-08-23',
      '2026-08-24',
      '2026-08-25',
      '2026-08-26',
    ]);
  });

  test('orgLocalFromUtc converts the clock into the org timezone', () {
    final instant = DateTime.utc(2026, 7, 3, 0, 42);
    final local = orgLocalFromUtc('America/New_York', instant);
    expect(local.year, 2026);
    expect(local.month, 7);
    expect(local.day, 2);
    expect(local.hour, 20);
    expect(local.minute, 42);
  });
}
