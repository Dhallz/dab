import 'dart:convert';
import 'package:relic/relic.dart';
import '../../application/containers/auth_usecases.dart';
import '../../service_locator.dart';

/// [ARCH: PRESENTATION_CONTROLLER]
/// ROLE: Controller for Authentication and Identity Management.
/// CONTRACT: Maps HTTP requests for registration and login to [AuthUseCases].
/// CONSTRAINTS: Handles JSON parsing and Failure-to-HTTP mapping. Strictly no business logic.
class AuthController {
  final AuthUseCases _auth = sl<AuthUseCases>();
  Future<Response> register(Request request) async {
    final body = await request.readAsString();
    final data = jsonDecode(body);

    final name = data['name'] as String?;
    final email = data['email'] as String?;
    final password = data['password'] as String?;

    if (name == null || email == null || password == null) {
      return Response.badRequest(
        body: Body.fromString(
          jsonEncode({'error': 'Name, email and password are required'}),
          mimeType: MimeType.json,
        ),
      );
    }

    final result = await _auth.registerNewUser.execute(name, email, password);

    return result.match(
      (failure) => Response.badRequest(
        body: Body.fromString(
          jsonEncode({'error': failure.message, 'details': failure.toMap()}),
          mimeType: MimeType.json,
        ),
      ),
      (tokens) => Response.ok(
        body: Body.fromString(jsonEncode(tokens), mimeType: MimeType.json),
      ),
    );
  }

  Future<Response> login(Request request) async {
    final body = await request.readAsString();
    final data = jsonDecode(body);

    final email = data['email'] as String?;
    final password = data['password'] as String?;

    if (email == null || password == null) {
      return Response.badRequest(
        body: Body.fromString(
          jsonEncode({'error': 'Email and password are required'}),
          mimeType: MimeType.json,
        ),
      );
    }

    final result = await _auth.authenticateUser.execute(email, password);

    return result.match(
      (failure) => Response.unauthorized(
        body: Body.fromString(
          jsonEncode({'error': failure.message, 'details': failure.toMap()}),
          mimeType: MimeType.json,
        ),
      ),
      (tokens) => Response.ok(
        body: Body.fromString(jsonEncode(tokens), mimeType: MimeType.json),
      ),
    );
  }

  Future<Response> refresh(Request request) async {
    final body = await request.readAsString();
    final data = jsonDecode(body);

    final refreshToken = data['refreshToken'] as String?;

    if (refreshToken == null) {
      return Response.badRequest(
        body: Body.fromString(
          jsonEncode({'error': 'Refresh token is required'}),
          mimeType: MimeType.json,
        ),
      );
    }

    final result = await _auth.refreshToken.execute(refreshToken);

    return result.match(
      (failure) => Response.unauthorized(
        body: Body.fromString(
          jsonEncode({'error': failure.message, 'details': failure.toMap()}),
          mimeType: MimeType.json,
        ),
      ),
      (tokens) => Response.ok(
        body: Body.fromString(jsonEncode(tokens), mimeType: MimeType.json),
      ),
    );
  }
}
