import 'package:dab_app/domain/entities/activity/activity.dart';
import 'package:dab_app/presentation/views/dashboard/models/dashboard_activity_copy.dart';
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
      dashboardActivityHeadline(activity),
      'Align API boot for local Docker and Railway',
    );
    expect(gitBranchLabelFor(activity.provider), 'feature/ui_rework');
  });

  test('headline keeps the title when the prefix does not match', () {
    final activity = _commit(title: '[DAB-7] Inbox', branch: 'main');
    expect(dashboardActivityHeadline(activity), '[DAB-7] Inbox');
  });

  test('headline is unchanged when there is no branch', () {
    final activity = _commit(title: 'fix: typo');
    expect(dashboardActivityHeadline(activity), 'fix: typo');
    expect(gitBranchLabelFor(activity.provider), isNull);
  });
}
