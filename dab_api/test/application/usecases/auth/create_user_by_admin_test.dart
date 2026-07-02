import 'package:dab_api/src/application/usecases/auth/create_user_by_admin.dart';
import 'package:dab_api/src/domain/entities/user/user.dart';
import 'package:dab_api/src/domain/entities/user/user_identity.dart';
import 'package:dab_api/src/domain/entities/user/user_identity_status.dart';
import 'package:dab_api/src/domain/entities/user/user_role.dart';
import 'package:dab_api/src/domain/repositories/abs_i_auth_repository.dart';
import 'package:dab_api/src/domain/repositories/abs_i_system_settings_repository.dart';
import 'package:dab_api/src/domain/repositories/abs_i_user_repository.dart';
import 'package:dab_api/src/infrastructure/sources/phorge/phorge_user_source.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../test_factories.dart';

class MockAbsIAuthRepository extends Mock implements AbsIAuthRepository {}
class MockIUserRepository extends Mock implements IUserRepository {}
class MockPhorgeUserSource extends Mock implements PhorgeUserSource {}
class MockISystemSettingsRepository extends Mock
    implements ISystemSettingsRepository {}

void main() {
  late MockAbsIAuthRepository mockAuthRepo;
  late MockIUserRepository mockUserRepo;
  late MockPhorgeUserSource mockPhorgeSource;
  late MockISystemSettingsRepository mockSettingsRepo;
  late CreateUserByAdmin useCase;

  setUp(() {
    mockAuthRepo = MockAbsIAuthRepository();
    mockUserRepo = MockIUserRepository();
    mockPhorgeSource = MockPhorgeUserSource();
    mockSettingsRepo = MockISystemSettingsRepository();

    useCase = CreateUserByAdmin(
      mockAuthRepo,
      mockUserRepo,
      mockPhorgeSource,
      mockSettingsRepo,
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

  void stubHappyPath() {
    when(() => mockAuthRepo.findByEmail(any()))
        .thenAnswer((_) async => const Right(null));
    when(() => mockPhorgeSource.lookupUserPhid(any(), any()))
        .thenAnswer((_) async => null);
    when(() => mockAuthRepo.createUser(any()))
        .thenAnswer((_) async => const Right(null));
  }

  group('CreateUserByAdmin Use Case', () {
    const name = 'New User';
    const password = 'securepassword';

    test('should create a user with any email when domain validation is off',
        () async {
      // Arrange
      when(() => mockSettingsRepo.isDomainValidationEnabled())
          .thenAnswer((_) async => const Right(false));
      stubHappyPath();

      // Act
      final result =
          await useCase.execute(name, 'new.user@other.com', password);

      // Assert
      expect(result.isRight(), isTrue);
      verify(() => mockAuthRepo.createUser(any())).called(1);
      verifyNever(() => mockSettingsRepo.getAllowedDomain());
    });

    test('should create a user matching the domain when validation is on',
        () async {
      // Arrange
      when(() => mockSettingsRepo.isDomainValidationEnabled())
          .thenAnswer((_) async => const Right(true));
      when(() => mockSettingsRepo.getAllowedDomain())
          .thenAnswer((_) async => const Right('company.com'));
      stubHappyPath();

      // Act
      final result =
          await useCase.execute(name, 'new.user@company.com', password);

      // Assert
      expect(result.isRight(), isTrue);
      verify(() => mockAuthRepo.createUser(any())).called(1);
    });

    test('should reject a user outside the domain when validation is on',
        () async {
      // Arrange
      when(() => mockSettingsRepo.isDomainValidationEnabled())
          .thenAnswer((_) async => const Right(true));
      when(() => mockSettingsRepo.getAllowedDomain())
          .thenAnswer((_) async => const Right('company.com'));

      // Act
      final result =
          await useCase.execute(name, 'new.user@other.com', password);

      // Assert
      expect(result.isLeft(), isTrue);
      final failure = result.fold(
        (l) => l,
        (r) => throw Exception('Created unexpectedly'),
      );
      expect(failure.message, contains('restricted to company.com'));
      verifyNever(() => mockAuthRepo.createUser(any()));
    });

    test('should reject when the email is already registered', () async {
      // Arrange
      when(() => mockSettingsRepo.isDomainValidationEnabled())
          .thenAnswer((_) async => const Right(false));
      when(() => mockAuthRepo.findByEmail(any()))
          .thenAnswer((_) async => Right(TestData.user()));

      // Act
      final result =
          await useCase.execute(name, 'existing@other.com', password);

      // Assert
      expect(result.isLeft(), isTrue);
      final failure = result.fold(
        (l) => l,
        (r) => throw Exception('Created unexpectedly'),
      );
      expect(failure.message, contains('User already exists'));
      verifyNever(() => mockAuthRepo.createUser(any()));
    });

    test('should assign the requested role', () async {
      // Arrange
      when(() => mockSettingsRepo.isDomainValidationEnabled())
          .thenAnswer((_) async => const Right(false));
      stubHappyPath();

      // Act
      final result = await useCase.execute(
        name,
        'new.user@other.com',
        password,
        role: UserRole.manager,
      );

      // Assert
      expect(result.isRight(), isTrue);
      final captured =
          verify(() => mockAuthRepo.createUser(captureAny())).captured;
      final createdUser = captured.single as User;
      expect(createdUser.role, UserRole.manager);
    });

    test('should link a Phorge identity when a matching PHID is found',
        () async {
      // Arrange
      when(() => mockSettingsRepo.isDomainValidationEnabled())
          .thenAnswer((_) async => const Right(false));
      when(() => mockAuthRepo.findByEmail(any()))
          .thenAnswer((_) async => const Right(null));
      when(() => mockPhorgeSource.lookupUserPhid(any(), any()))
          .thenAnswer((_) async => 'PHID-USER-456');
      when(() => mockAuthRepo.createUser(any()))
          .thenAnswer((_) async => const Right(null));
      when(() => mockUserRepo.linkIdentity(any())).thenAnswer(
        (_) async => Right(UserIdentity(
          id: '1_phorge',
          userId: '1',
          providerId: 'phorge',
          externalId: 'PHID-USER-456',
          status: UserIdentityStatus.linked,
          createdAt: DateTime.now(),
        )),
      );

      // Act
      final result =
          await useCase.execute(name, 'new.user@other.com', password);

      // Assert
      expect(result.isRight(), isTrue);
      verify(() => mockUserRepo.linkIdentity(any())).called(1);
    });
  });
}
