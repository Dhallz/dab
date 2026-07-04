import 'package:dab_api/src/application/usecases/auth/delete_user_identity.dart';
import 'package:dab_api/src/domain/core/failures/failure.dart';
import 'package:dab_api/src/domain/repositories/abs_i_user_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class _MockUserRepository extends Mock implements IUserRepository {}

void main() {
  late _MockUserRepository userRepository;
  late DeleteUserIdentity useCase;

  setUp(() {
    userRepository = _MockUserRepository();
    useCase = DeleteUserIdentity(userRepository);
  });

  test('deletes identity by id', () async {
    when(() => userRepository.deleteIdentity('user-1_jira'))
        .thenAnswer((_) async => const Right(null));

    final result = await useCase.execute(identityId: 'user-1_jira');

    expect(result.isRight(), isTrue);
    verify(() => userRepository.deleteIdentity('user-1_jira')).called(1);
  });

  test('returns failure when identity is missing', () async {
    when(() => userRepository.deleteIdentity('missing'))
        .thenAnswer((_) async => Left(NotFoundFailure('Identity not found')));

    final result = await useCase.execute(identityId: 'missing');

    expect(result.isLeft(), isTrue);
    expect(
      result.getLeft().toNullable(),
      isA<NotFoundFailure>(),
    );
  });
}
