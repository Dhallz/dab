import 'package:dab_api/src/domain/core/inbox_wake.dart';
import 'package:dab_api/src/domain/entities/activity/activity.dart';
import 'package:dab_api/src/domain/entities/activity/activity_provider.dart';
import 'package:test/test.dart';

void main() {
  Activity activity({
    ActivityInboxLane lane = ActivityInboxLane.directed,
  }) {
    return Activity(
      id: 'a-1',
      userId: 'u-1',
      provider: const GenericProvider(name: 'github'),
      title: 'Secret title',
      content: 'Secret body',
      authorName: 'Alice',
      createdAt: DateTime.utc(2026, 1, 1),
      inboxLane: lane,
    );
  }

  test('inboxWakeData is lane and id only', () {
    final data = inboxWakeData(activity(lane: ActivityInboxLane.follow));
    expect(data, {
      'type': 'inbox_wake',
      'lane': 'follow',
      'activityId': 'a-1',
    });
    expect(isInboxWakeData(data), isTrue);
  });

  test('isInboxWakeData rejects activity copy', () {
    expect(
      isInboxWakeData({
        'type': 'inbox_wake',
        'lane': 'directed',
        'activityId': 'a-1',
        'title': 'Secret title',
      }),
      isFalse,
    );
    expect(
      isInboxWakeData({
        'type': 'inbox_wake',
        'lane': 'directed',
        'activityId': 'a-1',
        'content': 'Secret body',
      }),
      isFalse,
    );
  });
}
