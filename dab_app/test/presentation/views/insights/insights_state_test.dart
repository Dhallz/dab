import 'package:dab_app/domain/core/org_calendar.dart';
import 'package:dab_app/domain/entities/activity/activity.dart';
import 'package:dab_app/presentation/views/insights/insights_state.dart';
import 'package:flutter_test/flutter_test.dart';

Activity _activity({
  required String id,
  required String userId,
  required DateTime createdAt,
  ActivityProvider provider = const SlackMessageProvider(channelId: 'C1'),
}) {
  return Activity(
    id: id,
    userId: userId,
    provider: provider,
    title: 'Row $id',
    content: 'Content',
    authorName: userId,
    commentCount: 0,
    createdAt: createdAt,
  );
}

void main() {
  setUpAll(initializeOrgCalendar);

  test('trend series adds every selected user onto the same org day', () {
    final state = InsightsState(
      startDate: DateTime(2026, 8, 20),
      endDate: DateTime(2026, 8, 26, 23, 59, 59, 999),
      activities: [
        _activity(
          id: 'a1',
          userId: 'u1',
          createdAt: DateTime.utc(2026, 8, 26, 14),
        ),
        _activity(
          id: 'a2',
          userId: 'u2',
          createdAt: DateTime.utc(2026, 8, 26, 18),
        ),
        _activity(
          id: 'a3',
          userId: 'u3',
          createdAt: DateTime.utc(2026, 8, 26, 21),
          provider: const GitHubCommitProvider(),
        ),
      ],
    );

    expect(state.dailyCounts('UTC')['2026-08-26'], 3);
    expect(state.trendProviderSeries('UTC')['Slack'], [
      0,
      0,
      0,
      0,
      0,
      0,
      2,
    ]);
    expect(state.trendProviderSeries('UTC')['GitHub'], [
      0,
      0,
      0,
      0,
      0,
      0,
      1,
    ]);
  });

  test('evening UTC instants still land on the org-calendar day', () {
    final state = InsightsState(
      startDate: DateTime(2026, 8, 26),
      endDate: DateTime(2026, 8, 26, 23, 59, 59, 999),
      activities: [
        _activity(
          id: 'a1',
          userId: 'u1',
          createdAt: DateTime.utc(2026, 8, 27, 2, 50),
        ),
        _activity(
          id: 'a2',
          userId: 'u2',
          createdAt: DateTime.utc(2026, 8, 27, 3, 10),
        ),
      ],
    );

    expect(state.dailyCounts('America/New_York')['2026-08-26'], 2);
    expect(state.trendProviderSeries('America/New_York')['Slack'], [2]);
  });
}
