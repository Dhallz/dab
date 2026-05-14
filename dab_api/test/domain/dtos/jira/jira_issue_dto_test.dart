import 'package:dab_api/src/domain/dtos/jira/jira_issue_dto.dart';
import 'package:dab_api/src/domain/entities/activity/activity_provider.dart';
import 'package:dab_api/src/domain/entities/user/user.dart';
import 'package:dab_api/src/domain/entities/user/user_role.dart';
import 'package:test/test.dart';

void main() {
  group('OnJiraIssueDto', () {
    test('maps to Activity when dabUserId resolves in target users', () {
      final user = User(
        id: 'u1',
        name: 'Pat',
        email: 'pat@test',
        role: UserRole.standard,
        passwordHash: '',
        createdAt: DateTime.utc(2020),
      );

      final dto = JiraIssueDto(
        issueKey: 'FOO-10',
        projectKey: 'FOO',
        summary: 'Fix flaky test',
        statusName: 'In Progress',
        browseUrl: 'https://acme.atlassian.net/browse/FOO-10',
        updatedAt: DateTime.utc(2026, 5, 1, 12),
        siteHost: 'acme.atlassian.net',
        dabUserId: 'u1',
        authorDisplayName: 'Pat Slack',
      );

      final activities = dto.toActivities([user]);
      expect(activities, hasLength(1));
      final a = activities.single;
      expect(a.userId, 'u1');
      expect(a.provider, isA<JiraIssueProvider>());
      final p = a.provider as JiraIssueProvider;
      expect(p.issueKey, 'FOO-10');
      expect(p.projectKey, 'FOO');
      expect(a.title, contains('FOO-10'));
      expect(a.url, contains('browse'));
    });

    test('returns empty without dabUserId', () {
      final user = User(
        id: 'u1',
        name: 'Pat',
        email: 'pat@test',
        role: UserRole.standard,
        passwordHash: '',
        createdAt: DateTime.utc(2020),
      );

      final dto = JiraIssueDto(
        issueKey: 'FOO-11',
        projectKey: 'FOO',
        summary: 'x',
        statusName: 'Open',
        browseUrl: 'https://acme.atlassian.net/browse/FOO-11',
        updatedAt: DateTime.utc(2026, 5, 1, 12),
        siteHost: 'acme.atlassian.net',
      );

      expect(dto.toActivities([user]), isEmpty);
    });
  });
}
