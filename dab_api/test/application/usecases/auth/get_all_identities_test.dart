import 'package:dab_api/src/application/usecases/auth/get_all_identities.dart';
import 'package:dab_api/src/domain/entities/user/user.dart';
import 'package:dab_api/src/domain/entities/user/user_identity.dart';
import 'package:dab_api/src/domain/entities/user/user_identity_status.dart';
import 'package:dab_api/src/domain/entities/user/user_role.dart';
import 'package:dab_api/src/domain/repositories/abs_i_auth_repository.dart';
import 'package:dab_api/src/domain/repositories/abs_i_user_repository.dart';
import 'package:test/test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class _MockUserRepo extends Mock implements IUserRepository {}

class _MockAuthRepo extends Mock implements AbsIAuthRepository {}

void main() {
  late _MockUserRepo userRepo;
  late _MockAuthRepo authRepo;
  late GetAllIdentities useCase;

  setUp(() {
    userRepo = _MockUserRepo();
    authRepo = _MockAuthRepo();
    useCase = GetAllIdentities(userRepo, authRepo);
  });

  test('merges Phorge PHID from User when no user_identities row', () async {
    when(() => userRepo.getAllIdentities()).thenAnswer(
      (_) async => const Right([]),
    );
    final u = User(
      id: 'u1',
      name: 'A',
      email: 'a@b.com',
      passwordHash: 'x',
      role: UserRole.standard,
      phorgePhid: 'PHID-USER-abc',
      createdAt: DateTime.utc(2024),
    );
    when(() => authRepo.findAllUsers()).thenAnswer((_) async => Right([u]));

    final result = await useCase.execute();

    expect(result.isRight(), isTrue);
    final list = result.getOrElse((_) => []);
    expect(list.length, 1);
    expect(list.single.providerId, 'phorge');
    expect(list.single.externalId, 'PHID-USER-abc');
    expect(list.single.status, UserIdentityStatus.linked);
  });

  test('does not duplicate when identity row exists for phorge', () async {
    when(() => userRepo.getAllIdentities()).thenAnswer(
      (_) async => Right([
        UserIdentity(
          id: 'u1_phorge',
          userId: 'u1',
          providerId: 'phorge',
          externalId: 'PHID-USER-abc',
          status: UserIdentityStatus.linked,
          createdAt: DateTime.utc(2024),
        ),
      ]),
    );
    final u = User(
      id: 'u1',
      name: 'A',
      email: 'a@b.com',
      passwordHash: 'x',
      role: UserRole.standard,
      phorgePhid: 'PHID-USER-abc',
      createdAt: DateTime.utc(2024),
    );
    when(() => authRepo.findAllUsers()).thenAnswer((_) async => Right([u]));

    final result = await useCase.execute();
    expect(result.getOrElse((_) => []).length, 1);
  });
}
