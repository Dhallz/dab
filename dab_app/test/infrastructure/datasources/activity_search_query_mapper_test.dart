import 'package:dab_app/domain/entities/activity/activity.dart';
import 'package:dab_app/domain/entities/activity/activity_category.dart';
import 'package:dab_app/domain/entities/activity/activity_search_query.dart';
import 'package:dab_app/infrastructure/core/local/records/explorer_activity_record.dart';
import 'package:dab_app/infrastructure/datasources/activity_search_query_mapper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ActivitySearchQueryMapper', () {
    test('builds stable remote query parameters from canonical query', () {
      // Local-calendar dates align with picker semantics across time zones.
      final query = ActivitySearchQuery(
        startDate: DateTime(2026, 1, 1),
        endDate: DateTime(2026, 1, 7),
        users: const ['u2', 'u1'],
        authoredOnly: true,
      );

      final params = ActivitySearchQueryMapper.toRemoteQueryParameters(query);
      expect(params['startDate'], '2026-01-01');
      expect(params['endDate'], '2026-01-07');
      expect(params['users'], 'u1,u2');
      expect(params['authoredOnly'], 'true');
    });

    test('matches local and domain filters with same semantics', () {
      final activity = Activity(
        id: 'a1',
        userId: 'u1',
        provider: const SlackMessageProvider(channelId: 'C123'),
        title: 'Thread update',
        content: 'Status changed',
        authorName: 'Alice',
        commentCount: 0,
        createdAt: DateTime.utc(2026, 1, 2, 9),
      );
      final record = activity.toExplorerRecord();

      final query = ActivitySearchQuery(
        users: const ['u1'],
        providers: const {'slack'},
        categories: const {ActivityCategory.message},
        text: 'status',
      );

      expect(
        ActivitySearchQueryMapper.matchesActivity(activity, query),
        isTrue,
      );
      expect(
        ActivitySearchQueryMapper.matchesLocalRecord(record, query),
        isTrue,
      );
    });

    test('rejects activities outside selected date range', () {
      final activity = Activity(
        id: 'a2',
        userId: 'u1',
        provider: const SlackMessageProvider(channelId: 'C123'),
        title: 'Old update',
        content: 'Historic content',
        authorName: 'Alice',
        commentCount: 0,
        createdAt: DateTime.utc(2026, 1, 1, 10),
      );

      final query = ActivitySearchQuery(
        startDate: DateTime(2026, 1, 2),
        endDate: DateTime(2026, 1, 2),
      );

      expect(
        ActivitySearchQueryMapper.matchesActivity(activity, query),
        isFalse,
      );
    });

    test('providerFilterKey maps Jira typed provider to config id', () {
      expect(
        ActivitySearchQueryMapper.providerFilterKey(
          const JiraIssueProvider(),
        ),
        'jira',
      );
    });

    test('providerFilterKey maps Microsoft Teams to teams config id', () {
      expect(
        ActivitySearchQueryMapper.providerFilterKey(
          const GenericProvider(name: 'Microsoft Teams'),
        ),
        'teams',
      );

      final activity = Activity(
        id: 'a-teams',
        userId: 'u1',
        provider: const GenericProvider(name: 'Microsoft Teams'),
        title: 'msg',
        content: 'hello',
        authorName: 'Bob',
        commentCount: 0,
        createdAt: DateTime.utc(2026, 1, 5, 12),
      );

      expect(
        ActivitySearchQueryMapper.matchesActivity(
          activity,
          const ActivitySearchQuery(
            users: ['u1'],
            providers: {'teams'},
            categories: {ActivityCategory.generic},
          ),
        ),
        isTrue,
      );

      expect(activity.toExplorerRecord().providerKey, 'teams');
    });
  });
}
