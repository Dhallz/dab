import 'package:dab_api/src/domain/dtos/slack/slack_message_dto.dart';
import 'package:dab_api/src/domain/entities/activity/activity.dart';
import 'package:dab_api/src/domain/entities/activity/activity_provider.dart';
import 'package:test/test.dart';

import '../../../test_factories.dart';

void main() {
  test('returns no activity when dto is not attributed to user', () {
    final activities = SlackMessageDto(
      channelId: 'C123',
      text: 'hello',
      userId: 'U123',
      ts: '1712523471.0123',
      createdAt: DateTime.utc(2026, 1, 1),
    ).toActivities([TestData.user(id: 'u-1')]);

    expect(activities, isEmpty);
  });

  test('maps slack message dto into activity', () {
    final user = TestData.user(id: 'u-1', name: 'Alice');
    final activities = SlackMessageDto(
      channelId: 'C123',
      workspaceId: 'T123',
      text: 'Deploy complete',
      userId: 'U123',
      ts: '1712523471.0123',
      threadTs: '1712523000.0001',
      permalink: 'https://acme.slack.com/archives/C123/p17125234710123',
      dabUserId: 'u-1',
      createdAt: DateTime.utc(2026, 1, 1),
    ).toActivities([user]);

    expect(activities, hasLength(1));
    final activity = activities.single;
    expect(activity.userId, 'u-1');
    expect(activity.provider, isA<SlackMessageProvider>());
    expect(activity.provider.name, 'Slack');
    expect(activity.provider.category, 'message');
    expect(activity.content, 'Deploy complete');
  });

  test('fan-out forUserIds uses live activity ids and permalinks', () {
    final alice = TestData.user(id: 'u-1', name: 'Alice');
    final bob = TestData.user(id: 'u-2', name: 'Bob');
    final activities = SlackMessageDto(
      channelId: 'C123',
      channelLabel: '#eng',
      workspaceId: 'T123',
      text: '@Alice hello',
      userId: 'U123',
      ts: '1712523471.0123',
      permalink: 'https://acme.slack.com/archives/C123/p17125234710123',
      userDisplayName: 'Alice',
      dabUserId: 'u-1',
      createdAt: DateTime.utc(2026, 1, 1),
    ).toActivities([alice, bob], forUserIds: ['u-1', 'u-2']);

    expect(activities, hasLength(2));
    expect(activities.map((a) => a.userId).toSet(), {'u-1', 'u-2'});
    expect(activities.every((a) => a.authorName == 'Alice'), isTrue);
    expect(
      activities.every(
        (a) => a.url == 'https://acme.slack.com/archives/C123/p17125234710123',
      ),
      isTrue,
    );
    expect(
      activities.every((a) => a.inboxLane == ActivityInboxLane.directed),
      isTrue,
    );
  });

  test('mention plus Follow emits two independent rows', () {
    final alice = TestData.user(id: 'u-1', name: 'Alice');
    final activities = SlackMessageDto(
      channelId: 'C123',
      channelLabel: '#eng',
      workspaceId: 'T123',
      text: '<@U1> hello',
      userId: 'U123',
      ts: '1712523471.0123',
      dabUserId: 'u-1',
      createdAt: DateTime.utc(2026, 1, 1),
    ).toActivities(
      [alice],
      forUserIds: ['u-1'],
      followerUserIds: ['u-1'],
    );

    expect(activities, hasLength(2));
    expect(activities.map((a) => a.inboxLane).toSet(), {
      ActivityInboxLane.directed,
      ActivityInboxLane.follow,
    });
    expect(activities[0].id, isNot(activities[1].id));
  });
}
