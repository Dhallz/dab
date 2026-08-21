import 'package:dab_api/src/domain/core/activity_follow_key.dart';
import 'package:dab_api/src/domain/entities/activity/activity_provider.dart';
import 'package:test/test.dart';

void main() {
  test('encodes Phorge, Jira, and Linear object keys', () {
    expect(
      (const PhorgeTaskProvider(taskPhid: 'PHID-TASK-1')).followObjectKey,
      'PHID-TASK-1',
    );
    expect(
      (const PhorgeTaskProvider(taskPhid: 'PHID-TASK-1')).followProviderId,
      'phorge',
    );
    expect(
      (const PhorgeRevisionProvider(revisionId: 'PHID-DREV-1')).followObjectKey,
      'PHID-DREV-1',
    );
    expect((const JiraIssueProvider(issueKey: 'DAB-7')).followObjectKey, 'DAB-7');
    expect(
      (const LinearIssueProvider(identifier: 'ENG-42')).followObjectKey,
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

  test('git Follow keys require a repo and a branch', () {
    expect(
      (const GitHubCommitProvider(repo: 'acme/app')).followObjectKey,
      isNull,
    );
    expect(
      (const GitLabCommitProvider(project: 'acme/app')).followProviderId,
      'gitlab',
    );
    expect(
      (const GitHubCommitProvider(repo: 'Acme/app', branch: 'refs/heads/feature/foo')).followObjectKey,
      'acme/app|feature/foo',
    );
    expect(
      parseGitFollowObjectKey('Acme/app|feature/foo')?.repo,
      'acme/app',
    );
    expect(
      (const BitbucketCommitProvider(repo: 'acme/app')).followObjectKey,
      isNull,
    );
    expect((const GenericProvider(name: 'other')).followObjectKey, isNull);
  });

  test('encodes Figma file keys', () {
    expect(
      (const FigmaFileProvider(fileKey: 'Abc123File')).followObjectKey,
      'Abc123File',
    );
    expect(
      (const FigmaFileProvider(fileKey: 'Abc123File')).followProviderId,
      'figma',
    );
  });
}
