import 'package:bcrypt/bcrypt.dart';
import 'package:dab_api/src/application/auth_service.dart';
import 'package:dab_api/src/domain/entities/session.dart' as domain;
import 'package:dab_api/src/domain/entities/user.dart';
import 'package:dab_api/src/domain/repositories/abs_i_auth_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockAuthRepo extends Mock implements AbsIAuthRepository {}

class FakeSession extends Fake implements domain.Session {}

void main() {
  late AuthService service;
  late MockAuthRepo mockRepo;

  setUpAll(() {
    registerFallbackValue(FakeSession());
    registerFallbackValue(
      User(
        id: '123',
        name: 'test',
        email: 'test@acme.com',
        passwordHash: 'hash',
        role: 'Standard',
        createdAt: DateTime.now(),
      ),
    );
  });

  setUp(() {
    mockRepo = MockAuthRepo();
    service = AuthService(mockRepo);
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
        (f) => expect(f.message, contains('restricted to acme.com')),
        (_) => fail('Should not succeed'),
      );
      verifyNever(() => mockRepo.createUser(any()));
    });

    test('rejects if user already exists', () async {
      final existingUser = User(
        id: '1',
        name: 'Bob',
        email: 'bob@acme.com',
        passwordHash: 'hash',
        role: 'Standard',
        createdAt: DateTime.now(),
      );
      when(
        () => mockRepo.findByEmail('bob@acme.com'),
      ).thenAnswer((_) async => right(existingUser));

      final result = await service.register('Bob', 'bob@acme.com', 'pwd');

      expect(result.isLeft(), isTrue);
      result.match(
        (f) => expect(f.message, equals('User already exists')),
        (_) => fail('Should not succeed'),
      );
      verifyNever(() => mockRepo.createUser(any()));
    });
  });

  group('AuthService - login', () {
    test('returns tokens if credentials are correct', () async {
      final hash = BCrypt.hashpw('correct_horse', BCrypt.gensalt());
      final existingUser = User(
        id: '1',
        name: 'Alice',
        email: 'alice@acme.com',
        passwordHash: hash,
        role: 'Standard',
        createdAt: DateTime.now(),
      );

      when(
        () => mockRepo.findByEmail('alice@acme.com'),
      ).thenAnswer((_) async => right(existingUser));
      when(
        () => mockRepo.createSession(any()),
      ).thenAnswer((_) async => right(null));

      final result = await service.login('alice@acme.com', 'correct_horse');

      expect(result.isRight(), isTrue);
      result.match((_) => fail('Should not fail'), (tokens) {
        expect(tokens.containsKey('accessToken'), isTrue);
        expect(tokens.containsKey('refreshToken'), isTrue);
        expect(tokens['userId'], equals('1'));
      });
    });

    test('fails if password is incorrect', () async {
      final hash = BCrypt.hashpw('correct', BCrypt.gensalt());
      final existingUser = User(
        id: '1',
        name: 'Alice',
        email: 'alice@acme.com',
        passwordHash: hash,
        role: 'Standard',
        createdAt: DateTime.now(),
      );

      when(
        () => mockRepo.findByEmail('alice@acme.com'),
      ).thenAnswer((_) async => right(existingUser));

      final result = await service.login('alice@acme.com', 'wrong');

      expect(result.isLeft(), isTrue);
      result.match(
        (f) => expect(f.message, equals('Invalid credentials')),
        (_) => fail('Should not succeed'),
      );
    });
  });
}
