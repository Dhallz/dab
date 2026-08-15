import 'package:dab_api/src/application/usecases/user/sync_phorge_users.dart';
import 'package:dab_api/src/domain/dtos/phorge/phorge_user/phorge_user_dto.dart';
import 'package:dab_api/src/domain/dtos/phorge/phorge_user/phorge_user_wire_fields_dto.dart';
import 'package:dab_api/src/domain/entities/provider/provider_config.dart';
import 'package:dab_api/src/domain/entities/user/user.dart';
import 'package:dab_api/src/domain/gateways/abs_i_phorge_gateway.dart';
import 'package:dab_api/src/domain/repositories/abs_i_provider_config_repository.dart';
import 'package:dab_api/src/domain/repositories/abs_i_user_repository.dart';
import 'package:fpdart/fpdart.dart' hide Group;
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockUserRepository extends Mock implements IUserRepository {}

class MockAbsIPhorgeGateway extends Mock implements AbsIPhorgeGateway {}

class MockProviderConfigRepository extends Mock
    implements AbsIProviderConfigRepository {}

void main() {
  late SyncPhorgeUsers syncUseCase;
  late MockUserRepository mockRepo;
  late MockAbsIPhorgeGateway mockGateway;
  late MockProviderConfigRepository mockConfigRepo;

  setUp(() {
    mockRepo = MockUserRepository();
    mockGateway = MockAbsIPhorgeGateway();
    mockConfigRepo = MockProviderConfigRepository();
    syncUseCase = SyncPhorgeUsers(
      mockRepo,
      mockGateway,
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
        const PhorgeUserDto(
          phid: 'PHID-USER-1',
          fields: PhorgeUserWireFieldsDto(
            username: 'user1',
            realName: 'User One',
          ),
        ),
        const PhorgeUserDto(
          phid: 'PHID-USER-2',
          fields: PhorgeUserWireFieldsDto(
            username: 'user2',
            realName: 'User Two',
          ),
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

      when(() => mockGateway.fetchDirectoryUsers()).thenAnswer(
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
