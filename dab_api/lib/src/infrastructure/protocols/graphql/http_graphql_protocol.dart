import 'dart:convert';

import 'package:dab_api/src/infrastructure/protocols/graphql/graphql_protocol.dart';
import 'package:dab_api/src/infrastructure/protocols/protocol_exceptions.dart';
import 'package:http/http.dart' as http;

/// [ARCH: INFRASTRUCTURE]
/// ROLE: Default [GraphqlProtocol] using [http.Client].
/// CONTRACT: [defaultTimeout] applies when [timeout] is null on [execute].
class HttpGraphqlProtocol implements GraphqlProtocol {
  final http.Client _client;

  @override
  final Duration defaultTimeout;

  HttpGraphqlProtocol({
    http.Client? client,
    this.defaultTimeout = const Duration(seconds: 12),
  }) : _client = client ?? http.Client();

  @override
  Future<Map<String, dynamic>> execute(
    Uri endpoint, {
    required String bearerToken,
    required String document,
    Map<String, dynamic>? variables,
    Duration? timeout,
  }) async {
    final t = timeout ?? defaultTimeout;
    final body = jsonEncode({
      'query': document,
      'variables': variables ?? <String, dynamic>{},
    });
    final headers = {
      'Authorization': 'Bearer $bearerToken',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    late final http.Response response;
    try {
      response = await _client
          .post(endpoint, headers: headers, body: body)
          .timeout(t);
    } catch (e) {
      throw GraphqlProtocolException(
        message: 'GraphQL POST failed: $e',
        statusCode: null,
      );
    }

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw GraphqlProtocolException(
        message: 'HTTP ${response.statusCode}',
        statusCode: response.statusCode,
      );
    }

    try {
      final decoded = jsonDecode(response.body);
      if (decoded is! Map<String, dynamic>) {
        throw GraphqlProtocolException(
          message: 'Expected JSON object response',
          statusCode: response.statusCode,
        );
      }
      final errors = decoded['errors'];
      if (errors is List && errors.isNotEmpty) {
        throw GraphqlProtocolException(
          message: 'GraphQL errors: ${errors.length} error(s)',
          errors: errors,
          statusCode: response.statusCode,
        );
      }
      final data = decoded['data'];
      if (data is Map<String, dynamic>) {
        return data;
      }
      if (data == null) {
        return {};
      }
      throw GraphqlProtocolException(
        message: 'Unexpected GraphQL `data` shape',
        statusCode: response.statusCode,
      );
    } on GraphqlProtocolException {
      rethrow;
    } catch (e) {
      throw GraphqlProtocolException(
        message: 'Invalid JSON: $e',
        statusCode: response.statusCode,
      );
    }
  }
}
