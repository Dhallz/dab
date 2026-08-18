import 'package:dab_app/domain/entities/activity/activity.dart';
import 'package:dab_app/domain/entities/user/activity_follow.dart';
import 'package:dab_app/domain/entities/user/follow_candidate.dart';
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

  test('followPickerVisible hides already Followed objects', () {
    const pin = ActivityFollow(providerId: 'jira', objectKey: 'DAB-7');
    const open = FollowCandidate(
      providerId: 'jira',
      objectKey: 'DAB-8',
      title: '[DAB-8] Other',
    );
    const followed = FollowCandidate(
      providerId: 'jira',
      objectKey: 'DAB-7',
      title: '[DAB-7] Inbox',
    );
    final state = DashboardState(
      follows: const [pin],
      followCandidates: const [open, followed],
    );
    expect(state.followPickerVisible.map((row) => row.objectKey), ['DAB-8']);
  });

  test('git branch pins appear as watching rows until a Follow-lane card exists', () {
    const pin = ActivityFollow(
      providerId: 'github',
      objectKey: 'acme/app|feature/foo',
      title: 'acme/app · feature/foo',
    );
    var state = const DashboardState(follows: [pin]);
    expect(state.watchingPins.single.displayTitle, 'acme/app · feature/foo');

    final followLane = Activity(
      id: 'f-git',
      userId: 'u-1',
      provider: const GitHubCommitProvider(
        repo: 'acme/app',
        branch: 'feature/foo',
      ),
      title: '[feature/foo] push',
      content: 'sha',
      authorName: 'Alice',
      commentCount: 0,
      createdAt: DateTime.utc(2026, 1, 1, 11),
      inboxLane: ActivityInboxLane.follow,
    );
    state = state.copyWith(activities: [followLane]);
    expect(state.watchingPins, isEmpty);
  });
}
