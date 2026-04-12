import 'package:dab_app/domain/entities/activity/activity.dart';
import 'package:dab_app/infrastructure/datasources/activity_remote_data_source.dart';
import 'package:dab_app/infrastructure/repositories/activity_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockActivityRemoteDataSource extends Mock
    implements ActivityRemoteDataSource {}

void main() {
  late ActivityRepository repository;
  late MockActivityRemoteDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockActivityRemoteDataSource();
    repository = ActivityRepository(mockDataSource);
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
        () => mockDataSource.searchActivities(
          startDate: null,
          endDate: null,
          users: null,
          authoredOnly: true,
        ),
      ).thenAnswer((_) async => response);

      final result = await repository.searchActivities();

      result.fold(
        (failure) => fail('Expected success but got failure: $failure'),
        (activities) {
          expect(activities.map((a) => a.id).toList(), ['newer', 'older']);

          final olderProvider = activities.last.provider as SlackMessageProvider;
          expect(olderProvider.workspaceId, 'W123');
          expect(olderProvider.channelId, 'C123');
          expect(olderProvider.threadTs, isNull);
          expect(olderProvider.messageTs, '1730000001.0001');
        },
      );

      verify(
        () => mockDataSource.searchActivities(
          startDate: null,
          endDate: null,
          users: null,
          authoredOnly: true,
        ),
      ).called(1);
    });
  });
}
