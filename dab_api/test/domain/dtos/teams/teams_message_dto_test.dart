import 'package:dab_api/src/domain/dtos/teams/teams_message_dto.dart';
import 'package:dab_api/src/domain/entities/activity/activity_provider.dart';
import 'package:test/test.dart';

import '../../../test_factories.dart';

void main() {
  test('returns no activity when dto is not attributed to user', () {
    final activities = TeamsMessageDto(
      teamId: 'team-1',
      channelId: 'channel-1',
      messageId: 'msg-1',
      content: 'hello',
      fromId: 'graph-u-1',
      createdAt: DateTime.utc(2026, 1, 1),
    ).toActivities([TestData.user(id: 'u-1')]);

    expect(activities, isEmpty);
  });

  test('maps teams message dto into activity', () {
    final user = TestData.user(id: 'u-1', name: 'Alice');
    final activities = TeamsMessageDto(
      teamId: 'team-1',
      channelId: 'channel-1',
      channelLabel: '#general',
      tenantId: 'tenant-1',
      messageId: 'msg-1',
      replyToId: 'root-msg',
      content: 'Deploy complete',
      fromId: 'graph-u-1',
      permalink: 'https://teams.microsoft.com/l/message/msg-1',
      dabUserId: 'u-1',
      createdAt: DateTime.utc(2026, 1, 1),
    ).toActivities([user]);

    expect(activities, hasLength(1));
    final activity = activities.single;
    expect(activity.userId, 'u-1');
    expect(activity.provider, isA<TeamsMessageProvider>());
    expect(activity.provider.name, 'Teams');
    expect(activity.provider.category, 'message');
    expect(activity.content, 'Deploy complete');
  });
}
