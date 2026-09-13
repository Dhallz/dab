import 'package:dab_api/src/domain/core/jira_scope.dart';
import 'package:dab_api/src/infrastructure/sources/jira/jira_jql.dart';
import 'package:test/test.dart';

void main() {
  group('buildIssuesSearchJql', () {
    final start = DateTime.utc(2026, 5, 1, 0);
    final end = DateTime.utc(2026, 5, 7, 23, 59);

    test('requires project keys or extra JQL', () {
      expect(
        buildIssuesSearchJql(
          startInclusiveUtc: start,
          endInclusiveUtc: end,
          projectKeysRaw: const [],
          authoredOnly: false,
        ),
        isNull,
      );
    });

    test('builds window + project scope', () {
      final jql = buildIssuesSearchJql(
        startInclusiveUtc: start,
        endInclusiveUtc: end,
        projectKeysRaw: const ['FOO', 'BAR'],
        authoredOnly: false,
      );
      expect(jql, isNotNull);
      expect(jql, contains('updated >='));
      expect(jql, contains('project in (FOO, BAR)'));
    });

    test('authoredOnly requires account ids', () {
      expect(
        buildIssuesSearchJql(
          startInclusiveUtc: start,
          endInclusiveUtc: end,
          projectKeysRaw: const ['FOO'],
          authoredOnly: true,
          accountIds: const [],
        ),
        isNull,
      );
    });

    test('authoredOnly narrows by people clause', () {
      final jql = buildIssuesSearchJql(
        startInclusiveUtc: start,
        endInclusiveUtc: end,
        projectKeysRaw: const ['FOO'],
        authoredOnly: true,
        accountIds: const ['acc:1', 'acc:2'],
      );
      expect(jql, contains('reporter in ("acc:1", "acc:2")'));
      expect(jql, contains('assignee in ("acc:1", "acc:2")'));
    });
  });

  group('normalizeJiraCloudHost', () {
    test('parses host without scheme', () {
      expect(
        ('acme.atlassian.net').normalizeJiraCloudHost(),
        'acme.atlassian.net',
      );
    });

    test('strips path from full URL', () {
      expect(
        ('https://acme.atlassian.net/foo').normalizeJiraCloudHost(),
        'acme.atlassian.net',
      );
    });
  });

  group('jiraRequestAuth', () {
    test('OAuth uses the user apiToken even when org api.token is present', () {
      final auth = jiraRequestAuth({
        'api.token': 'org-pat',
        'apiToken': 'oauth-access',
        'tokenType': 'oauth',
        'cloudId': 'cloud-1',
        'instanceUrl': 'https://acme.atlassian.net',
      });
      expect(auth, isNotNull);
      expect(auth!.apiBase, 'https://api.atlassian.com/ex/jira/cloud-1');
      expect(auth.headers['Authorization'], 'Bearer oauth-access');
    });
  });
}
