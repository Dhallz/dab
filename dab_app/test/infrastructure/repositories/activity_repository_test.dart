import 'package:dab_app/domain/entities/activity/activity.dart';
import 'package:dab_app/domain/entities/activity/activity_search_query.dart';
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
      ),
    ).thenAnswer((_) async => const {});
    when(
      () => mockLocalDataSource.markCoverage(any()),
    ).thenAnswer((_) async {});
    when(
      () => mockLocalDataSource.upsertActivities(any()),
    ).thenAnswer((_) async {});
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
        verify(() => mockLocalDataSource.upsertActivities(any())).called(1);
        verify(() => mockLocalDataSource.markCoverage(any())).called(1);
      },
    );
  });
}
