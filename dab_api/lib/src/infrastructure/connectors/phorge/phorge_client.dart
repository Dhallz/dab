import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../config/config.dart';

class PhorgeClient {
  final String _baseUrl;
  final String _apiToken;
  final http.Client _client;

  PhorgeClient({http.Client? client})
    : _baseUrl = Config().phorgeUrl,
      _apiToken = Config().phorgeApiToken,
      _client = client ?? http.Client();

  Future<Map<String, dynamic>> call(
    String method,
    Map<String, dynamic> params,
  ) async {
    final url = Uri.parse('$_baseUrl/api/$method');

    // Conduit expects api.token in the body for most requests
    final body = {...params, 'api.token': _apiToken};

    try {
      final response = await _client.post(
        url,
        body: jsonEncode(body),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode != 200) {
        throw Exception(
          'Phorge API call failed: ${response.statusCode} ${response.body}',
        );
      }

      final json = jsonDecode(response.body) as Map<String, dynamic>;

      if (json['error_code'] != null) {
        throw Exception(
          'Phorge API Error: ${json['error_code']} - ${json['error_info']}',
        );
      }

      return json['result'] as Map<String, dynamic>;
    } catch (e) {
      rethrow;
    }
  }

  void dispose() {
    _client.close();
  }
}
