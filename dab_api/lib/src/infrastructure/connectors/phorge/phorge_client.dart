import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

import '../../config/config.dart';

class PhorgeClient {
  final String _baseUrl;
  final String _apiToken;
  final http.Client _client;

  PhorgeClient({http.Client? client})
    : _baseUrl = Config().phorgeUrl,
      _apiToken = Config().phorgeApiToken,
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
