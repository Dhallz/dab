import 'package:dab_api/src/application/usecases/activity/fetch_remote_activities.dart';
import 'package:dab_api/src/application/usecases/activity/search_activities.dart';
import 'package:dab_api/src/domain/core/failures/failure.dart';
import 'package:dab_api/src/domain/contracts/repositories/abs_i_auth_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../test_factories.dart';

class _MockAuthRepository extends Mock implements AbsIAuthRepository {}

class _MockFetchRemoteActivities extends Mock
    implements FetchRemoteActivities {}

void main() {
  late _MockAuthRepository authRepo;
  late _MockFetchRemoteActivities fetchRemote;
  late SearchActivities useCase;

  setUp(() {
    authRepo = _MockAuthRepository();
    fetchRemote = _MockFetchRemoteActivities();
    useCase = SearchActivities(authRepo, fetchRemote);
    registerFallbackValue(TestData.user(id: 'fallback'));
  });

  test(
    'returns empty without calling FetchRemoteActivities when no users resolve',
    () async {
      when(
        () => authRepo.findById(any()),
      ).thenAnswer((_) async => const Right(null));

      final result = await useCase.execute(
        targetUserIds: const ['gone'],
        startDate: DateTime.utc(2026, 1, 1),
        endDate: DateTime.utc(2026, 1, 2),
        authoredOnly: false,
      );

      expect(result, isEmpty);
      verifyNever(
        () => fetchRemote.execute(
          targetUsers: any(named: 'targetUsers'),
          startDate: any(named: 'startDate'),
          endDate: any(named: 'endDate'),
          authoredOnly: any(named: 'authoredOnly'),
        ),
      );
    },
  );

  test('delegates to FetchRemoteActivities with resolved users', () async {
    final user = TestData.user(id: 'u-1');
    final activity = TestData.activity(userId: 'u-1');
    final start = DateTime.utc(2026, 1, 4);
    final end = DateTime.utc(2026, 1, 10);

    when(() => authRepo.findById('u-1')).thenAnswer((_) async => Right(user));
    when(
      () => fetchRemote.execute(
        targetUsers: [user],
        startDate: start,
        endDate: end,
        authoredOnly: true,
      ),
    ).thenAnswer((_) async => Right([activity]));

    final result = await useCase.execute(
      targetUserIds: const ['u-1'],
      startDate: start,
      endDate: end,
      authoredOnly: true,
    );

    expect(result, equals([activity]));
    verify(
      () => fetchRemote.execute(
        targetUsers: [user],
        startDate: start,
        endDate: end,
        authoredOnly: true,
      ),
    ).called(1);
  });

  test('returns empty when FetchRemoteActivities fails', () async {
    final user = TestData.user(id: 'u-2');
    when(() => authRepo.findById('u-2')).thenAnswer((_) async => Right(user));
    when(
      () => fetchRemote.execute(
        targetUsers: any(named: 'targetUsers'),
        startDate: any(named: 'startDate'),
        endDate: any(named: 'endDate'),
        authoredOnly: any(named: 'authoredOnly'),
      ),
    ).thenAnswer((_) async => Left(DatabaseFailure('upstream')));

    final result = await useCase.execute(
      targetUserIds: const ['u-2'],
      startDate: DateTime.utc(2026),
      endDate: DateTime.utc(2026),
      authoredOnly: false,
    );

    expect(result, isEmpty);
  });
}
