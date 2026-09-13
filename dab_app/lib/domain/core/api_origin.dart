import 'package:fpdart/fpdart.dart';

import 'failures.dart';

/// [ARCH: DOMAIN]
/// ROLE: Normalize the DAB API origin typed at login.
/// CONTRACT: `http`/`https` only, no trailing slash. Bare hosts get a scheme
/// (`http` for loopback, `https` otherwise).
abstract final class ApiOrigin {
  static const defaultLocal = 'http://localhost:9080';

  static const _invalid = ValidationFailure(
    errors: {
      'apiBase': ['Invalid'],
    },
    message: 'Enter a valid http(s) API URL',
  );

  /// Parses [raw] into a canonical origin or a [ValidationFailure].
  static Either<AppFailure, String> parse(String raw) {
    var text = raw.trim();
    if (text.isEmpty) {
      return const Left(
        ValidationFailure(
          errors: {
            'apiBase': ['Required'],
          },
          message: 'Enter a valid http(s) API URL',
        ),
      );
    }
    if (!text.contains('://')) {
      final host = text.split('/').first.split(':').first.toLowerCase();
      final loopback =
          host == 'localhost' || host == '127.0.0.1' || host == '::1';
      text = '${loopback ? 'http' : 'https'}://$text';
    }
    while (text.endsWith('/')) {
      text = text.substring(0, text.length - 1);
    }
    final uri = Uri.tryParse(text);
    if (uri == null ||
        uri.host.isEmpty ||
        (uri.scheme != 'http' && uri.scheme != 'https')) {
      return const Left(_invalid);
    }
    return Right(text);
  }
}
