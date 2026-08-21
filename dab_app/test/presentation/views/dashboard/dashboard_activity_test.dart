import 'package:dab_app/domain/entities/activity/activity.dart';
import 'package:dab_app/presentation/core/extensions/activity_extensions.dart';
import 'package:dab_app/presentation/core/extensions/activity_provider_extensions.dart';
import 'package:flutter_test/flutter_test.dart';

Activity _commit({required String title, String? branch}) {
  return Activity(
    id: 'a-1',
    userId: 'u-1',
    provider: GitHubCommitProvider(repo: 'acme/app', branch: branch),
    title: title,
    content: 'body',
    authorName: 'Dhallz (@Dhallz)',
    commentCount: 0,
    createdAt: DateTime.utc(2026, 8, 17, 20, 47),
  );
}

void main() {
  test('headline strips a matching [branch] prefix from live rows', () {
    final activity = _commit(
      title: '[feature/ui_rework] Align API boot for local Docker and Railway',
      branch: 'feature/ui_rework',
    );
    expect(
      activity.dashboardHeadline,
      'Align API boot for local Docker and Railway',
    );
    expect(activity.provider.gitBranchLabel, 'feature/ui_rework');
  });

  test('headline keeps the title when the prefix does not match', () {
    final activity = _commit(title: '[DAB-7] Inbox', branch: 'main');
    expect(activity.dashboardHeadline, '[DAB-7] Inbox');
  });

  test('headline is unchanged when there is no branch', () {
    final activity = _commit(title: 'fix: typo');
    expect(activity.dashboardHeadline, 'fix: typo');
    expect(activity.provider.gitBranchLabel, isNull);
  });

  test('lane subtitle is Directed or Following', () {
    expect(_commit(title: 'fix').dashboardInboxLaneSubtitle, 'Directed');
    expect(
      Activity(
        id: 'a-2',
        userId: 'u-1',
        provider: const SlackMessageProvider(channelId: 'C1'),
        title: 'hello',
        content: 'body',
        authorName: 'Alice',
        commentCount: 0,
        createdAt: DateTime.utc(2026, 8, 17),
        inboxLane: ActivityInboxLane.follow,
      ).dashboardInboxLaneSubtitle,
      'Following',
    );
  });
}
