import 'dart:convert'; // Added for jsonEncode

import 'package:relic/relic.dart';

class GlobalErrorHandler extends MiddlewareObject {
  @override
  Handler call(Handler next) {
    return (request) async {
      try {
        return await next(request);
      } catch (e, stackTrace) {
        print('ERROR: $e');
        print(stackTrace);

        // Standardized error JSON
        return Response.internalServerError(
          body: Body.fromString(
            jsonEncode({
              'error': {
                'message': 'Internal Server Error',
                'details': e.toString(),
              },
            }),
            mimeType: MimeType.json,
          ),
        );
      }
    };
  }
}
