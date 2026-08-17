import 'package:dab_api/src/application/usecases/user/delete_activity_follow.dart';
import 'package:dab_api/src/application/usecases/user/save_activity_follow.dart';
import 'package:dab_api/src/domain/core/failures/failure.dart';
import 'package:dab_api/src/domain/entities/user/activity_follow.dart';
import 'package:dab_api/src/domain/contracts/repositories/abs_i_activity_follow_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class _MockFollows extends Mock implements AbsIActivityFollowRepository {}

void main() {
  late _MockFollows follows;
  late SaveActivityFollow save;
  late DeleteActivityFollow delete;

  setUpAll(() {
    registerFallbackValue(
      ActivityFollow(
        id: 'id',
        userId: 'u-1',
        providerId: 'phorge',
        objectKey: 'PHID-TASK-1',
        createdAt: DateTime.utc(2026, 1, 1),
      ),
    );
  });

  setUp(() {
    follows = _MockFollows();
    save = SaveActivityFollow(follows);
    delete = DeleteActivityFollow(follows);
  });

  test('saves a followable pin and rejects git', () async {
    when(() => follows.upsert(any())).thenAnswer((invocation) async {
      return Right(invocation.positionalArguments.first as ActivityFollow);
    });

    final ok = await save.execute(
      userId: 'u-1',
      providerId: 'Phorge',
      objectKey: ' PHID-TASK-1 ',
      title: ' [T123] Fix login ',
    );
    final follow = ok.getOrElse((_) => throw StateError('left'));
    expect(follow.userId, 'u-1');
    expect(follow.providerId, 'phorge');
    expect(follow.objectKey, 'PHID-TASK-1');
    expect(follow.title, '[T123] Fix login');

    final rejected = await save.execute(
      userId: 'u-1',
      providerId: 'github',
      objectKey: 'acme/app',
    );
    expect(rejected.getLeft().toNullable(), isA<ValidationFailure>());
  });

  test('deletes a followable pin and rejects empty keys', () async {
    when(
      () => follows.delete(
        userId: any(named: 'userId'),
        providerId: any(named: 'providerId'),
        objectKey: any(named: 'objectKey'),
      ),
    ).thenAnswer((_) async => const Right(null));

    final ok = await delete.execute(
      userId: 'u-1',
      providerId: 'jira',
      objectKey: 'DAB-7',
    );
    expect(ok.isRight(), isTrue);
    verify(
      () => follows.delete(
        userId: 'u-1',
        providerId: 'jira',
        objectKey: 'DAB-7',
      ),
    ).called(1);

    final rejected = await delete.execute(
      userId: 'u-1',
      providerId: 'jira',
      objectKey: '  ',
    );
    expect(rejected.getLeft().toNullable(), isA<ValidationFailure>());
  });
}
