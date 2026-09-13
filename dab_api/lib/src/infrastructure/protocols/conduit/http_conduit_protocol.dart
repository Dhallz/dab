import 'dart:convert';
import 'dart:io';

import 'package:dab_api/src/infrastructure/core/logging/logging_service.dart';
import 'package:dab_api/src/infrastructure/protocols/conduit/conduit_protocol.dart';
import 'package:dab_api/src/infrastructure/protocols/protocol_exceptions.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

import '../../core/config/config.dart';

/// [ARCH: INFRASTRUCTURE]
/// ROLE: HTTP implementation of [ConduitProtocol] for Phorge / Conduit APIs.
/// CONTRACT: Form-urlencoded bodies with flattened params; `api.token` in body.
/// CONSTRAINTS: Read-only; never log tokens or response bodies.
class HttpConduitProtocol implements ConduitProtocol {
  final String _fallbackBaseUrl;
  final String _apiToken;
  final http.Client _client;
  final Future<String?> Function()? _resolveBaseUrl;

  HttpConduitProtocol({
    http.Client? client,
    String? baseUrl,
    String? apiToken,
    Future<String?> Function()? resolveBaseUrl,
  }) : _fallbackBaseUrl = (baseUrl ?? Config().phorgeUrl).trim().replaceAll(
         RegExp(r'/+$'),
         '',
       ),
       _apiToken = (apiToken ?? Config().phorgeApiToken).trim(),
       _client = client ?? _createInsecureClient(),
       _resolveBaseUrl = resolveBaseUrl;

  /// Accept self-signed or internal corporate certificates (matches legacy client).
  static http.Client _createInsecureClient() {
    final ioClient = HttpClient()
      ..badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);
    return IOClient(ioClient);
  }

  Future<String> _effectiveBaseUrl() async {
    final resolved = (await _resolveBaseUrl?.call())?.trim() ?? '';
    if (resolved.isNotEmpty) {
      return resolved.replaceAll(RegExp(r'/+$'), '');
    }
    return _fallbackBaseUrl;
  }

  @override
  Future<Map<String, dynamic>> call(
    String method,
    Map<String, dynamic> params, {
    String? apiToken,
  }) async {
    final root = await _effectiveBaseUrl();
    final url = Uri.parse('$root/api/$method');

    final token = (apiToken ?? _apiToken).trim();
    final body = {...params, 'api.token': token};

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
        throw ConduitException(
          code: 'HTTP_${response.statusCode}',
          info: 'Conduit request failed for method $method',
        );
      }

      final dynamic decoded = jsonDecode(response.body);

      if (decoded is! Map<String, dynamic>) {
        throw ConduitException(
          code: 'INVALID_RESPONSE',
          info:
              'Conduit returned unexpected JSON (expected Map, got ${decoded.runtimeType})',
        );
      }

      final json = decoded;

      if (json['error_code'] != null) {
        throw ConduitException(
          code: json['error_code'].toString(),
          info:
              json['error_info']?.toString() ??
              'Unknown error informational message',
        );
      }

      final result = json['result'];
      if (result is Map<String, dynamic>) {
        return result;
      } else if (result is List) {
        return {'data': result};
      } else {
        return {'value': result};
      }
    } on ConduitException {
      rethrow;
    } catch (e, st) {
      LoggingService.log(
        'Conduit protocol unexpected error',
        level: 'ERROR',
        extra: {
          'method': method,
          'errorType': e.runtimeType.toString(),
          'stack': st.toString(),
        },
      );
      throw ConduitException(code: 'CLIENT_ERROR', info: e.toString());
    }
  }

  @override
  void dispose() {
    _client.close();
  }
}
