import 'package:dab_api/src/domain/dtos/slack/slack_message_dto.dart';
import 'package:dab_api/src/domain/entities/activity/activity_provider.dart';
import 'package:test/test.dart';

import '../../../../test_factories.dart';

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
}
