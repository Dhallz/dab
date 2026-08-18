import 'package:dab_app/domain/core/activity_follow_key.dart';
import 'package:dab_app/domain/entities/activity/activity_provider.dart';
import 'package:dab_app/domain/entities/user/activity_follow.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('parses providerId and objectKey from the API map', () {
    final follow = ActivityFollow.fromMap({
      'providerId': 'jira',
      'objectKey': 'DAB-7',
    });
    expect(follow.providerId, 'jira');
    expect(follow.objectKey, 'DAB-7');
    expect(follow.objectRef, followObjectRef('jira', 'DAB-7'));
    expect(follow.displayTitle, 'DAB-7');
  });

  test('uses the stored title for Following placeholder copy', () {
    final follow = ActivityFollow.fromMap({
      'providerId': 'phorge',
      'objectKey': 'PHID-TASK-1',
      'title': '[T123] Fix login',
      'url': '/T123',
    });
    expect(follow.displayTitle, '[T123] Fix login');
    expect(follow.url, '/T123');
  });

  test('git Follow keys require a repo and a branch', () {
    expect(
      followObjectKeyFor(const GitHubCommitProvider(repo: 'acme/app')),
      isNull,
    );
    expect(
      followObjectRefFor(const GitHubCommitProvider(repo: 'acme/app')),
      isNull,
    );
    expect(
      followObjectKeyFor(
        const GitHubCommitProvider(repo: 'Acme/app', branch: 'feature/foo'),
      ),
      'acme/app|feature/foo',
    );
  });

  test('activityProviderForFollow round-trips stored Follow keys', () {
    const cases = <ActivityProvider>[
      PhorgeTaskProvider(taskPhid: 'PHID-TASK-1'),
      PhorgeRevisionProvider(revisionId: 'PHID-DREV-1'),
      JiraIssueProvider(issueKey: 'DAB-7'),
      LinearIssueProvider(identifier: 'ENG-42'),
      SlackMessageProvider(
        workspaceId: 'T1',
        channelId: 'C1',
        threadTs: '100.1',
        messageTs: '100.1',
      ),
      DiscordMessageProvider(
        guildId: 'G1',
        channelId: 'C1',
        messageId: 'm-root',
      ),
      GitHubCommitProvider(repo: 'acme/app', branch: 'feature/foo'),
    ];
    for (final provider in cases) {
      final providerId = followProviderIdFor(provider);
      final objectKey = followObjectKeyFor(provider);
      expect(providerId, isNotNull, reason: '$provider');
      expect(objectKey, isNotNull, reason: '$provider');
      final rebuilt = activityProviderForFollow(
        providerId: providerId!,
        objectKey: objectKey!,
      );
      expect(followObjectKeyFor(rebuilt), objectKey, reason: '$provider');
      expect(followProviderIdFor(rebuilt), providerId, reason: '$provider');
    }
  });
}
