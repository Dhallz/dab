import 'package:dab_app/domain/core/daily_report_lock_policy.dart';
import 'package:dab_app/domain/core/org_calendar.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUpAll(initializeOrgCalendar);

  test('defaults lock at next-day midnight', () {
    const policy = DailyReportLockPolicy();
    expect(
      dailyReportLockUtc(
        reportDate: '2026-08-22',
        orgTimezoneId: 'UTC',
        policy: policy,
      ),
      DateTime.utc(2026, 8, 23),
    );
    expect(
      isDailyReportLocked(
        reportDate: '2026-08-22',
        orgTimezoneId: 'UTC',
        policy: policy,
        now: DateTime.utc(2026, 8, 22, 23, 59),
      ),
      isFalse,
    );
  });

  test('countdown formats remaining time compactly', () {
    expect(
      formatDailyReportLockCountdown(const Duration(days: 1, hours: 3)),
      '1d 3h',
    );
    expect(
      formatDailyReportLockCountdown(const Duration(hours: 3, minutes: 12)),
      '3h 12m',
    );
    expect(
      formatDailyReportLockCountdown(const Duration(minutes: 12, seconds: 4)),
      '12m 04s',
    );
    expect(formatDailyReportLockCountdown(const Duration(seconds: 4)), '4s');
    expect(formatDailyReportLockCountdown(-const Duration(seconds: 5)), '0s');
  });

  test('next-day 11:00 uses org timezone', () {
    const policy = DailyReportLockPolicy(offsetDays: 1, time: '11:00');
    expect(
      dailyReportLockUtc(
        reportDate: '2026-08-22',
        orgTimezoneId: 'America/New_York',
        policy: policy,
      ),
      DateTime.utc(2026, 8, 23, 15),
    );
  });
}
