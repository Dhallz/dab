import 'dart:convert';

import 'package:relic/relic.dart';

import '../../application/auth_service.dart';
import '../../service_locator.dart';

class AuthController {
  final AuthService _authService = sl<AuthService>();

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

    final result = await _authService.register(name, email, password);

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

    final result = await _authService.login(email, password);

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
