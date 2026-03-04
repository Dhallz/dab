import 'dart:convert';

import 'package:dab_api/src/application/auth_service.dart';
import 'package:dab_api/src/domain/core/failure.dart';
import 'package:dab_api/src/presentation/controllers/auth_controller.dart';
import 'package:dab_api/src/service_locator.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:relic/relic.dart';
import 'package:test/test.dart';

import '../../test_utils.dart';

class MockAuthService extends Mock implements AuthService {}

void main() {
  group('AuthController', () {
    late AuthController controller;
    late MockAuthService mockAuthService;

    setUp(() {
      mockAuthService = MockAuthService();
      sl.reset();
      sl.registerSingleton<AuthService>(mockAuthService);
      controller = AuthController();
    });

    group('register', () {
      test(
        'should return 200 with tokens on successful registration',
        () async {
          final request = TestRequest.create(
            method: Method.post,
            url: Uri.parse('http://localhost/register'),
            body: Body.fromString(
              jsonEncode({
                'name': 'Test User',
                'email': 'test@example.com',
                'password': 'password123',
              }),
            ),
          );

          final tokens = {'accessToken': 'access', 'refreshToken': 'refresh'};
          when(
            () => mockAuthService.register(any(), any(), any()),
          ).thenAnswer((_) async => right(tokens));

          final response = await controller.register(request);

          expect(response.statusCode, equals(200));
          final body = jsonDecode(await response.readAsString());
          expect(body['accessToken'], equals('access'));
        },
      );

      test('should return 400 when name/email/password are missing', () async {
        final request = TestRequest.create(
          method: Method.post,
          url: Uri.parse('http://localhost/register'),
          body: Body.fromString(jsonEncode({'name': 'Test'})),
        );

        final response = await controller.register(request);

        expect(response.statusCode, equals(400));
        final body = jsonDecode(await response.readAsString());
        expect(body['error'], contains('required'));
      });

      test('should return 400 on service failure', () async {
        final request = TestRequest.create(
          method: Method.post,
          url: Uri.parse('http://localhost/register'),
          body: Body.fromString(
            jsonEncode({
              'name': 'Test User',
              'email': 'test@example.com',
              'password': 'password123',
            }),
          ),
        );

        when(
          () => mockAuthService.register(any(), any(), any()),
        ).thenAnswer((_) async => left(const AuthFailure('error')));

        final response = await controller.register(request);

        expect(response.statusCode, equals(400));
        final body = jsonDecode(await response.readAsString());
        expect(body['error'], equals('error'));
      });
    });

    group('login', () {
      test('should return 200 with tokens on successful login', () async {
        final request = TestRequest.create(
          method: Method.post,
          url: Uri.parse('http://localhost/login'),
          body: Body.fromString(
            jsonEncode({
              'email': 'test@example.com',
              'password': 'password123',
            }),
          ),
        );

        final tokens = {'accessToken': 'access', 'refreshToken': 'refresh'};
        when(
          () => mockAuthService.login(any(), any()),
        ).thenAnswer((_) async => right(tokens));

        final response = await controller.login(request);

        expect(response.statusCode, equals(200));
        final body = jsonDecode(await response.readAsString());
        expect(body['accessToken'], equals('access'));
      });

      test('should return 401 on service failure', () async {
        final request = TestRequest.create(
          method: Method.post,
          url: Uri.parse('http://localhost/login'),
          body: Body.fromString(
            jsonEncode({
              'email': 'test@example.com',
              'password': 'password123',
            }),
          ),
        );

        when(
          () => mockAuthService.login(any(), any()),
        ).thenAnswer((_) async => left(const AuthFailure('invalid')));

        final response = await controller.login(request);

        expect(response.statusCode, equals(401));
        final body = jsonDecode(await response.readAsString());
        expect(body['error'], equals('invalid'));
      });
    });
  });
}
