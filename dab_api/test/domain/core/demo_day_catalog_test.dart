import 'package:dab_api/src/domain/core/demo_day_catalog.dart';
import 'package:dab_api/src/domain/entities/activity/activity.dart';
import 'package:dab_api/src/domain/entities/activity/activity_provider.dart';
import 'package:test/test.dart';

import '../../test_factories.dart';

void main() {
  final user = TestData.user(
    id: 'u-demo',
    name: 'Ada Lovelace',
    email: 'ada@acme.com',
  );
  final createdAt = DateTime.utc(2026, 8, 24, 17, 30);

  test('uses ingest title shapes and real provider types', () {
    final activities = buildDemoDayActivities(
      user: user,
      date: '2026-08-24',
      providerIds: const {},
      createdAt: createdAt,
    );

    expect(
      activities.map((activity) => activity.provider.runtimeType).toSet(),
      containsAll({
        GitHubCommitProvider,
        GitLabCommitProvider,
        BitbucketCommitProvider,
        JiraIssueProvider,
        LinearIssueProvider,
        PhorgeTaskProvider,
        PhorgeRevisionProvider,
        SlackMessageProvider,
        DiscordMessageProvider,
        FigmaFileProvider,
      }),
    );
    expect(
      activities.map((activity) => activity.title),
      containsAll([
        '[DAB-42] Fix login',
        '[ENG-18] Ship schema',
        '[T12] Fix login',
        '[#eng] @ada can you take the login flake?',
      ]),
    );
    expect(
      activities.where((activity) => activity.isFollowLane),
      isNotEmpty,
    );
  });

  test('empty providerIds seeds every catalog provider; a set filters', () {
    final all = buildDemoDayActivities(
      user: user,
      date: '2026-08-24',
      providerIds: const {},
      createdAt: createdAt,
    );
    final jiraOnly = buildDemoDayActivities(
      user: user,
      date: '2026-08-24',
      providerIds: const {'jira'},
      createdAt: createdAt,
    );

    expect(all.length, greaterThan(jiraOnly.length));
    expect(
      jiraOnly.every((activity) => activity.provider is JiraIssueProvider),
      isTrue,
    );
  });

  test('ids are stable for the same user, date, and kind', () {
    final first = buildDemoDayActivities(
      user: user,
      date: '2026-08-24',
      providerIds: const {'github'},
      createdAt: createdAt,
    );
    final second = buildDemoDayActivities(
      user: user,
      date: '2026-08-24',
      providerIds: const {'github'},
      createdAt: createdAt,
    );

    expect(first.map((activity) => activity.id), second.map((activity) => activity.id));
    expect(
      first.map((activity) => activity.inboxLane),
      containsAll([ActivityInboxLane.directed, ActivityInboxLane.follow]),
    );
  });

  test('clamps stamps onto the UTC day of createdAt', () {
    final early = DateTime.utc(2026, 8, 24, 0, 8);
    final activities = buildDemoDayActivities(
      user: user,
      date: '2026-08-24',
      providerIds: const {},
      createdAt: early,
    );
    final dayStart = DateTime.utc(2026, 8, 24);

    expect(activities, isNotEmpty);
    expect(
      activities.every((activity) => !activity.createdAt.isBefore(dayStart)),
      isTrue,
    );
  });
}
