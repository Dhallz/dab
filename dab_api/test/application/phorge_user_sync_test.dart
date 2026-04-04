import 'package:dab_api/src/application/user_service.dart';
import 'package:dab_api/src/domain/entities/user.dart';
import 'package:dab_api/src/domain/repositories/abs_i_user_repository.dart';
import 'package:dab_api/src/infrastructure/connectors/phorge/dtos/phorge_user_dto.dart';
import 'package:dab_api/src/infrastructure/connectors/phorge/phorge_connector.dart';
import 'package:fpdart/fpdart.dart' hide Group;
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockUserRepository extends Mock implements IUserRepository {}
class MockPhorgeConnector extends Mock implements PhorgeConnector {}

void main() {
  late UserService userService;
  late MockUserRepository mockRepo;
  late MockPhorgeConnector mockConnector;

  setUp(() {
    mockRepo = MockUserRepository();
    mockConnector = MockPhorgeConnector();
    userService = UserService(mockRepo, mockConnector);
    registerFallbackValue(User(id: '', name: '', email: '', createdAt: DateTime.now()));
  });

  group('UserService.syncPhorgeUsers', () {
    test('should create missing users and skip existing ones', () async {
      // Arrange
      final pUsers = [
        PhorgeUserDto(phid: 'PHID-USER-1', userName: 'user1', realName: 'User One'),
        PhorgeUserDto(phid: 'PHID-USER-2', userName: 'user2', realName: 'User Two'),
      ];

      when(() => mockConnector.fetchAllUsers()).thenAnswer((_) async => pUsers);
      
      // First user exists
      when(() => mockRepo.findByEmail('user1@necs.com'))
          .thenAnswer((_) async => Right(User(
                id: '1',
                name: 'User One',
                email: 'user1@necs.com',
                createdAt: DateTime.now(),
              )));
              
      // Second user is missing
      when(() => mockRepo.findByEmail('user2@necs.com'))
          .thenAnswer((_) async => const Right(null));

      when(() => mockRepo.saveUser(any())).thenAnswer((_) async => const Right(null));

      // Act
      final createdCount = await userService.syncPhorgeUsers();

      // Assert
      expect(createdCount, 1);
      verify(() => mockRepo.findByEmail('user1@necs.com')).called(1);
      verify(() => mockRepo.findByEmail('user2@necs.com')).called(1);
      verify(() => mockRepo.saveUser(any())).called(1);
    });
  });
}
