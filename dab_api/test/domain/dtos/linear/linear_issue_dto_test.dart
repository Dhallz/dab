import 'package:dab_api/src/domain/dtos/linear/linear_issue_dto.dart';
import 'package:dab_api/src/domain/entities/activity/activity_provider.dart';
import 'package:dab_api/src/domain/entities/user/user.dart';
import 'package:dab_api/src/domain/entities/user/user_role.dart';
import 'package:test/test.dart';

void main() {
  group('OnLinearIssueDto', () {
    final user = User(
      id: 'u1',
      name: 'Pat',
      email: 'pat@test',
      role: UserRole.standard,
      passwordHash: '',
      createdAt: DateTime.utc(2020),
    );

    LinearIssueDto issue({
      DateTime? updatedAt,
      String status = 'In Progress',
      String? dabUserId = 'u1',
      List<LinearIssueCommentDto> comments = const [],
      bool includeIssueSnapshot = true,
    }) {
      return LinearIssueDto(
        identifier: 'ENG-42',
        teamKey: 'ENG',
        title: 'Fix login',
        statusName: status,
        url: 'https://linear.app/acme/issue/ENG-42',
        updatedAt: updatedAt ?? DateTime.utc(2026, 5, 1, 12),
        dabUserId: dabUserId,
        authorDisplayName: 'Pat Slack',
        comments: comments,
        includeIssueSnapshot: includeIssueSnapshot,
      );
    }

    test('maps to Activity when dabUserId resolves in target users', () {
      final activities = issue().toActivities([user]);
      expect(activities, hasLength(1));
      final a = activities.single;
      expect(a.userId, 'u1');
      expect(a.provider, isA<LinearIssueProvider>());
      final p = a.provider as LinearIssueProvider;
      expect(p.identifier, 'ENG-42');
      expect(a.title, '[ENG-42] Fix login');
      expect(a.commentCount, 0);
    });

    test(
      'emits a distinct comment activity that shares the issue identifier',
      () {
        final activities = issue(
          comments: [
            LinearIssueCommentDto(
              id: 'c-1',
              body: 'Can you take a look?',
              createdAt: DateTime.utc(2026, 5, 1, 13),
              dabUserId: 'u1',
              authorDisplayName: 'Pat Slack',
            ),
          ],
        ).toActivities([user]);

        expect(activities, hasLength(2));
        final comment = activities.firstWhere((a) => a.commentCount == 1);
        expect(comment.content, 'Can you take a look?');
        expect(comment.userId, 'u1');
        expect(
          comment.id,
          isNot(activities.firstWhere((a) => a.commentCount == 0).id),
        );
        expect((comment.provider as LinearIssueProvider).identifier, 'ENG-42');
      },
    );

    test('comment webhooks omit the issue snapshot', () {
      final activities = issue(
        includeIssueSnapshot: false,
        comments: [
          LinearIssueCommentDto(
            id: 'c-1',
            body: 'Ping',
            createdAt: DateTime.utc(2026, 5, 1, 13),
            dabUserId: 'u1',
          ),
        ],
      ).toActivities([user]);

      expect(activities, hasLength(1));
      expect(activities.single.commentCount, 1);
    });

    test('unmapped comment authors fall back to the issue owner', () {
      final activities = issue(
        includeIssueSnapshot: false,
        comments: [
          LinearIssueCommentDto(
            id: 'c-2',
            body: 'External ping',
            createdAt: DateTime.utc(2026, 5, 1, 13),
            authorDisplayName: 'Visitor',
          ),
        ],
      ).toActivities([user]);

      expect(activities, hasLength(1));
      expect(activities.single.userId, 'u1');
      expect(activities.single.authorName, contains('Visitor'));
    });

    test(
      'status moves mint a new activity id so Dashboard can live-publish',
      () {
        final first = issue(
          updatedAt: DateTime.utc(2026, 5, 1, 12),
          status: 'To Do',
        ).toActivities([user]).single;
        final moved = issue(
          updatedAt: DateTime.utc(2026, 5, 1, 12, 5),
          status: 'In Progress',
        ).toActivities([user]).single;
        expect(first.id, isNot(moved.id));
        expect(moved.content, contains('In Progress'));
      },
    );
  });
}
