import 'package:dab_app/domain/core/daily_report_merge.dart';
import 'package:dab_app/domain/core/org_calendar.dart';
import 'package:dab_app/domain/core/report_subject_key.dart';
import 'package:dab_app/domain/entities/activity/activity.dart';
import 'package:dab_app/domain/entities/user/daily_report.dart';
import 'package:dab_app/domain/entities/user/daily_report_line.dart';
import 'package:dab_app/domain/entities/user/daily_report_line_role.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUpAll(initializeOrgCalendar);

  final reportDay = DateTime(2026, 8, 22);

  Activity git({
    required String id,
    required String sha,
    required String title,
    ActivityInboxLane lane = ActivityInboxLane.directed,
  }) {
    return Activity(
      id: id,
      userId: 'u-1',
      provider: const GitHubCommitProvider(repo: 'Acme/app', branch: 'main'),
      title: title,
      content: '',
      authorName: 'Ada',
      url: 'https://github.com/Acme/app/commit/$sha',
      commentCount: 0,
      createdAt: DateTime.utc(2026, 8, 22, 14, 5),
      inboxLane: lane,
    );
  }

  test('live + authored of the same git sha merge as both', () {
    final live = git(id: 'live-id', sha: 'abc1234', title: 'Fix login');
    final authored = git(id: 'search-id', sha: 'abc1234', title: 'Fix login');
    final lines = mergeDailyReportPool(
      live: [live],
      authored: [authored],
      saved: DailyReport.empty(date: '2026-08-22'),
      orgTimezoneId: kDefaultOrgTimezoneId,
      reportDay: reportDay,
    );
    expect(lines, hasLength(1));
    expect(lines.single.role, DailyReportLineRole.both);
    expect(lines.single.subjectKey, 'github|acme/app|abc1234');
    expect(lines.single.included, isTrue);
  });

  test('git occurrence is not branch-only Follow key', () {
    final first = git(id: 'a', sha: 'aaa1111', title: 'One');
    final second = git(id: 'b', sha: 'bbb2222', title: 'Two');
    expect(first.reportSubjectKey, isNot(second.reportSubjectKey));
    expect(first.reportSubjectKey.contains('|main'), isFalse);
  });

  test('saved include and note overlay the merged pool', () {
    final live = git(id: 'live-id', sha: 'abc1234', title: 'Fix login');
    final lines = mergeDailyReportPool(
      live: [live],
      authored: const [],
      saved: const DailyReport(
        date: '2026-08-22',
        lines: [
          DailyReportLine(
            subjectKey: 'github|acme/app|abc1234',
            included: false,
            note: 'skip this',
          ),
        ],
      ),
      orgTimezoneId: kDefaultOrgTimezoneId,
      reportDay: reportDay,
    );
    expect(lines.single.included, isFalse);
    expect(lines.single.note, 'skip this');
    expect(lines.single.role, DailyReportLineRole.directed);
  });

  test('follow-lane rows stay out unless includeFollowing is on', () {
    final followed = git(
      id: 'f1',
      sha: 'ffff111',
      title: 'Followed commit',
      lane: ActivityInboxLane.follow,
    );
    final hidden = mergeDailyReportPool(
      live: [followed],
      authored: const [],
      saved: DailyReport.empty(date: '2026-08-22'),
      orgTimezoneId: kDefaultOrgTimezoneId,
      reportDay: reportDay,
    );
    expect(hidden, isEmpty);

    final shown = mergeDailyReportPool(
      live: [followed],
      authored: const [],
      saved: DailyReport.empty(date: '2026-08-22'),
      orgTimezoneId: kDefaultOrgTimezoneId,
      reportDay: reportDay,
      includeFollowing: true,
    );
    expect(shown, hasLength(1));
  });
}
