import 'package:dab_api/src/infrastructure/core/security/jwt_provider.dart';
import 'package:dab_api/src/presentation/middlewares/auth_middleware.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:relic/relic.dart';
import 'package:test/test.dart';

import '../../test_utils.dart';

class _StubJwt implements JwtProvider {
  @override
  String generateToken(Map<String, dynamic> payload) => 'unused';

  @override
  JWT? verifyToken(String token) {
    if (token == 'good-token') {
      return JWT({'sub': 'user-1', 'role': 'admin'});
    }
    return null;
  }
}

void main() {
  late Handler handler;

  setUp(() {
    handler = AuthMiddleware(jwtProvider: _StubJwt()).call((request) async {
      expect(request.userId, 'user-1');
      expect(request.userRole, 'admin');
      return Response.ok(body: Body.fromString('ok'));
    });
  });

  Future<Response> send({Map<String, List<String>>? headers}) async {
    final request = TestRequest.create(
      url: Uri.parse('http://localhost/users/me/credentials'),
      headers: headers,
    );
    return await handler(request) as Response;
  }

  test('401 when Authorization is missing', () async {
    final response = await send();
    expect(response.statusCode, 401);
    expect(await response.readAsString(), 'Missing or invalid token');
  });

  test('accepts a typed Bearer token', () async {
    final response = await send(
      headers: {
        'Authorization': ['Bearer good-token'],
      },
    );
    expect(response.statusCode, 200);
    expect(await response.readAsString(), 'ok');
  });

  test('401 Invalid token when JWT verify fails', () async {
    final response = await send(
      headers: {
        'authorization': ['Bearer stale-token'],
      },
    );
    expect(response.statusCode, 401);
    expect(await response.readAsString(), 'Invalid token');
  });
}
