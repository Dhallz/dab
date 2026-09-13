import 'dart:convert';

import 'package:relic/relic.dart';

import '../../application/usecases/user/complete_provider_oauth.dart';
import '../../domain/core/failures/failure.dart';
import '../../service_locator.dart';

/// [ARCH: PRESENTATION_CONTROLLER]
/// ROLE: Public OAuth callback (provider redirect). Never returns tokens.
class OauthController {
  Future<Response> callback(Request request) async {
    final provider = (request.pathParameters.raw[#provider] ?? '').toString();
    final params = request.url.queryParameters;
    final error = (params['error'] ?? '').trim();
    if (error.isNotEmpty) {
      return _html(
        title: 'Connection cancelled',
        body: 'The provider reported: $error. You can close this window and return to DAB.',
      );
    }
    final code = (params['code'] ?? '').trim();
    final state = (params['state'] ?? '').trim();
    final result = await sl<CompleteProviderOauth>().execute(
      providerId: provider,
      code: code,
      state: state,
    );
    return result.fold(
      (failure) {
        final status = failure is ValidationFailure ? 400 : 500;
        return _html(
          title: 'Could not connect',
          body: failure.message,
          statusCode: status,
        );
      },
      (summary) {
        final who = summary.externalUsername ?? summary.externalId ?? '';
        final label = who.isEmpty ? summary.providerId : '@$who';
        return _html(
          title: 'Connected',
          body: 'Connected $label. You can close this window and return to DAB.',
        );
      },
    );
  }

  Response _html({
    required String title,
    required String body,
    int statusCode = 200,
  }) {
    final escapedTitle = const HtmlEscape().convert(title);
    final escapedBody = const HtmlEscape().convert(body);
    final html =
        '<!DOCTYPE html><html><head><meta charset="utf-8">'
        '<title>$escapedTitle</title></head><body>'
        '<h1>$escapedTitle</h1><p>$escapedBody</p></body></html>';
    return Response(
      statusCode,
      body: Body.fromString(html, mimeType: MimeType.parse('text/html')),
    );
  }
}
