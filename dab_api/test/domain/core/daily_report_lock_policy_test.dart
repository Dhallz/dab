import 'package:dab_api/src/domain/core/daily_report_lock_policy.dart';
import 'package:dab_api/src/domain/core/org_calendar.dart';
import 'package:test/test.dart';

void main() {
  setUpAll(initializeOrgCalendar);

  test('defaults lock at next-day midnight (same-day editing)', () {
    const policy = DailyReportLockPolicy();
    expect(policy.offsetDays, 1);
    expect(policy.time, '00:00');

    final lock = dailyReportLockUtc(
      reportDate: '2026-08-22',
      orgTimezoneId: 'UTC',
      policy: policy,
    );
    expect(lock, DateTime.utc(2026, 8, 23));

    expect(
      isDailyReportLocked(
        reportDate: '2026-08-22',
        orgTimezoneId: 'UTC',
        policy: policy,
        now: DateTime.utc(2026, 8, 22, 23, 59),
      ),
      isFalse,
    );
    expect(
      isDailyReportLocked(
        reportDate: '2026-08-22',
        orgTimezoneId: 'UTC',
        policy: policy,
        now: DateTime.utc(2026, 8, 23),
      ),
      isTrue,
    );
  });

  test('next-day 11:00 in America/New_York', () {
    const policy = DailyReportLockPolicy(offsetDays: 1, time: '11:00');
    final lock = dailyReportLockUtc(
      reportDate: '2026-08-22',
      orgTimezoneId: 'America/New_York',
      policy: policy,
    );
    expect(lock, DateTime.utc(2026, 8, 23, 15));

    expect(
      isDailyReportLocked(
        reportDate: '2026-08-22',
        orgTimezoneId: 'America/New_York',
        policy: policy,
        now: DateTime.utc(2026, 8, 23, 14, 59),
      ),
      isFalse,
    );
    expect(
      isDailyReportLocked(
        reportDate: '2026-08-22',
        orgTimezoneId: 'America/New_York',
        policy: policy,
        now: DateTime.utc(2026, 8, 23, 15),
      ),
      isTrue,
    );
  });

  test('fromSettings clamps invalid values', () {
    final policy = DailyReportLockPolicy.fromSettings(
      offsetDays: '99',
      time: '25:61',
    );
    expect(policy.offsetDays, kMaxDailyReportLockOffsetDays);
    expect(policy.time, '00:00');
  });
}
