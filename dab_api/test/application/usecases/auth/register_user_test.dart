import 'package:dab_api/src/application/usecases/auth/register_user.dart';
import 'package:dab_api/src/domain/entities/user/user.dart';
import 'package:dab_api/src/domain/entities/user/user_identity.dart';
import 'package:dab_api/src/domain/entities/user/user_identity_status.dart';
import 'package:dab_api/src/domain/entities/user/user_role.dart';
import 'package:dab_api/src/domain/contracts/repositories/abs_i_auth_repository.dart';
import 'package:dab_api/src/domain/contracts/repositories/abs_i_user_repository.dart';
import 'package:dab_api/src/infrastructure/core/config/config.dart';
import 'package:dab_api/src/infrastructure/sources/phorge/phorge_user_source.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../test_factories.dart';

class MockAbsIAuthRepository extends Mock implements AbsIAuthRepository {}
class MockIUserRepository extends Mock implements IUserRepository {}
class MockPhorgeUserSource extends Mock implements PhorgeUserSource {}
class MockConfig extends Mock implements Config {}

void main() {
  late MockAbsIAuthRepository mockAuthRepo;
  late MockIUserRepository mockUserRepo;
  late MockPhorgeUserSource mockPhorgeSource;
  late MockConfig mockConfig;
  late RegisterUser useCase;

  setUp(() {
    mockAuthRepo = MockAbsIAuthRepository();
    mockUserRepo = MockIUserRepository();
    mockPhorgeSource = MockPhorgeUserSource();
    mockConfig = MockConfig();
    when(() => mockConfig.initialAdminEmail).thenReturn('');

    useCase = RegisterUser(
      mockAuthRepo,
      mockUserRepo,
      mockPhorgeSource,
      config: mockConfig,
    );

    registerFallbackValue(TestData.user());
    registerFallbackValue(UserIdentity(
      id: 'fallback_id',
      userId: 'fallback_user',
      providerId: 'fallback_provider',
      externalId: 'fallback_external',
      status: UserIdentityStatus.linked,
      createdAt: DateTime.now(),
    ));
  });

  group('RegisterUser Use Case (bootstrap-only)', () {
    const name = 'Admin User';
    const password = 'securepassword';

    test('should register the first user as admin with any email domain',
        () async {
      // Arrange
      when(() => mockAuthRepo.findAllUsers())
          .thenAnswer((_) async => const Right([]));
      when(() => mockAuthRepo.findByEmail(any()))
          .thenAnswer((_) async => const Right(null));
      when(() => mockPhorgeSource.lookupUserPhid(any(), any()))
          .thenAnswer((_) async => null);
      when(() => mockAuthRepo.createUser(any()))
          .thenAnswer((_) async => const Right(null));

      // Act
      final result = await useCase.execute(name, 'owner@anydomain.io', password);

      // Assert
      expect(result.isRight(), isTrue);
      final captured =
          verify(() => mockAuthRepo.createUser(captureAny())).captured;
      final createdUser = captured.single as User;
      expect(createdUser.role, UserRole.admin);
    });

    test('should reject self-registration once a user already exists',
        () async {
      // Arrange
      when(() => mockAuthRepo.findAllUsers())
          .thenAnswer((_) async => Right([TestData.user()]));

      // Act
      final result = await useCase.execute(name, 'new@user.com', password);

      // Assert
      expect(result.isLeft(), isTrue);
      final failure = result.fold(
        (l) => l,
        (r) => throw Exception('Registered unexpectedly'),
      );
      expect(failure.message, contains('Self-registration is disabled'));
      verifyNever(() => mockAuthRepo.createUser(any()));
    });

    test(
        'should enforce the bootstrap lock when an initial admin email is configured',
        () async {
      // Arrange
      when(() => mockConfig.initialAdminEmail).thenReturn('boss@corp.com');
      when(() => mockAuthRepo.findAllUsers())
          .thenAnswer((_) async => const Right([]));

      // Act
      final result = await useCase.execute(name, 'someone@else.com', password);

      // Assert
      expect(result.isLeft(), isTrue);
      final failure = result.fold(
        (l) => l,
        (r) => throw Exception('Registered unexpectedly'),
      );
      expect(failure.message, contains('Bootstrap Lock'));
      verifyNever(() => mockAuthRepo.createUser(any()));
    });

    test('should link a Phorge identity when a matching PHID is found',
        () async {
      // Arrange
      when(() => mockAuthRepo.findAllUsers())
          .thenAnswer((_) async => const Right([]));
      when(() => mockAuthRepo.findByEmail(any()))
          .thenAnswer((_) async => const Right(null));
      when(() => mockPhorgeSource.lookupUserPhid(any(), any()))
          .thenAnswer((_) async => 'PHID-USER-123');
      when(() => mockAuthRepo.createUser(any()))
          .thenAnswer((_) async => const Right(null));
      when(() => mockUserRepo.linkIdentity(any())).thenAnswer(
        (_) async => Right(UserIdentity(
          id: '1_phorge',
          userId: '1',
          providerId: 'phorge',
          externalId: 'PHID-USER-123',
          status: UserIdentityStatus.linked,
          createdAt: DateTime.now(),
        )),
      );

      // Act
      final result = await useCase.execute(name, 'owner@company.com', password);

      // Assert
      expect(result.isRight(), isTrue);
      verify(() => mockUserRepo.linkIdentity(any())).called(1);
    });
  });
}
