import 'package:dab_app/domain/core/daily_report_markdown.dart';
import 'package:dab_app/domain/core/org_calendar.dart';
import 'package:dab_app/domain/entities/user/daily_report.dart';
import 'package:dab_app/domain/entities/user/daily_report_line.dart';
import 'package:dab_app/domain/entities/user/daily_report_line_role.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUpAll(initializeOrgCalendar);

  test('omits excluded lines and includes notes', () {
    const report = DailyReport(
      date: '2026-08-22',
      lines: [
        DailyReportLine(
          subjectKey: 'github|acme/app|abc',
          included: true,
          note: 'Shipped login',
          role: DailyReportLineRole.authored,
          title: 'Fix login',
          providerId: 'github',
          occurredAt: null,
        ),
        DailyReportLine(
          subjectKey: 'slack|T1|C1|1',
          included: false,
          title: 'noise',
          providerId: 'slack',
        ),
      ],
    );

    final md = report.toMarkdown(orgTimezoneId: kDefaultOrgTimezoneId);
    expect(md, contains('# Daily report — 2026-08-22'));
    expect(md, contains('Fix login'));
    expect(md, contains('Shipped login'));
    expect(md, isNot(contains('noise')));
  });

  test('empty included set still emits a heading', () {
    const report = DailyReport(
      date: '2026-08-22',
      lines: [
        DailyReportLine(subjectKey: 'x', included: false, title: 'hidden'),
      ],
    );
    final md = dailyReportMarkdown(
      date: report.date,
      lines: report.lines,
      orgTimezoneId: kDefaultOrgTimezoneId,
    );
    expect(md, contains('_No included activity._'));
    expect(md, isNot(contains('hidden')));
  });
}
