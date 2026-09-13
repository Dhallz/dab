import 'package:dab_api/src/domain/core/org_calendar.dart';
import 'package:test/test.dart';

void main() {
  setUpAll(initializeOrgCalendar);

  group('OrgCalendar', () {
    test(
      'orgDayRangeUtc America/New_York 2026-07-02 includes 2026-07-03T00:42Z',
      () {
        final range = orgDayRangeUtc('America/New_York', 2026, 7, 2);
        final instant = DateTime.utc(2026, 7, 3, 0, 42);

        expect(range.startUtc.isBefore(instant), isTrue);
        expect(range.endUtc.isAfter(instant), isTrue);
        expect(instant.isBefore(range.endUtc), isTrue);
      },
    );

    test('parseOrgDateQueryRange uses org calendar days', () {
      final range = parseOrgDateQueryRange(
        orgTimezoneId: 'America/New_York',
        startDate: '2026-07-02',
        endDate: '2026-07-02',
      );

      expect(
        range.startUtc,
        DateTime.utc(2026, 7, 2, 4),
      );
      expect(
        range.endUtc,
        DateTime.utc(2026, 7, 3, 4),
      );
    });

    test('liveFeedStartOfTodayUtc uses org midnight', () {
      final clock = DateTime.utc(2026, 7, 3, 3, 30);
      final start = liveFeedStartOfTodayUtc('America/New_York', clock);

      expect(start, DateTime.utc(2026, 7, 2, 4));
    });
  });
}
