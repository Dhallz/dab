import 'package:dab_api/src/domain/core/activity_follow_key.dart';
import 'package:dab_api/src/domain/entities/activity/activity_provider.dart';
import 'package:test/test.dart';

void main() {
  test('encodes Phorge, Jira, and Linear object keys', () {
    expect(
      followObjectKeyFor(const PhorgeTaskProvider(taskPhid: 'PHID-TASK-1')),
      'PHID-TASK-1',
    );
    expect(
      followProviderIdFor(const PhorgeTaskProvider(taskPhid: 'PHID-TASK-1')),
      'phorge',
    );
    expect(
      followObjectKeyFor(const PhorgeRevisionProvider(revisionId: 'PHID-DREV-1')),
      'PHID-DREV-1',
    );
    expect(followObjectKeyFor(const JiraIssueProvider(issueKey: 'DAB-7')), 'DAB-7');
    expect(
      followObjectKeyFor(const LinearIssueProvider(identifier: 'ENG-42')),
      'ENG-42',
    );
  });

  test('encodes Slack thread root and Discord conversation keys', () {
    expect(
      slackFollowObjectKey(
        workspaceId: 'T1',
        channelId: 'C1',
        threadTs: '100.1',
        messageTs: '100.2',
      ),
      'T1|C1|100.1',
    );
    expect(
      slackFollowObjectKey(
        workspaceId: 'T1',
        channelId: 'C1',
        messageTs: '100.2',
      ),
      'T1|C1|100.2',
    );
    expect(
      discordFollowObjectKey(
        guildId: 'G1',
        channelId: 'C1',
        messageId: 'm-root',
      ),
      'G1|C1|m-root',
    );
    expect(
      discordFollowLookupKeys(
        guildId: 'G1',
        channelId: 'C1',
        messageId: 'm-reply',
        replyToId: 'm-root',
      ),
      ['G1|C1|m-reply', 'G1|C1|m-root'],
    );
  });

  test('git and generic providers have no Follow control', () {
    expect(
      followObjectKeyFor(const GitHubCommitProvider(repo: 'acme/app')),
      isNull,
    );
    expect(
      followProviderIdFor(const GitLabCommitProvider(project: 'acme/app')),
      isNull,
    );
    expect(
      followObjectKeyFor(const BitbucketCommitProvider(repo: 'acme/app')),
      isNull,
    );
    expect(followObjectKeyFor(const GenericProvider(name: 'other')), isNull);
  });
}
