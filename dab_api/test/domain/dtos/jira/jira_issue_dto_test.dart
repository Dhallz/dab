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
        comments: [
          JiraIssueCommentDto(
            id: 'c-1',
            body: 'Looks good to me.',
            createdAt: DateTime.utc(2026, 5, 1, 13),
            dabUserId: 'u1',
            authorDisplayName: 'Pat Slack',
          ),
        ],
      );

      final activities = dto.toActivities([user]);
      expect(activities, hasLength(2));
      final a = activities.first;
      expect(a.userId, 'u1');
      expect(a.provider, isA<JiraIssueProvider>());
      final p = a.provider as JiraIssueProvider;
      expect(p.issueKey, 'FOO-10');
      expect(p.projectKey, 'FOO');
      expect(a.title, contains('FOO-10'));
      expect(a.url, contains('browse'));
      expect(
        activities.any((e) => e.content.contains('Looks good to me.')),
        isTrue,
      );
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

    test(
      'maps linked comment activity even when issue owner is unavailable',
      () {
        final user = User(
          id: 'u1',
          name: 'Pat',
          email: 'pat@test',
          role: UserRole.standard,
          passwordHash: '',
          createdAt: DateTime.utc(2020),
        );

        final dto = JiraIssueDto(
          issueKey: 'FOO-12',
          projectKey: 'FOO',
          summary: 'Investigate bug',
          statusName: 'Open',
          browseUrl: 'https://acme.atlassian.net/browse/FOO-12',
          updatedAt: DateTime.utc(2026, 5, 1, 12),
          siteHost: 'acme.atlassian.net',
          comments: [
            JiraIssueCommentDto(
              id: 'c-2',
              body: 'I reproduced this locally.',
              createdAt: DateTime.utc(2026, 5, 1, 13),
              dabUserId: 'u1',
              authorDisplayName: 'Pat Slack',
            ),
          ],
        );

        final activities = dto.toActivities([user]);
        expect(activities, hasLength(1));
        expect(activities.first.content, contains('reproduced'));
        expect(activities.first.userId, 'u1');
      },
    );

    test(
      'keeps comment event using fallback user when comment author is unmapped',
      () {
        final user = User(
          id: 'u1',
          name: 'Pat',
          email: 'pat@test',
          role: UserRole.standard,
          passwordHash: '',
          createdAt: DateTime.utc(2020),
        );

        final dto = JiraIssueDto(
          issueKey: 'FOO-13',
          projectKey: 'FOO',
          summary: 'Discuss scope',
          statusName: 'Open',
          browseUrl: 'https://acme.atlassian.net/browse/FOO-13',
          updatedAt: DateTime.utc(2026, 5, 1, 12),
          siteHost: 'acme.atlassian.net',
          dabUserId: 'u1',
          comments: [
            JiraIssueCommentDto(
              id: 'c-3',
              body: 'Unlinked account comment',
              createdAt: DateTime.utc(2026, 5, 1, 13),
              dabUserId: null,
              authorDisplayName: 'External Person',
            ),
          ],
        );

        final activities = dto.toActivities([user]);
        expect(activities, hasLength(2));
        final commentEvent = activities.firstWhere(
          (a) => a.content.contains('Unlinked account comment'),
        );
        expect(commentEvent.userId, 'u1');
        expect(commentEvent.authorName, contains('External Person'));
      },
    );

    test('omits the issue snapshot when includeIssueSnapshot is false', () {
      final user = User(
        id: 'u1',
        name: 'Pat',
        email: 'pat@test',
        role: UserRole.standard,
        passwordHash: '',
        createdAt: DateTime.utc(2020),
      );

      final dto = JiraIssueDto(
        issueKey: 'FOO-14',
        projectKey: 'FOO',
        summary: 'Discuss scope',
        statusName: 'Open',
        browseUrl: 'https://acme.atlassian.net/browse/FOO-14',
        updatedAt: DateTime.utc(2026, 5, 1, 12),
        siteHost: 'acme.atlassian.net',
        dabUserId: 'u1',
        includeIssueSnapshot: false,
        comments: [
          JiraIssueCommentDto(
            id: 'c-4',
            body: 'Just the comment',
            createdAt: DateTime.utc(2026, 5, 1, 13),
            dabUserId: 'u1',
          ),
        ],
      );

      final activities = dto.toActivities([user]);
      expect(activities, hasLength(1));
      expect(activities.single.commentCount, 1);
      expect(activities.single.content, 'Just the comment');
    });

    test('keeps comment activity ids stable across issue updatedAt', () {
      final user = User(
        id: 'u1',
        name: 'Pat',
        email: 'pat@test',
        role: UserRole.standard,
        passwordHash: '',
        createdAt: DateTime.utc(2020),
      );

      JiraIssueDto commentedAt(DateTime updatedAt) {
        return JiraIssueDto(
          issueKey: 'FOO-15',
          projectKey: 'FOO',
          summary: 'Stable id',
          statusName: 'Open',
          browseUrl: 'https://acme.atlassian.net/browse/FOO-15',
          updatedAt: updatedAt,
          siteHost: 'acme.atlassian.net',
          includeIssueSnapshot: false,
          comments: [
            JiraIssueCommentDto(
              id: 'c-stable',
              body: 'Same comment',
              createdAt: DateTime.utc(2026, 5, 1, 13),
              dabUserId: 'u1',
            ),
          ],
        );
      }

      final first = commentedAt(
        DateTime.utc(2026, 5, 1, 12),
      ).toActivities([user]).single;
      final later = commentedAt(
        DateTime.utc(2026, 5, 1, 12, 5),
      ).toActivities([user]).single;
      expect(first.id, later.id);
    });

    test(
      'status moves mint a new activity id so Dashboard can live-publish',
      () {
        final user = User(
          id: 'u1',
          name: 'Pat',
          email: 'pat@test',
          role: UserRole.standard,
          passwordHash: '',
          createdAt: DateTime.utc(2020),
        );

        JiraIssueDto issueAt(DateTime updatedAt, String status) {
          return JiraIssueDto(
            issueKey: 'FOO-10',
            projectKey: 'FOO',
            summary: 'Fix flaky test',
            statusName: status,
            browseUrl: 'https://acme.atlassian.net/browse/FOO-10',
            updatedAt: updatedAt,
            siteHost: 'acme.atlassian.net',
            dabUserId: 'u1',
          );
        }

        final first = issueAt(
          DateTime.utc(2026, 5, 1, 12),
          'To Do',
        ).toActivities([user]).single;
        final moved = issueAt(
          DateTime.utc(2026, 5, 1, 12, 5),
          'In Progress',
        ).toActivities([user]).single;
        expect(first.id, isNot(moved.id));
        expect(moved.content, contains('In Progress'));
      },
    );
  });
}
