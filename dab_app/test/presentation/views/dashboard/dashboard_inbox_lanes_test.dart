import 'package:dab_app/domain/entities/activity/activity.dart';
import 'package:dab_app/domain/entities/user/activity_follow.dart';
import 'package:dab_app/presentation/views/dashboard/dashboard_state.dart';
import 'package:flutter_test/flutter_test.dart';

Activity _activity({
  required String id,
  required ActivityInboxLane lane,
  bool archived = false,
}) {
  return Activity(
    id: id,
    userId: 'u-1',
    provider: const SlackMessageProvider(channelId: 'C1'),
    title: id,
    content: id,
    authorName: 'Alice',
    commentCount: 0,
    createdAt: DateTime.utc(2026, 1, 1, 10),
    archived: archived,
    inboxLane: lane,
  );
}

void main() {
  test('splits visible rows onto directed and Follow panes', () {
    final directed = _activity(id: 'd-1', lane: ActivityInboxLane.directed);
    final follow = _activity(id: 'f-1', lane: ActivityInboxLane.follow);
    final archivedDirected = _activity(
      id: 'd-arch',
      lane: ActivityInboxLane.directed,
      archived: true,
    );
    final state = DashboardState(
      activities: [directed, follow, archivedDirected],
    );

    expect(state.directedVisible.map((a) => a.id), ['d-1']);
    expect(state.followedVisible.map((a) => a.id), ['f-1']);

    final withArchived = state.copyWith(showArchivedActivities: true);
    expect(withArchived.directedVisible.map((a) => a.id), ['d-1', 'd-arch']);
    expect(withArchived.followedVisible.map((a) => a.id), ['f-1']);
  });

  test('legacy rows without an explicit lane stay on Directed', () {
    final legacy = Activity(
      id: 'legacy',
      userId: 'u-1',
      provider: const SlackMessageProvider(channelId: 'C1'),
      title: 'legacy',
      content: 'legacy',
      authorName: 'Alice',
      commentCount: 0,
      createdAt: DateTime.utc(2026, 1, 1, 10),
    );
    final state = DashboardState(activities: [legacy]);
    expect(legacy.inboxLane, ActivityInboxLane.directed);
    expect(state.directedVisible.single.id, 'legacy');
    expect(state.followedVisible, isEmpty);
  });

  test(
    'watchingPins show the Followed title until a Follow-lane card exists',
    () {
      const pin = ActivityFollow(
        providerId: 'phorge',
        objectKey: 'PHID-TASK-1',
        title: '[T1] Task',
      );
      final directed = Activity(
        id: 'd-1',
        userId: 'u-1',
        provider: const PhorgeTaskProvider(taskPhid: 'PHID-TASK-1'),
        title: '[T1] Task',
        content: 'comment',
        authorName: 'Alice',
        commentCount: 0,
        createdAt: DateTime.utc(2026, 1, 1, 10),
      );
      var state = DashboardState(activities: [directed], follows: [pin]);
      expect(state.watchingPins.single.displayTitle, '[T1] Task');

      final followLane = Activity(
        id: 'f-1',
        userId: 'u-1',
        provider: const PhorgeTaskProvider(taskPhid: 'PHID-TASK-1'),
        title: '[T1] Task',
        content: 'later',
        authorName: 'Alice',
        commentCount: 0,
        createdAt: DateTime.utc(2026, 1, 1, 11),
        inboxLane: ActivityInboxLane.follow,
      );
      state = state.copyWith(activities: [directed, followLane]);
      expect(state.watchingPins, isEmpty);
    },
  );
}
