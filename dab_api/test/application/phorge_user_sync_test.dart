import 'package:dab_api/src/application/usecases/user/sync_phorge_users.dart';
import 'package:dab_api/src/domain/entities/phorge/phorge_directory_user.dart';
import 'package:dab_api/src/domain/entities/provider/provider_config.dart';
import 'package:dab_api/src/domain/entities/user/user.dart';
import 'package:dab_api/src/domain/ports/phorge_user_directory_port.dart';
import 'package:dab_api/src/domain/repositories/abs_i_provider_config_repository.dart';
import 'package:dab_api/src/domain/repositories/abs_i_user_repository.dart';
import 'package:fpdart/fpdart.dart' hide Group;
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockUserRepository extends Mock implements IUserRepository {}

class MockPhorgeDirectory extends Mock implements PhorgeUserDirectoryPort {}

class MockProviderConfigRepository extends Mock
    implements AbsIProviderConfigRepository {}

void main() {
  late SyncPhorgeUsers syncUseCase;
  late MockUserRepository mockRepo;
  late MockPhorgeDirectory mockDirectory;
  late MockProviderConfigRepository mockConfigRepo;

  setUp(() {
    mockRepo = MockUserRepository();
    mockDirectory = MockPhorgeDirectory();
    mockConfigRepo = MockProviderConfigRepository();
    syncUseCase = SyncPhorgeUsers(
      mockRepo,
      mockDirectory,
      mockConfigRepo,
      allowedDomain: 'necs.com',
    );
    registerFallbackValue(
      User(id: '', name: '', email: '', createdAt: DateTime.now()),
    );
  });

  group('SyncPhorgeUsers', () {
    test('should create missing users and skip existing ones', () async {
      final pUsers = [
        const PhorgeDirectoryUser(
          phid: 'PHID-USER-1',
          userName: 'user1',
          realName: 'User One',
        ),
        const PhorgeDirectoryUser(
          phid: 'PHID-USER-2',
          userName: 'user2',
          realName: 'User Two',
        ),
      ];

      when(() => mockConfigRepo.getConfigs()).thenAnswer(
        (_) async => Right([
          const ProviderConfig(
            id: 'phorge',
            name: 'Phorge',
            baseUrl: 'https://phorge.example.com',
            isActive: true,
          ),
        ]),
      );

      when(() => mockDirectory.fetchDirectoryUsers()).thenAnswer(
        (_) async => Right(pUsers),
      );

      when(() => mockRepo.getUsers()).thenAnswer(
        (_) async => Right([
          User(
            id: '1',
            name: 'User One',
            email: 'user1@necs.com',
            createdAt: DateTime.now(),
          ),
        ]),
      );

      when(
        () => mockRepo.saveUser(any()),
      ).thenAnswer((_) async => const Right(null));

      final result = await syncUseCase.execute();
      final createdCount = result.getOrElse((l) => -1);

      expect(createdCount, 1);
      verify(() => mockRepo.getUsers()).called(1);
      verify(() => mockRepo.saveUser(any())).called(1);
    });
  });
}
