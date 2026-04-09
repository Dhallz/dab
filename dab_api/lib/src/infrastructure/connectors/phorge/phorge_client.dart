import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

import '../../config/config.dart';

/// [ARCH: INFRASTRUCTURE_CLIENT]
/// ROLE: Low-level HTTP client for the Phorge (Conduit) API.
/// CONTRACT: Handles authentication (api.token) and protocol-specific serialization.
/// CONSTRAINTS: Must handle x-www-form-urlencoded deep objects for Phorge.
///
/// This client is the "Protocol Layer." It speaks specifically to the Phorge 
/// API's quirks, including the requirement for `api.token` and its custom 
/// form-encoded parameter flattening.
class PhorgeClient {
  final String _baseUrl;
  final String _apiToken;
  final http.Client _client;

  PhorgeClient({http.Client? client, String? baseUrl, String? apiToken})
    : _baseUrl = (baseUrl ?? Config().phorgeUrl).trim().replaceAll(RegExp(r'/+$'), ''),
      _apiToken = (apiToken ?? Config().phorgeApiToken).trim(),
      _client = client ?? _createInsecureClient();

  // Accept self-signed or internal corporate certificates
  static http.Client _createInsecureClient() {
    final ioClient = HttpClient()
      ..badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);
    return IOClient(ioClient);
  }

  Future<Map<String, dynamic>> call(
    String method,
    Map<String, dynamic> params,
  ) async {
    final url = Uri.parse('$_baseUrl/api/$method');

    // Conduit expects api.token in the body for most requests
    final body = {...params, 'api.token': _apiToken};

    // Conduit requires deep array serialization for application/x-www-form-urlencoded
    // e.g. constraints: { query: 'tag' } -> constraints[query]=tag
    final formBody = <String, String>{};

    void flattenParams(String prefix, dynamic value) {
      if (value is Map) {
        value.forEach((k, v) {
          flattenParams(prefix.isEmpty ? k.toString() : '$prefix[$k]', v);
        });
      } else if (value is List) {
        for (var i = 0; i < value.length; i++) {
          flattenParams(
            prefix.isEmpty ? i.toString() : '$prefix[$i]',
            value[i],
          );
        }
      } else if (value != null) {
        formBody[prefix] = value.toString();
      }
    }

    flattenParams('', body);

    try {
      final response = await _client.post(
        url,
        body: formBody,
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      );

      if (response.statusCode != 200) {
        throw Exception(
          'Phorge API call failed: ${response.statusCode} ${response.body}',
        );
      }

      final dynamic decoded = jsonDecode(response.body);
      
      if (decoded is! Map<String, dynamic>) {
        throw Exception(
          'Phorge API returned unexpected JSON format (expected Map, got ${decoded.runtimeType}): ${response.body}',
        );
      }

      final json = decoded;

      if (json['error_code'] != null) {
        throw PhorgeException(
          code: json['error_code'].toString(),
          info: json['error_info']?.toString() ?? 'Unknown error informational message',
        );
      }

      final result = json['result'];
      if (result is Map<String, dynamic>) {
        return result;
      } else if (result is List) {
        return {'data': result}; // Wrap list results to maintain Map return type
      } else {
        return {'value': result};
      }
    } on PhorgeException {
      rethrow;
    } catch (e) {
      print('[CRITICAL] Phorge Client Unexpected Exception: $e');
      throw PhorgeException(code: 'CLIENT_ERROR', info: e.toString());
    }
  }

  void dispose() {
    _client.close();
  }
}

class PhorgeException implements Exception {
  final String code;
  final String info;

  PhorgeException({required this.code, required this.info});

  @override
  String toString() => 'PhorgeException: [$code] $info';
}
