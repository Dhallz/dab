import 'package:dab_api/src/domain/core/report_subject_key.dart';
import 'package:dab_api/src/domain/entities/activity/activity.dart';
import 'package:dab_api/src/domain/entities/activity/activity_provider.dart';
import 'package:test/test.dart';

void main() {
  test('git occurrence uses commit sha and is not branch-only', () {
    final live = Activity(
      id: 'live-uuid',
      userId: 'u-1',
      provider: const GitHubCommitProvider(repo: 'Acme/app', branch: 'main'),
      title: 'Fix login',
      content: '',
      authorName: 'Ada',
      url: 'https://github.com/Acme/app/commit/abc1234def',
      createdAt: DateTime.utc(2026, 8, 22, 14, 5),
    );
    final search = Activity(
      id: 'search-uuid',
      userId: 'u-1',
      provider: const GitHubCommitProvider(repo: 'Acme/app', branch: 'main'),
      title: 'Fix login',
      content: '',
      authorName: 'Ada',
      url: '/Acme/app/commit/ABC1234DEF',
      createdAt: DateTime.utc(2026, 8, 22, 14, 5),
    );
    final otherCommit = Activity(
      id: 'other-uuid',
      userId: 'u-1',
      provider: const GitHubCommitProvider(repo: 'Acme/app', branch: 'main'),
      title: 'Different change',
      content: '',
      authorName: 'Ada',
      url: 'https://github.com/Acme/app/commit/ffffeeee',
      createdAt: DateTime.utc(2026, 8, 22, 15),
    );

    expect(live.reportSubjectKey, 'github|acme/app|abc1234def');
    expect(live.reportSubjectKey, search.reportSubjectKey);
    expect(live.reportSubjectKey, isNot(otherCommit.reportSubjectKey));
    expect(live.reportSubjectKey.contains('|main'), isFalse);
  });

  test('slack uses message ts rather than thread root', () {
    final activity = Activity(
      id: 's1',
      userId: 'u-1',
      provider: const SlackMessageProvider(
        workspaceId: 'T1',
        channelId: 'C1',
        threadTs: '100.1',
        messageTs: '100.2',
      ),
      title: 'hello',
      content: '',
      authorName: 'Ada',
      createdAt: DateTime.utc(2026, 8, 22),
    );
    expect(activity.reportSubjectKey, 'slack|T1|C1|100.2');
  });
}
