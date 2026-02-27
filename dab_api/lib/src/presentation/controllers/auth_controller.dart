import 'dart:convert';

import 'package:relic/relic.dart';

import '../../services/auth_service.dart';

class AuthController {
  final AuthService _authService = AuthService();

  Future<Response> register(Request request) async {
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

    final user = await _authService.register(email, password);
    if (user == null) {
      return Response.badRequest(
        body: Body.fromString(
          jsonEncode({'error': 'User already exists'}),
          mimeType: MimeType.json,
        ),
      );
    }

    return Response.ok(
      body: Body.fromString(
        jsonEncode({'message': 'User registered successfully', 'id': user.id}),
        mimeType: MimeType.json,
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

    final tokens = await _authService.login(email, password);
    if (tokens == null) {
      return Response.unauthorized(
        body: Body.fromString(
          jsonEncode({'error': 'Invalid credentials'}),
          mimeType: MimeType.json,
        ),
      );
    }

    return Response.ok(
      body: Body.fromString(jsonEncode(tokens), mimeType: MimeType.json),
    );
  }
}
