import 'package:dab_api/src/domain/mappers/github/github_commit_mapper.dart';
import 'package:dab_api/src/domain/entities/provider_payloads/github/github_commit_dto.dart';
import 'package:test/test.dart';

import '../../../test_factories.dart';

void main() {
  final mapper = GitHubCommitMapper();

  test('returns no activity when dto is not attributed to a user', () {
    final activities = mapper.mapToActivities(
      GitHubCommitDto(
        repo: 'acme/repo',
        sha: 'abc1234',
        message: 'feat: add flow',
        url: 'https://github.com/acme/repo/commit/abc1234',
        committedAt: DateTime.utc(2026, 1, 1),
      ),
      [TestData.user(id: 'u-1')],
    );

    expect(activities, isEmpty);
  });

  test('maps commit dto into a github activity', () {
    final user = TestData.user(id: 'u-1', name: 'Alice');
    final activities = mapper.mapToActivities(
      GitHubCommitDto(
        repo: 'acme/repo',
        branch: 'main',
        sha: 'abc1234',
        message: 'feat: add flow\n\nBody paragraph.',
        url: 'https://github.com/acme/repo/commit/abc1234',
        committedAt: DateTime.utc(2026, 1, 1),
        authorLogin: 'alicegh',
        userId: 'u-1',
      ),
      [user],
    );

    expect(activities, hasLength(1));
    final activity = activities.single;
    expect(activity.userId, 'u-1');
    expect(activity.provider.name, 'GitHub');
    expect(activity.provider.category, 'commit');
    expect(activity.title, '[main] feat: add flow');
    expect(activity.content, 'Body paragraph.');
    expect(activity.authorName, 'Alice (@alicegh)');
  });

  test('uses subject only title when branch is absent', () {
    final user = TestData.user(id: 'u-1', name: 'Bob');
    final activities = mapper.mapToActivities(
      GitHubCommitDto(
        repo: 'acme/repo',
        sha: 'deadbeef',
        message: 'fix: typo',
        url: 'https://github.com/acme/repo/commit/deadbeef',
        committedAt: DateTime.utc(2026, 1, 2),
        authorLogin: 'bob',
        userId: 'u-1',
      ),
      [user],
    );
    expect(activities.single.title, 'fix: typo');
    expect(activities.single.content, '');
    expect(activities.single.authorName, 'Bob (@bob)');
  });
}
