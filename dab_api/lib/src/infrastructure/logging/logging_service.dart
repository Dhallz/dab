import 'dart:convert';

import 'package:relic/relic.dart';

class LoggingService {
  /// Instance API for DI; identical output to [log].
  void record(
    String message, {
    String level = 'INFO',
    Map<String, dynamic>? extra,
  }) {
    log(message, level: level, extra: extra);
  }

  static void log(
    String message, {
    String level = 'INFO',
    Map<String, dynamic>? extra,
  }) {
    final logEntry = {
      'timestamp': DateTime.now().toIso8601String(),
      'level': level,
      'message': message,
      ...?extra,
    };
    print(jsonEncode(logEntry));
  }
}

class RequestLogger extends MiddlewareObject {
  @override
  Handler call(Handler next) {
    return (request) async {
      final startTime = DateTime.now();
      final requestId =
          request.headers['X-Request-ID']?.first ??
          'req_${startTime.millisecondsSinceEpoch}';

      LoggingService.log(
        'Incoming request',
        extra: {
          'requestId': requestId,
          'method': request.method.name,
          'path': request.url.path,
        },
      );

      final result = await next(request);

      int statusCode = 0;
      if (result is Response) {
        statusCode = result.statusCode;
      }

      final duration = DateTime.now().difference(startTime).inMilliseconds;
      LoggingService.log(
        'Response sent',
        extra: {
          'requestId': requestId,
          'statusCode': statusCode,
          'durationMs': duration,
        },
      );

      if (result is Response) {
        return result.copyWith(
          headers: result.headers.transform(
            (h) => h['X-Request-ID'] = [requestId],
          ),
        );
      }
      return result;
    };
  }
}
