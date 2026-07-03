import 'package:dab_app/domain/core/org_calendar.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUpAll(initializeOrgCalendar);

  test('orgDayKeyFromUtc uses org timezone for coverage keys', () {
    final instant = DateTime.utc(2026, 7, 3, 0, 42);
    expect(
      orgDayKeyFromUtc('America/New_York', instant),
      '2026-07-02',
    );
  });
}
