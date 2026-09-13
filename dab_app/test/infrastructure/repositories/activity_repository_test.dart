import 'package:dab_app/domain/entities/activity/activity.dart';
import 'package:dab_app/domain/entities/activity/activity_search_query.dart';
import 'package:dab_app/domain/entities/activity/explorer_cache_clear_request.dart';
import 'package:dab_app/infrastructure/datasources/activity_local_data_source.dart';
import 'package:dab_app/infrastructure/datasources/activity_remote_data_source.dart';
import 'package:dab_app/infrastructure/repositories/activity_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockActivityRemoteDataSource extends Mock
    implements ActivityRemoteDataSource {}

class MockActivityLocalDataSource extends Mock
    implements ActivityLocalDataSource {}

void main() {
  late ActivityRepository repository;
  late MockActivityRemoteDataSource mockDataSource;
  late MockActivityLocalDataSource mockLocalDataSource;

  const fallbackQuery = ActivitySearchQuery();

  setUpAll(() {
    registerFallbackValue(fallbackQuery);
  });

  setUp(() {
    mockDataSource = MockActivityRemoteDataSource();
    mockLocalDataSource = MockActivityLocalDataSource();
    repository = ActivityRepository(mockDataSource, mockLocalDataSource);

    when(
      () => mockLocalDataSource.searchActivities(any()),
    ).thenAnswer((_) async => const []);
    when(
      () => mockLocalDataSource.getCoveredKeys(
        startDate: any(named: 'startDate'),
        endDate: any(named: 'endDate'),
        users: any(named: 'users'),
        providers: any(named: 'providers'),
        orgTimezoneId: any(named: 'orgTimezoneId'),
      ),
    ).thenAnswer((_) async => const {});
    when(
      () => mockLocalDataSource.markCoverage(
        any(),
        orgTimezoneId: any(named: 'orgTimezoneId'),
      ),
    ).thenAnswer((_) async {});
    when(
      () => mockLocalDataSource.upsertActivities(
        any(),
        orgTimezoneId: any(named: 'orgTimezoneId'),
      ),
    ).thenAnswer((_) async {});
    when(
      () => mockLocalDataSource.clearExplorerCache(request: any(named: 'request')),
    ).thenAnswer(
      (_) async => const ExplorerCacheClearResult(
        removedActivities: 0,
        removedCoverageRecords: 0,
      ),
    );
    when(() => mockLocalDataSource.clearExplorerCache()).thenAnswer(
      (_) async => const ExplorerCacheClearResult(
        removedActivities: 0,
        removedCoverageRecords: 0,
      ),
    );
  });

  group('searchActivities', () {
    test('normalizes slack provider values and returns newest-first', () async {
      final older = Activity(
        id: 'older',
        userId: 'user-1',
        provider: const SlackMessageProvider(
          workspaceId: ' W123 ',
          channelId: ' C123 ',
          threadTs: '   ',
          messageTs: ' 1730000001.0001 ',
        ),
        title: 'older',
        content: 'older content',
        authorName: 'Alice',
        commentCount: 0,
        createdAt: DateTime.utc(2026, 1, 1, 10, 0),
      );

      final newer = Activity(
        id: 'newer',
        userId: 'user-1',
        provider: const SlackMessageProvider(
          workspaceId: 'W123',
          channelId: 'C123',
          threadTs: '1730000002.0001',
          messageTs: '1730000002.0001',
        ),
        title: 'newer',
        content: 'newer content',
        authorName: 'Alice',
        commentCount: 0,
        createdAt: DateTime.utc(2026, 1, 1, 10, 5),
      );

      final response = Response(
        requestOptions: RequestOptions(path: '/activities/search'),
        statusCode: 200,
        data: {
          'data': [older.toMap(), newer.toMap()],
        },
      );

      when(
        () => mockDataSource.searchActivities(any()),
      ).thenAnswer((_) async => response);

      final result = await repository.searchActivities(
        const ActivitySearchQuery(),
      );

      result.fold(
        (failure) => fail('Expected success but got failure: $failure'),
        (activities) {
          expect(activities.map((a) => a.id).toList(), ['newer', 'older']);

          final olderProvider =
              activities.last.provider as SlackMessageProvider;
          expect(olderProvider.workspaceId, 'W123');
          expect(olderProvider.channelId, 'C123');
          expect(olderProvider.threadTs, isNull);
          expect(olderProvider.messageTs, '1730000001.0001');
        },
      );

      verify(() => mockDataSource.searchActivities(any())).called(1);
    });

    test(
      'uses local first for past dates and backfills missing coverage',
      () async {
        final activity = Activity(
          id: 'past-1',
          userId: 'u1',
          provider: const SlackMessageProvider(channelId: 'C123'),
          title: 'Past',
          content: 'Backfill',
          authorName: 'Alice',
          commentCount: 0,
          createdAt: DateTime.utc(2026, 1, 2, 12),
        );
        final response = Response(
          requestOptions: RequestOptions(path: '/activities/search'),
          statusCode: 200,
          data: {
            'data': [activity.toMap()],
          },
        );

        when(
          () => mockDataSource.searchActivities(any()),
        ).thenAnswer((_) async => response);
        var localReadCount = 0;
        when(() => mockLocalDataSource.searchActivities(any())).thenAnswer((
          _,
        ) async {
          localReadCount += 1;
          if (localReadCount == 1) return const [];
          return [activity];
        });

        final query = ActivitySearchQuery(
          startDate: DateTime.utc(2026, 1, 2),
          endDate: DateTime.utc(2026, 1, 2),
          users: const ['u1'],
          providers: const {'slack'},
          coverageProviders: const {'slack'},
        );

        final result = await repository.searchActivities(query);

        result.fold(
          (failure) => fail('Expected success but got failure: $failure'),
          (activities) => expect(activities.map((a) => a.id), ['past-1']),
        );

        verify(() => mockLocalDataSource.searchActivities(any())).called(2);
        verify(() => mockDataSource.searchActivities(any())).called(1);
        verify(() => mockLocalDataSource.upsertActivities(
          any(),
          orgTimezoneId: any(named: 'orgTimezoneId'),
        )).called(1);
        verify(() => mockLocalDataSource.markCoverage(
          any(),
          orgTimezoneId: any(named: 'orgTimezoneId'),
        )).called(1);
      },
    );

    test(
      'past backfill upserts unfiltered API rows when display filters are narrower',
      () async {
        final slackActivity = Activity(
          id: 'past-slack',
          userId: 'u1',
          provider: const SlackMessageProvider(channelId: 'C123'),
          title: 'Slack',
          content: 'Message',
          authorName: 'Alice',
          commentCount: 0,
          createdAt: DateTime.utc(2026, 1, 2, 10),
        );
        final githubActivity = Activity(
          id: 'past-github',
          userId: 'u1',
          provider: const GitHubCommitProvider(repo: 'dab'),
          title: 'Commit',
          content: 'Fix cache',
          authorName: 'Alice',
          commentCount: 0,
          createdAt: DateTime.utc(2026, 1, 2, 11),
        );
        final response = Response(
          requestOptions: RequestOptions(path: '/activities/search'),
          statusCode: 200,
          data: {
            'data': [slackActivity.toMap(), githubActivity.toMap()],
          },
        );

        when(
          () => mockDataSource.searchActivities(any()),
        ).thenAnswer((_) async => response);

        final capturedUpserts = <List<Activity>>[];
        when(
          () => mockLocalDataSource.upsertActivities(
            any(),
            orgTimezoneId: any(named: 'orgTimezoneId'),
          ),
        ).thenAnswer((invocation) async {
          capturedUpserts.add(
            List<Activity>.from(invocation.positionalArguments.first as List),
          );
        });

        when(() => mockLocalDataSource.searchActivities(any())).thenAnswer(
          (_) async => [slackActivity],
        );

        final query = ActivitySearchQuery(
          startDate: DateTime.utc(2026, 1, 2),
          endDate: DateTime.utc(2026, 1, 2),
          users: const ['u1'],
          providers: const {'slack'},
          coverageProviders: const {'slack', 'github'},
        );

        final result = await repository.searchActivities(query);

        result.fold(
          (failure) => fail('Expected success but got failure: $failure'),
          (activities) => expect(activities.map((a) => a.id), ['past-slack']),
        );

        expect(capturedUpserts, hasLength(1));
        expect(
          capturedUpserts.single.map((activity) => activity.id).toSet(),
          {'past-slack', 'past-github'},
        );
      },
    );
  });

  group('clearExplorerCache', () {
    test('delegates full clear when request is omitted', () async {
      when(() => mockLocalDataSource.clearExplorerCache()).thenAnswer(
        (_) async => const ExplorerCacheClearResult(
          removedActivities: 4,
          removedCoverageRecords: 2,
        ),
      );

      final result = await repository.clearExplorerCache();

      expect(result.isRight(), isTrue);
      expect(result.getOrElse((_) => throw StateError('expected right')).totalRemoved, 6);
      verify(() => mockLocalDataSource.clearExplorerCache()).called(1);
    });

    test('delegates scoped clear when request is provided', () async {
      final request = ExplorerCacheClearRequest(
        startDate: DateTime(2026, 7, 2),
        endDate: DateTime(2026, 7, 2),
        providerIds: {'github'},
        orgTimezoneId: 'America/New_York',
      );
      when(
        () => mockLocalDataSource.clearExplorerCache(request: request),
      ).thenAnswer(
        (_) async => const ExplorerCacheClearResult(
          removedActivities: 1,
          removedCoverageRecords: 1,
        ),
      );

      final result = await repository.clearExplorerCache(request: request);

      expect(result.isRight(), isTrue);
      verify(
        () => mockLocalDataSource.clearExplorerCache(request: request),
      ).called(1);
    });
  });
}
