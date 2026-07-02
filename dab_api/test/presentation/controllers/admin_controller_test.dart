import 'dart:convert';

import 'package:dab_api/src/application/containers/auth_usecases.dart';
import 'package:dab_api/src/application/usecases/auth/create_user_by_admin.dart';
import 'package:dab_api/src/domain/core/failures/failure.dart';
import 'package:dab_api/src/domain/entities/user/user_role.dart';
import 'package:dab_api/src/presentation/controllers/admin_controller.dart';
import 'package:fpdart/fpdart.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:relic/relic.dart';
import 'package:test/test.dart';

import '../../test_utils.dart';

class MockAuthUseCases extends Mock implements AuthUseCases {}

class MockCreateUserByAdmin extends Mock implements CreateUserByAdmin {}

void main() {
  group('AdminController.createUser', () {
    late MockAuthUseCases mockAuthUseCases;
    late MockCreateUserByAdmin mockCreateUserByAdmin;
    late AdminController controller;

    setUpAll(() {
      registerFallbackValue(UserRole.standard);
    });

    setUp(() {
      mockAuthUseCases = MockAuthUseCases();
      mockCreateUserByAdmin = MockCreateUserByAdmin();
      when(() => mockAuthUseCases.createUserByAdmin)
          .thenReturn(mockCreateUserByAdmin);

      final sl = GetIt.instance;
      if (sl.isRegistered<AuthUseCases>()) {
        sl.unregister<AuthUseCases>();
      }
      sl.registerSingleton<AuthUseCases>(mockAuthUseCases);

      controller = AdminController();
    });

    Request buildRequest(Map<String, dynamic> payload) {
      return TestRequest.create(
        method: Method.post,
        url: Uri.parse('http://localhost/admin/users'),
        body: Body.fromString(jsonEncode(payload)),
      );
    }

    test('should return 400 when required fields are missing', () async {
      final res = await controller.createUser(
        buildRequest({'name': 'No Email Or Password'}),
      );

      expect(res.statusCode, 400);
      final resBody = jsonDecode(await res.readAsString());
      expect(resBody['error'], contains('required'));
      verifyNever(
        () => mockCreateUserByAdmin.execute(
          any(),
          any(),
          any(),
          role: any(named: 'role'),
        ),
      );
    });

    test('should create a user and omit the password hash', () async {
      final user = TestData.user(email: 'new.user@other.com');
      when(
        () => mockCreateUserByAdmin.execute(
          any(),
          any(),
          any(),
          role: any(named: 'role'),
        ),
      ).thenAnswer((_) async => Right(user));

      final res = await controller.createUser(
        buildRequest({
          'name': 'New User',
          'email': 'new.user@other.com',
          'password': 'securepassword',
          'role': 'manager',
        }),
      );

      expect(res.statusCode, 200);
      final resBody = jsonDecode(await res.readAsString());
      expect(resBody['data']['email'], 'new.user@other.com');
      expect(resBody['data'].containsKey('passwordHash'), isFalse);
      verify(
        () => mockCreateUserByAdmin.execute(
          'New User',
          'new.user@other.com',
          'securepassword',
          role: UserRole.manager,
        ),
      ).called(1);
    });

    test('should map a use case failure to 400', () async {
      when(
        () => mockCreateUserByAdmin.execute(
          any(),
          any(),
          any(),
          role: any(named: 'role'),
        ),
      ).thenAnswer(
        (_) async =>
            const Left(AuthFailure('Account creation restricted to corp.com domain')),
      );

      final res = await controller.createUser(
        buildRequest({
          'name': 'New User',
          'email': 'new.user@other.com',
          'password': 'securepassword',
        }),
      );

      expect(res.statusCode, 400);
      final resBody = jsonDecode(await res.readAsString());
      expect(resBody['error'], contains('restricted to corp.com'));
    });
  });
}
