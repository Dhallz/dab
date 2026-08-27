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

    expect(
      first.map((activity) => activity.id),
      second.map((activity) => activity.id),
    );
    expect(
      first.map((activity) => activity.inboxLane),
      containsAll([ActivityInboxLane.directed, ActivityInboxLane.follow]),
    );
  });

  test('variant shifts issue keys so teammates are not clones', () {
    final first = buildDemoDayActivities(
      user: user,
      date: '2026-08-24',
      providerIds: const {'jira'},
      createdAt: createdAt,
      variant: 0,
    );
    final second = buildDemoDayActivities(
      user: user,
      date: '2026-08-24',
      providerIds: const {'jira'},
      createdAt: createdAt,
      variant: 1,
    );

    expect(first.map((activity) => activity.title), contains('[DAB-42] Fix login'));
    expect(second.map((activity) => activity.title), contains('[DAB-43] Ship schema'));
  });

  test('dense catalog is a full inbox, not a teammate slice', () {
    final peer = TestData.user(
      id: 'u-peer',
      name: 'Rio Patel',
      email: 'rio@acme.com',
    );
    final thin = buildDemoDayActivities(
      user: user,
      date: '2026-08-24',
      providerIds: const {},
      createdAt: createdAt,
      teammates: [user, peer],
    );
    final packed = buildDemoDayActivities(
      user: user,
      date: '2026-08-24',
      providerIds: const {},
      createdAt: createdAt,
      teammates: [user, peer],
      dense: true,
    );

    expect(packed.length, greaterThan(thin.length * 2));
    expect(packed.length, greaterThan(40));
    expect(
      packed.where((activity) => activity.isFollowLane).length,
      greaterThan(10),
    );
  });

  test('handles come from the display name, not the email local-part', () {
    final personal = TestData.user(
      id: 'u-demo',
      name: 'Alex Rivera',
      email: 'dhawud@acme.com',
    );
    final activities = buildDemoDayActivities(
      user: personal,
      date: '2026-08-24',
      providerIds: const {'slack'},
      createdAt: createdAt,
    );

    expect(
      activities.map((activity) => activity.title),
      contains('[#eng] @alex can you take the login flake?'),
    );
    expect(
      activities.every((activity) {
        final blob = '${activity.title} ${activity.authorName}'.toLowerCase();
        return !blob.contains('dhawud');
      }),
      isTrue,
    );
  });

  test('teammates become senderUserId on inbound and Follow rows', () {
    final peer = TestData.user(
      id: 'u-peer',
      name: 'Rio Patel',
      email: 'rio@acme.com',
    );
    final activities = buildDemoDayActivities(
      user: user,
      date: '2026-08-24',
      providerIds: const {'slack', 'jira'},
      createdAt: createdAt,
      teammates: [user, peer],
    );

    expect(
      activities.any((activity) => activity.senderUserId == peer.id),
      isTrue,
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
