import 'package:bcrypt/bcrypt.dart';
import 'package:dab_api/src/application/auth_service.dart';
import 'package:dab_api/src/domain/entities/session.dart' as domain;
import 'package:dab_api/src/domain/entities/user.dart' as domain;
import 'package:dab_api/src/domain/repositories/abs_i_auth_repository.dart';
import 'package:dab_api/src/infrastructure/connectors/phorge/phorge_connector.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../test_utils.dart';

class MockAuthRepo extends Mock implements AbsIAuthRepository {}

class MockPhorgeConnector extends Mock implements PhorgeConnector {}

class FakeSession extends Fake implements domain.Session {}

void main() {
  late AuthService service;
  late MockAuthRepo mockRepo;
  late MockPhorgeConnector mockPhorgeConnector;

  setUpAll(() {
    registerFallbackValue(FakeSession());
    registerFallbackValue(TestData.user());
  });

  setUp(() {
    mockRepo = MockAuthRepo();
    mockPhorgeConnector = MockPhorgeConnector();
    service = AuthService(mockRepo, mockPhorgeConnector);
  });

  group('AuthService - register', () {
    test('rejects registration from outside allowed domain', () async {
      final result = await service.register(
        'Hacker',
        'hacker@gmail.com',
        'pwd',
      );

      expect(result.isLeft(), isTrue);
      result.match(
        (f) => expect(f.message, contains('restricted to necs.com')),
        (_) => fail('Should not succeed'),
      );
      verifyNever(() => mockRepo.createUser(any()));
    });

    test('rejects if user already exists', () async {
      final existingUser = TestData.user(name: 'Bob', email: 'bob@necs.com');
      when(
        () => mockRepo.findByEmail('bob@necs.com'),
      ).thenAnswer((_) async => right(existingUser));

      final result = await service.register('Bob', 'bob@necs.com', 'pwd');

      expect(result.isLeft(), isTrue);
      result.match(
        (f) => expect(f.message, equals('User already exists')),
        (_) => fail('Should not succeed'),
      );
      verifyNever(() => mockRepo.createUser(any()));
    });

    test('successfully links Phorge PHID if found', () async {
      when(
        () => mockRepo.findByEmail('charlie@necs.com'),
      ).thenAnswer((_) async => right(null));
      when(
        () => mockPhorgeConnector.lookupUserPhid('Charlie', 'charlie@necs.com'),
      ).thenAnswer((_) async => 'PHID-USER-charlie');
      when(
        () => mockRepo.createUser(any()),
      ).thenAnswer((_) async => right(null));
      when(
        () => mockRepo.createSession(any()),
      ).thenAnswer((_) async => right(null));

      final result = await service.register(
        'Charlie',
        'charlie@necs.com',
        'pwd',
      );

      expect(result.isRight(), isTrue);

      final captured = verify(() => mockRepo.createUser(captureAny())).captured;
      final savedUser = captured.first as domain.User;

      expect(savedUser.phorgePhid, equals('PHID-USER-charlie'));
    });
  });

  group('AuthService - login', () {
    test('returns tokens if credentials are correct', () async {
      final hash = BCrypt.hashpw('correct_horse', BCrypt.gensalt());
      final existingUser = TestData.user(
        id: '1',
        name: 'Alice',
        email: 'alice@necs.com',
      ).copyWith(passwordHash: hash);

      when(
        () => mockRepo.findByEmail('alice@necs.com'),
      ).thenAnswer((_) async => right(existingUser));
      when(
        () => mockRepo.createSession(any()),
      ).thenAnswer((_) async => right(null));

      final result = await service.login('alice@necs.com', 'correct_horse');

      expect(result.isRight(), isTrue);
      result.match((_) => fail('Should not fail'), (tokens) {
        expect(tokens.containsKey('accessToken'), isTrue);
        expect(tokens.containsKey('refreshToken'), isTrue);
        expect(tokens['userId'], equals('1'));
      });
    });

    test('fails if password is incorrect', () async {
      final hash = BCrypt.hashpw('correct', BCrypt.gensalt());
      final existingUser = TestData.user(
        id: '1',
        name: 'Alice',
        email: 'alice@necs.com',
      ).copyWith(passwordHash: hash);

      when(
        () => mockRepo.findByEmail('alice@necs.com'),
      ).thenAnswer((_) async => right(existingUser));

      final result = await service.login('alice@necs.com', 'wrong');

      expect(result.isLeft(), isTrue);
      result.match(
        (f) => expect(f.message, equals('Invalid credentials')),
        (_) => fail('Should not succeed'),
      );
    });
  });
}
