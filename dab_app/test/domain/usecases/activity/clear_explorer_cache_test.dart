import 'package:dab_app/domain/entities/activity/explorer_cache_clear_request.dart';
import 'package:dab_app/domain/repositories/abs_i_activity_repository.dart';
import 'package:dab_app/domain/usecases/activity/clear_explorer_cache.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockActivityRepository extends Mock implements IActivityRepository {}

void main() {
  late MockActivityRepository repository;
  late ClearExplorerCache useCase;

  setUp(() {
    repository = MockActivityRepository();
    useCase = ClearExplorerCache(repository);
  });

  test('clears entire cache when request is omitted', () async {
    when(() => repository.clearExplorerCache()).thenAnswer(
      (_) async => right(
        const ExplorerCacheClearResult(
          removedActivities: 3,
          removedCoverageRecords: 2,
        ),
      ),
    );

    final result = await useCase.execute();

    expect(result.isRight(), isTrue);
    verify(() => repository.clearExplorerCache()).called(1);
    verifyNever(
      () => repository.clearExplorerCache(request: any(named: 'request')),
    );
  });

  test('rejects empty provider selection', () async {
    final result = await useCase.execute(
      request: ExplorerCacheClearRequest(
        startDate: DateTime(2026, 7, 1),
        endDate: DateTime(2026, 7, 2),
        providerIds: {},
        orgTimezoneId: 'UTC',
      ),
    );

    expect(result.isLeft(), isTrue);
    verifyNever(() => repository.clearExplorerCache());
    verifyNever(
      () => repository.clearExplorerCache(request: any(named: 'request')),
    );
  });

  test('rejects inverted date range', () async {
    final result = await useCase.execute(
      request: ExplorerCacheClearRequest(
        startDate: DateTime(2026, 7, 3),
        endDate: DateTime(2026, 7, 1),
        providerIds: {'github'},
        orgTimezoneId: 'UTC',
      ),
    );

    expect(result.isLeft(), isTrue);
    verifyNever(
      () => repository.clearExplorerCache(request: any(named: 'request')),
    );
  });

  test('delegates scoped clear to repository', () async {
    when(
      () => repository.clearExplorerCache(request: any(named: 'request')),
    ).thenAnswer(
      (_) async => right(
        const ExplorerCacheClearResult(
          removedActivities: 1,
          removedCoverageRecords: 1,
        ),
      ),
    );

    final result = await useCase.execute(
      request: ExplorerCacheClearRequest(
        startDate: DateTime(2026, 7, 2),
        endDate: DateTime(2026, 7, 2),
        providerIds: {'GitHub'},
        orgTimezoneId: 'America/New_York',
      ),
    );

    expect(result.isRight(), isTrue);
    final captured = verify(
      () => repository.clearExplorerCache(request: captureAny(named: 'request')),
    ).captured.single as ExplorerCacheClearRequest;
    expect(captured.providerIds, {'github'});
    expect(captured.orgTimezoneId, 'America/New_York');
  });
}
